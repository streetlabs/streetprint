require 'rubygems'
require 'faster_csv'

namespace :populate do
  begin
    desc 'Load the data from the data.csv file to popluate a streetprint site.'
    task :arch => :environment do
      
      site_id = 1
    
      portion_type = CustomDataType.create(:name => "Object Portion", :description => "Object_Portion", :site_id => site_id)
      material_type = CustomDataType.create(:name => "Material", :description => "Material", :site_id => site_id)
      pattern_type = CustomDataType.create(:name => "Pattern", :description => "Pattern/Decorative_Motif", :site_id => site_id)
      color_type = CustomDataType.create(:name => "Colour", :description => "Colour", :site_id => site_id)
      marks_type = CustomDataType.create(:name => "Marks", :description => "Marks", :site_id => site_id)
      technique_type = CustomDataType.create(:name => "Manufacturing Technique", :description => "Manufacturing_Technique", :site_id => site_id)
      manufacturer_type = CustomDataType.create(:name => "Manufacturer", :description => "Manufacturer", :site_id => site_id)
      condition_type = CustomDataType.create(:name => "Condition", :description => "Condition", :site_id => site_id)
      borden_number_type = CustomDataType.create(:name => "Borden Number", :description => "Borden_Number", :site_id => site_id)
      depth_type = CustomDataType.create(:name => "Depth Below Surface", :description => "Depth_Below_Surface", :site_id => site_id)
      ref_type = CustomDataType.create(:name => "Unique Reference ID", :description => "Unique_Reference_Id", :site_id => site_id)    
    
      FCSV.open("./tmp/data.csv", 'r', :headers => true).each do |row|
        #if Item.find_by_reference_number(row[2]) == nil then
          item = Item.new
          item.site_id = site_id
          item.title = row[1]
          item.date_details = row[5] unless row[5] == nil
          item.dimensions = row[6] unless row[6] == nil
          item.pagination = row[7] unless row[7] == nil
          item.location = row[9] unless row[9] == nil
          item.notes = row[10] unless row[10] == nil
          item.publisher = row[8] unless row[8] == nil
          item.full_text = row[14] unless row[14] == nil
          item.reference_number = row[2] unless row[2] == nil
          
          # AUTHOR
          
          if row[8] != nil then
            if Author.find_by_name(row[8]) == nil then
              item.authors << Author.create(:name => row[8], :site_id => site_id)
            else  
              item.authors << Author.find_by_name_and_site_id(row[8], site_id)
            end
          end
          
          # DOCUMENT_TYPE -> RECORD_TYPE
          if row[4] != nil then
            if DocumentType.find_by_name(row[4]) == nil then
              item.document_type = DocumentType.create(:name => row[4], :site_id => site_id)
            else  
              item.document_type = DocumentType.find_by_name_and_site_id(row[4], site_id)
            end
          end
          
          # CATEGORIES
          categories = Array.new
          categories << row[3]
          categories << row[11]
          categories << row[12]
          categories << row[13]
        
          categories.each do |category|
            if Category.find_by_name(category) == nil then
              item.categories << Category.create(:name => category, :site_id => site_id)
            else
              item.categories <<  Category.find_by_name_and_site_id(category, site_id)
            end
          end
          
          # PHOTOS
          
          if File.exist?("/uofm-images/"+row[0]+"A.jpg") then
            photoA = File.new("/uofm-images/"+row[0]+"A.jpg")
            attributes = {}
            attributes[:photo] = photoA
            item.photo_attributes = [attributes]
            item.save!
          else
            photoA = File.new("/uofm-images/no-image.jpg")
            attributes = {}
            attributes[:photo] = photoA
            item.photo_attributes = [attributes]
            item.save!
          end
          
          if File.exist?("/uofm-images/"+row[0]+"B.jpg") then
            photoB = File.new("/uofm-images/"+row[0]+"B.jpg")
            attributes = {}
            attributes[:photo] = photoB
            item.photo_attributes = [attributes]
            item.save!
          end
          
          if File.exist?("/uofm-images/"+row[0]+"C.jpg") then
            photoC = File.new("/uofm-images/"+row[0]+"C.jpg")
            attributes = {}
            attributes[:photo] = photoC
            item.photo_attributes = [attributes]
            item.save!
          end
          
          if File.exist?("/uofm-images/"+row[0]+"D.jpg") then
            photoD = File.new("/uofm-images/"+row[0]+"D.jpg")
            attributes = {}
            attributes[:photo] = photoD
            item.photo_attributes = [attributes]
            item.save!
          end
            
          
          # DOCUMENT_TYPE -> RECORD_TYPE
          if row[15] != nil then
            item.custom_datas << CustomData.create(:data => row[15], :custom_data_type => portion_type, :data_targetable => item, :site_id => site_id)
          end
          
          if row[16] != nil then
            item.custom_datas << CustomData.create(:data => row[16], :custom_data_type => material_type, :data_targetable => item, :site_id => site_id)
          end
          
          if row[17] != nil then
            item.custom_datas << CustomData.create(:data => row[17], :custom_data_type => pattern_type, :data_targetable => item, :site_id => site_id)
          end
          
          if row[18] != nil then
            item.custom_datas << CustomData.create(:data => row[18], :custom_data_type => color_type, :data_targetable => item, :site_id => site_id)
          end
          
          if row[19] != nil then
            item.custom_datas << CustomData.create(:data => row[19], :custom_data_type => marks_type, :data_targetable => item, :site_id => site_id)
          end
          
          if row[20] != nil then
            item.custom_datas << CustomData.create(:data => row[20], :custom_data_type => technique_type, :data_targetable => item, :site_id => site_id)
          end
          
          if row[21] != nil then
            item.custom_datas << CustomData.create(:data => row[21], :custom_data_type => manufacturer_type, :data_targetable => item, :site_id => site_id)
          end
          
          if row[22] != nil then
            item.custom_datas << CustomData.create(:data => row[22], :custom_data_type => condition_type, :data_targetable => item, :site_id => site_id)
          end
          
          if row[23] != nil then
            item.custom_datas << CustomData.create(:data => row[23], :custom_data_type => borden_number_type, :data_targetable => item, :site_id => site_id)
          end
          
          if row[24] != nil then
            item.custom_datas << CustomData.create(:data => row[24], :custom_data_type => depth_type, :data_targetable => item, :site_id => site_id)
          end
          
          if row[0] != nil then
            item.custom_datas << CustomData.create(:data => row[0], :custom_data_type => ref_type, :data_targetable => item, :site_id => site_id)
          end
        
          item.published = 1
          item.save!
          puts item.to_s + "\r\n"
        end
      #end
    end
  rescue LoadError
    desc 'Could not find or load data file.'
    task :csv do
      abort 'Data was not loaded.'
    end
  end
end
