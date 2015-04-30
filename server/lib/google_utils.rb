module GoogleUtils
  def self.login
    GoogleDrive.login(ENV["EMAIL"], ENV["PASSWORD"])
  end

  # TODO: There shold already be a new link waiting for a new user
  # in the cache. the user will get that URL and a new one 
  # should be created on a different thread and update the cache
  def self.new_spreadsheet_for(username)
    require "rubygems"
    require "google/api_client"
    require "google_drive"


    session = login

    # Finding the sample file
    sample_file = session.file_by_title("copy of something")

    new_title = "Yonti Phrases for #{username}"
    new_file = sample_file.duplicate(new_title)

    # Adding the sample file to the folder, with new title
    yonti_folder = session.collection_by_title("yonti2")
    yonti_folder.add new_file

    bla = yonti_folder.files.find { |file| file.title == new_title }

    # Returning the human_url, to be saved in the new user row
    bla.human_url
  end

  def self.read_all_sheets
    session = login
    yonti_folder = session.collection_by_title("yonti2")

    # The connection that I have to the user itself 
    # is the human_url that is saved for each user
    res = {}
    yonti_folder.files.each do |file|
      rows = file.worksheets.first.rows
      res [ file.human_url ] = rows
    end
    res
  end

  def self.latest_users_data
    google_data = self.read_all_sheets
    all_data = {}
    User.all.each do |user|
      user_data = google_data[user.google_url]

      # Filter out rows with empty cells
      clean_user_data = user_data.reject { |row| row.include? "" }
      all_data[user.name] = clean_user_data 
    end

    all_data
  end

  def self.users_data
    data = Rails.cache.fetch("users_data") do 
      self.latest_users_data
    end
    data
  end
end
