require 'rubygems'
require 'ActiveRecord'
require 'thinking_sphinx'
require 'ruby-debug'

desc 'import the Streetprint40 db'
task :import_streetprint_40 => :environment do
  
  $streetprint40 = {
    :adapter  => "mysql",
    :host     => "localhost",
    :username => "root",
    :password => "mysql",
    :database => "Scrawl40",
    :pool => "5",
    :socket => "/tmp/mysql.sock"
  }
  
  $streetprint_40_path = "/Users/crayment/Sites/Scrawl40/"
  $images_path = $streetprint_40_path + "Libraries/imagelibrary/"
  
  email = "crayment16@gmail.com"
  password = "buck&1HALF"
  site_name = "Scrawl"
  
  
  
  module Streetprint40
    class Text < ActiveRecord::Base
      establish_connection $streetprint40
      has_many :images
    end
    class Image < ActiveRecord::Base
      establish_connection $streetprint40
      belongs_to :text
    end
    class Imageformat < ActiveRecord::Base
      establish_connection $streetprint40
    end
    class Resolution < ActiveRecord::Base
      establish_connection $streetprint40
    end
    class Category < ActiveRecord::Base
      establish_connection $streetprint40      
    end
    class Doctype < ActiveRecord::Base
      establish_connection $streetprint40
    end
    class Fulltext < ActiveRecord::Base
      establish_connection $streetprint40
    end
    class News < ActiveRecord::Base
      establish_connection $streetprint40
    end
  end
  
  # assumes categories/doc types already exist, creates authors if they don't exist
  def import_texts_items(site)
    texts = Streetprint40::Text.find(:all)
    texts.each do |text|
      raise "Text doesn't have title..." if text.title.blank?
      
      if site.items.find_by_title(text.title)
        puts "Skipping item #{text.title}."
        next
      end
      
      puts "Creating item #{text.title}."
      item = Item.new
      
      item.title = text.title
      
      author = site.authors.find_or_create_by_name(text.author)
      author.save!
      item.authors << author
      
      item.publisher = text.publisher
      
      item.city = text.city
      
      document_type = DocumentType.find(text.doctype)
      
      begin
        date = Date.parse text.date_text
      rescue ArgumentError
        date = Date.strptime(text.date_text, '%Y')
      end
      
      item.date = date
      
      item.notes = text.notes
      
      item.pagination = text.pagination
      
      item.illustrations = text.illustrations
      
      # Categories é
      s = text.category
      unless s == "N;"
        n = s[2..2] # number of categories
        s = s[5..-2] # trim un-needed
        s = s.split(';')
        cat_ids = []
        s.each_with_index do |s, i|
          next if i % 2 == 0 # every second entry
          cat_ids << s[-2..-2]
        end
      
        cat_ids.each do |id|
          scrawl_cat = Streetprint40::Category.find(id)
          sp5_cat = site.categories.find_by_name(scrawl_cat.name)
          raise "Missing category #{scrawl_cat.name}" unless sp5_cat
          item.categories << sp5_cat
        end
      end
      
      item.dimensions = text.dimensions
      
      item.location = text.location
      
      item.site = site
      
      # puts "Saving item #{item.inspect}\n with photos #{item.photos.inspect}\n\n"
      item.text_id = text.id
      item.save!;
    end
  end
  
  # use the (gross) logic from the old streetprint to find the photo families
  # add in the best resolution from each family
  def import_images(site)
    # get all the thumbnails
    thumb_id = 1
    images = Streetprint40::Image.find(:all, :conditions => { :resolution => thumb_id })
    # for each thumb we find the siblings
    images.each do |thumb|
      conditions = {}
      
      conditions[:text_id] = thumb.text_id
      if !thumb.image_order.blank?
        conditions[:image_order] = thumb.image_order
      end
      if (!thumb.firstpagenum.blank?) && (!thumb.numpages.blank?)
        conditions[:firstpagenum] = thumb.firstpagenum
        conditions[:numpages] = thumb.numpages
      end
      if !thumb.caption.blank?
        conditions[:caption] = thumb.caption
      end
      if !thumb.famNum.blank?
        conditions[:famnum] = thumb.famnum
      end
    
      # puts "conditions used: " + conditions.inspect
      result = Streetprint40::Image.find(:all, :conditions => conditions)
      image_family = {}
      have_thumb = false
      result.each do |image|
        break if (image.resolution.id == thumb_id) && have_thumb
        have_thumb = true if image.resolution.id == thumb_id
        image_family[image.resolution] = image
      end
      
      # now we have our image family according to the sp4 logic
      # take the best resolution image in the family and add it to the item
      best_image = image_family[image_family.keys.last]
      
      # find the file
      resolution = Streetprint40::Resolution.find(best_image.resolution).name.downcase
      filepre = $images_path + "#{best_image.text_id}-#{best_image.id}#{resolution}"
      formats = ['.jpg', '.gif', '.png']
      found = false
      for format in formats
        filename = filepre + format
        # puts "Looking for image #{filename} ..."
        if File.exists? filename
          found = true
          photo_file_name = "#{best_image.text_id}-#{best_image.id}#{resolution}#{format}"
          # puts "Found image #{filename}."
          break
        end
      end
      raise "Unable to find file for image #{filepre}#{formats.inspect}" unless found
      
      item = Item.find_by_text_id(best_image.text_id)
      attributes = { :photo => File.new(filename), :caption => best_image.caption, :order => best_image.image_order, :image_id => best_image.id }
      existing_photos = item.photos.map { |p| p.image_id}
      unless existing_photos.include? best_image.id
        puts "Adding image #{filename}."
        item.photo_attributes = [attributes]
        item.save!
      else
        puts "Skipping photo #{filename}."
      end
    end
  end
  
  def import_categories(site)
    categories = Streetprint40::Category.all
    categories.each do |scrawl_cat|
      cat = site.categories.find_by_name(scrawl_cat.name)
      unless cat
        puts "Creating category #{scrawl_cat.name}."
        sp_cat = site.categories.new
        sp_cat.name = scrawl_cat.name
        sp_cat.description = scrawl_cat.description
        sp_cat.save!
      else
        puts "Skipping category #{scrawl_cat.name}, already exists."
      end
    end
  end
  
  def import_document_types(site)
    doctypes = Streetprint40::Doctype.all
    doctypes.each do |scrawl_dt|
      dt = site.document_types.find_by_name(scrawl_dt.name)
      unless dt
        puts "Creating document type #{scrawl_dt.name}."
        sp_dt = site.document_types.new
        sp_dt.name = scrawl_dt.name
        sp_dt.description = scrawl_dt.description
        sp_dt.save!
      else
        puts "Skipping document type #{scrawl_dt.name}, already exists."
      end
    end
  end
  
  def import_full_texts(site)
    fulltexts = Streetprint40::Fulltext.all
    fulltexts.each do |ft|
      item = Item.find_by_text_id(ft.text_id)
      if item.full_text.blank?
        puts "Updating fulltext for #{item.title}"
        item.full_text = ft.full
        item.save!
      else
        puts "Skipping fulltext for item #{item.title}"
      end
    end
  end
  
  def import_news(site)
    news = Streetprint40::News.all
    news.each do |news|
      existing_posts = NewsPost.all.map { |n| [n.title, n.content] }
      unless existing_posts.include? [news.title, news.newsitem]
        puts "Creating news post #{news.title}"
        news_post = site.news_posts.new
        news_post.title = news.title
        news_post.content = news.newsitem
        news_post.save!
      else
        puts "Skipping news post #{news.title}"
      end
    end
  end

  user = User.find_by_email(email)
  unless user
    puts "Creating user #{email} with password #{password}"
    user = User.create!(:email => email, :password => password, :password_confirmation => password, :active => true)
    user.active = true
    user.save!
  else
    puts "Using user #{email}"
  end
  raise "Expected user #{email} to exist" unless user
  site = user.sites.find_by_name(site_name)
  unless site
    puts "Creating site #{site_name}"
    site = user.sites.new
    site.name = site_name
    site.save!
    role = Role.find_or_create_by_name('admin')
    Membership.create!(:site => site, :user => user, :role => role)
  else
    puts "Using site #{site_name}"
  end
  
  import_categories(site)
  import_document_types(site)
  import_texts_items(site)
  import_images(site)
  import_full_texts(site)
  import_news(site)
end
