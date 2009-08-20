require 'rubygems'
require 'thinking_sphinx'

desc 'import the Streetprint db'
task :import_streetprint => :environment do
  
  # configuration comes after method definitions
  
  def ask message, answer = /.*/, add_options_string = answer == /.*/ ? false : true
    message = message + ' (' + answer.source + ')' if add_options_string
    begin
      print message
      input = STDIN.gets.chomp
    end while input !~ /^#{answer}$/
    input
  end
  
  def get_sp_version
    if File.exist?(path = $streetprint_path + "sp_initialization.inc")
      found = false
      File.open(path).each do |line|
        if line =~ /sp_version/
          line =~ /.*(\d\.\d).*/
          found = true
          $version = $1.to_f
        end
      end
    elsif File.exist?(path = $streetprint_path + "include/sp_initialization.inc")
      found = false
      File.open(path).each do |line|
        if line =~ /sp_version/
          line =~ /.*(\d\.\d).*/
          found = true
          $version = $1.to_f
        end
      end
    else
      puts "Couldn't find version of streetprint site."
      exit
    end
    unless found
      puts "Failed to find version of streetprint site."
      exit
    end
    puts "Found site version to be #{$version}."
    $images_path = $streetprint_path + "Libraries/imagelibrary/" if $version > 2.1
    $media_path = $streetprint_path + "Libraries/medialibrary/" if $version > 2.1
    $images_path = $streetprint_path + "imagelibrary/" if $version <= 2.1
    $media_path = $streetprint_path + "medialibrary/" if $version <= 2.1
  end
  
  # assumes categories/doc types already exist, creates authors if they don't exist
  def import_texts_items(site)
    texts = Streetprint::Text.find(:all)
    texts.each do |text|
      raise "Text doesn't have title..." if text.title.blank?
      
      if site.items.find_by_title(text.title)
        puts "Skipping item #{text.title}."
        next
      end
      
      puts "Creating item #{text.title}."
      item = Item.new
      
      item.title = text.title
      
      unless text.author.blank?
        author = site.authors.find_or_create_by_name(text.author)
        author.save!
        item.authors << author
      end
      
      item.publisher = text.publisher
      
      item.city = text.city
      
      item.document_type = DocumentType.find_by_reference_id(text.doctype)
      
      if $date_strategy == 1
        begin
          date = Date.parse text.date_text
        rescue ArgumentError
          date = Date.strptime(text.date_text, '%Y')
        end
      elsif $date_strategy == 2
        date = Date.strptime(text.date_num.to_s, '%Y')
        item.date_details = text.date_text
      else
        puts "No date strategy"
        exit
      end
      
      item.date = date
      
      item.notes = text.notes
      
      item.pagination = text.pagination
      
      item.illustrations = text.illustrations
      
      # Categories
      s = text.category
      unless s == "N;"
        n = s[2..2] # number of categories
        s = s[5..-2] # trim un-needed
        s = s.split(';')
        cat_ids = []
        s.each_with_index do |s, i|
          next if i % 2 == 0 # every second entry
          s =~ /.*"(\d+)".*/
          cat_ids << $1
        end
      
        cat_ids.each do |id|
          scrawl_cat = Streetprint::Category.find(id)
          sp5_cat = site.categories.find_by_name(scrawl_cat.name)
          raise "Missing category #{scrawl_cat.name}" unless sp5_cat
          item.categories << sp5_cat
        end
      end
      
      item.dimensions = text.dimensions
      
      item.location = text.location
      
      item.site = site
      
      item.text_id = text.id
      item.save!;
    end
  end
  
  # use the (gross) logic from the old streetprint to find the photo families
  # add in the best resolution from each family
  def import_images(site)
    # get all the thumbnails
    thumb_id = 1
    images = Streetprint::Image.find(:all, :conditions => { :resolution => thumb_id })
    # for each thumb we find the siblings
    images.each do |thumb|
      unless site.items.find_by_text_id(thumb.text_id)
        puts "photo #{thumb.inspect} text no longer exists, skipping"
        next
      end
      conditions = {}
      
      conditions[:text_id] = thumb.text_id
      if $version > 3 && !thumb.image_order.blank?
        conditions[:image_order] = thumb.image_order
      end
      if (!thumb.firstpagenum.blank?) && (!thumb.numpages.blank?)
        conditions[:firstpagenum] = thumb.firstpagenum
        conditions[:numpages] = thumb.numpages
      end
      if !thumb.caption.blank?
        conditions[:caption] = thumb.caption
      end
      if $version > 3 && !thumb.famNum.blank?
        conditions[:famnum] = thumb.famnum
      end
    
      # puts "conditions used: " + conditions.inspect
      result = Streetprint::Image.find(:all, :conditions => conditions)
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
      resolution = Streetprint::Resolution.find_by_id(best_image.resolution)
      resolution = resolution.name.downcase if resolution
      filepre = $images_path + "#{best_image.text_id}-#{best_image.id}#{resolution}"
      formats = ['.jpg', '.gif', '.png']
      found = false
      for format in formats
        filename = filepre + format
        # puts "Looking for image #{filename} ..."
        if File.exist? filename
          found = true
          photo_file_name = "#{best_image.text_id}-#{best_image.id}#{resolution}#{format}"
          # puts "Found image #{filename}."
          break
        end
      end
      unless found
        puts "_______________________Unable to find file for image #{filepre}#{formats.inspect} _______________________________________"
        input = ask("continue anyway?", /y|n/)
        if input == 'n'
          exit
        end
        next
      end
      
      item = site.items.find_by_text_id(best_image.text_id)
      if item
        attributes = {}
        attributes[:photo] = File.new(filename)
        attributes[:caption] = best_image.caption
        attributes[:order] = best_image.image_order if $version > 3
        attributes[:image_id] = best_image.id

        existing_photos = item.photos.map { |p| p.image_id}
        unless existing_photos.include? best_image.id
          puts "Adding image #{filename}."
          item.photo_attributes = [attributes]
          item.save!
        else
          puts "Skipping photo #{filename}."
        end
      else
        puts "photo #{best_image.inspect} text no longer exists, skipping"
      end
    end
  end
  
  def import_categories(site)
    categories = Streetprint::Category.all
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
    doctypes = Streetprint::Doctype.all
    doctypes.each do |scrawl_dt|
      dt = site.document_types.find_by_name(scrawl_dt.name)
      unless dt
        puts "Creating document type #{scrawl_dt.name}."
        sp_dt = site.document_types.new
        sp_dt.name = scrawl_dt.name
        sp_dt.description = scrawl_dt.description
        sp_dt.reference_id = scrawl_dt.id
        sp_dt.save!
      else
        puts "Skipping document type #{scrawl_dt.name}, already exists."
      end
    end
  end
  
  def import_full_texts(site)
    fulltexts = Streetprint::Fulltext.all
    fulltexts.each do |ft|
      item = site.items.find_by_text_id(ft.text_id)
      unless item
        puts "skipping fulltext #{ft.inspect}, no text to map to"
        next
      end
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
    news = Streetprint::News.all
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

  def import_site(user)
    sp4_site = Streetprint::Spconfig.first
    raise "No spconfig record." unless sp4_site
    
    site = user.sites.find_by_name(sp4_site.sitename)
    unless site
      puts "Creating site #{sp4_site.sitename}"
      site = user.sites.new
      
      site.name = sp4_site.sitename
      site.title = sp4_site.pagetitle.gsub(' ', '.').gsub(':', '.').slice(0..34) # title can be changed. (only used for url)
      site.welcome_blurb = sp4_site.welcomeblurb
      site.about_project = sp4_site.aboutproject
      site.about_procedures = sp4_site.aboutprocedures
      site.singular_item = sp4_site.textsingular
      site.plural_item = sp4_site.textplural
      site.fine_print = sp4_site.fineprint
      if sp4_site.respond_to?('defaultstyle') && ['default', 'default_hex', 'parchment'].include?(sp4_site.defaultstyle.downcase)
        site.style = sp4_site.defaultstyle.downcase
      else
        site.style = 'default'
      end
      
      site.save!
      Membership.create!(:site => site, :user => user)
      user.has_role!(:owner, site)
    else
      puts "Using site #{site.name}"
    end
    
    site
  end
  
  def set_featured_item_and_image(site)
    sp4_site = Streetprint::Spconfig.first
    raise "No spconfig record." unless sp4_site
    puts "Setting featured item and image.."
    featured_item = site.items.find_by_text_id(sp4_site.featuredtext)
    site.featured_item = featured_item.id
    featured_image = featured_item.photos.find_by_image_id(sp4_site.featuredtext_img)
    unless featured_image
      potential_images = featured_item.photos.map { |p| p.id }.sort
      for id in potential_images
        if id > sp4_site.featuredtext_img
          site.featured_image = id
          break
        end
      end
    else
      site.featured_image = featured_image.id
    end
    site.save!
  end
  
  def find_date_strategy
    texts = Streetprint::Text.find(:all)
    texts.each do |text|
      begin
        date = Date.parse text.date_text
      rescue ArgumentError
        begin
          date = Date.strptime(text.date_text, '%Y')
        rescue
          $fail = true
          break
        end
      end
    end
    if !$fail
      puts "Using date strategy 1"
      $date_strategy = 1
      return
    else
      puts "Date strategy 1 will not work."
    end
    $fail = false
    texts.each do |text|
      next if (text.date_num == 0) || (text.date_num == 1)      
      begin
        date = Date.strptime(text.date_num.to_s, '%Y')
      rescue ArgumentError
        $fail = true
        break
      end
    end
    if !$fail
      puts "Using date strategy 2"
      $date_strategy = 2
      return
    else
      puts "Date strategy 2 will not work."
      exit
    end
  end
  
  def import_media(site)
    Streetprint::Media.all.each do |media|
      item = site.items.find_by_text_id(media.text_id)
      mediatype = Streetprint::Mediatype.find(media.mediatype)
      
      Dir.open($media_path).each do |file|
        if file =~ /^#{media.id}./
          @media_file = file
        end
      end
      unless @media_file
        if File.exist?(path = $media_path + media.name)
          @media_file = File.new path
        end
      end
      
      unless @media_file
        puts "Failed to find file for media file #{media.name}"
        exit
      end
      
      m = MediaFile.new
      m.item = item
      m.title = media.name
      m.description = media.description
      m.file_type = mediatype.name
      m.file = @media_file
      
      exists = MediaFile.find_by_title(m.title, :conditions => ["item_id in (?)", site.items.map { |s| s.id }.join(", ")] )
      if exists && exists == MediaFile.find_by_description(m.description, :conditions => ["item_id in (?)", site.items.map { |s| s.id }.join(", ")] )
        puts "Skipping media #{m.title}"
      else
        puts "Adding media #{m.title}"
        m.save
      end
    end
  end
  
  def add_contributers(site)
    $admins.each do |email, password|
      user = get_or_create_user(email, password)
      unless site.users.include? user
        Membership.create!(:site => site, :user => user)
        user.has_role!(:admin, site)
        puts "Added user #{email} to site #{site.name}"
      else
        puts "User #{email} already a member of site #{site.name}"
      end
    end
  end
  
  def get_or_create_user(email, password)
    user = User.find_by_email(email)
    unless user
      puts "Creating user #{email} with password #{password}"
      user = User.create!(:email => email, :password => password, :password_confirmation => password, :active => true)
      user.active = true
      user.save!
    else
      puts "User #{email} already existed."
    end
    user
  end
  
  def get_db_name    
    if File.exist?(path = $streetprint_path + "sp_config.php")
      $config_path = path
    elsif File.exist?(path = $streetprint_path + "sp_config.inc")
      $config_path = path
    end
    
    if $config_path
      File.open($config_path).each do |line|
        if line =~ /db_name/
          line =~ /.*"(.*)".*/
          return $1
        end
      end
    else
      puts "Unable to find database name"
      exit
    end
    puts "Unable to find database name"
    exit
  end
  
  
  #### configure here #########
  
  $site = ask("Please enter name of folder containing site.")
  $streetprint_path = "/Users/crayment/Desktop/Streetprint/Streetprint/#{$site}"
  
  $email = "crayment16@gmail.com"
  $password = "password"
  $admins = { "mark@streetprint.org" => "password" }
  
  #### end config ##############
  
  
  $streetprint_path += "/" unless $streetprint_path[-1..-1] == '/'
  unless File.exist? $streetprint_path
    puts "Directory does not exist: #{$streetprint_path}"
    exit
  end
  
  dbname = get_db_name
  
  if ask("database name is #{dbname}. Continue?", /y|n/) == 'n'
    exit
  end
  
  $streetprint = {
    :adapter  => "mysql",
    :host     => "localhost",
    :username => "root",
    :password => "mysql",
    :database => "#{dbname}",
    :pool => "5",
    :socket => "/tmp/mysql.sock"
  }
  
  module Streetprint
    class Text < ActiveRecord::Base 
      establish_connection $streetprint
      has_many :images
    end
    class Image < ActiveRecord::Base
      establish_connection $streetprint
      belongs_to :text
    end
    class Imageformat < ActiveRecord::Base
      establish_connection $streetprint
    end
    class Resolution < ActiveRecord::Base
      establish_connection $streetprint
    end
    class Category < ActiveRecord::Base
      establish_connection $streetprint
    end
    class Doctype < ActiveRecord::Base
      establish_connection $streetprint
    end
    class Fulltext < ActiveRecord::Base
      establish_connection $streetprint
    end
    class News < ActiveRecord::Base
      establish_connection $streetprint
    end
    class Spconfig < ActiveRecord::Base
      set_table_name 'spconfig'
      establish_connection $streetprint
    end
    class Media < ActiveRecord::Base
      set_table_name 'media'
      establish_connection $streetprint
    end
    class Mediatype < ActiveRecord::Base
      establish_connection $streetprint
    end
  end
  
  # -----------------------------------------------------
  
  user = get_or_create_user($email, $password)
  
  get_sp_version
  find_date_strategy
  site = import_site(user)
  import_categories(site)
  import_document_types(site)
  import_texts_items(site)
  import_images(site)
  set_featured_item_and_image(site)
  import_full_texts(site)
  import_news(site) if $version > 2.1
  import_media(site)
  add_contributers(site)
  
  puts "Completed successfully"
end
