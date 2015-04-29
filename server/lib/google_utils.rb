module GoogleUtils
  def self.new_spreadsheet_for(username)
    require "rubygems"
    require "google/api_client"
    require "google_drive"


    session = GoogleDrive.login(ENV["EMAIL"], ENV["EMAIL_PASSWORD"])
    sample_file = session.file_by_title("copy of something")

    new_title = "Yonti Phrases for #{username}"
    new_file = sample_file.duplicate(new_title)

    yonti_folder = session.collection_by_title("yonti2")
    yonti_folder.add new_file

    bla = yonti_folder.files.find { |file| file.title == new_title }
    bla.human_url
  end
end
