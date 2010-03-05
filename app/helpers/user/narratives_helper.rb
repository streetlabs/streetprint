module User::NarrativesHelper
  
  def embed_audio(file_list)
    return if file_list == nil
    list="mp3="
    
    file_list.each do  |media_file|
      if media_file.file_type.downcase == "mp3"
        list << media_file.file.url.split("?")[0]
        list << "|" unless media_file == file_list.last
      end
    end
    
    list == "mp3=" ? nil : list
  end
  
end
