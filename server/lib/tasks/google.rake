require "google_utils"
namespace :google do

  desc "write sheet task for easier testing"
  task write_sheet: :environment do
    require 'securerandom'

    # Simulating a unique username
    GoogleUtils.new_spreadsheet_for SecureRandom.uuid
  end

  task read_all_sheets: :environment do
    GoogleUtils.read_all_sheets
  end

  task update_latest_users_data: :environment do
    Rails.cache.write("users_data", GoogleUtils.latest_users_data)
  end
end
