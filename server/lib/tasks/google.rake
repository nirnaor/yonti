require "google_utils"
namespace :google do

  desc "write sheet task for easier testing"
  task write_sheet: :environment do
    require 'securerandom'

    # Simulating a unique username
    GoogleUtils.new_spreadsheet_for SecureRandom.uuid
  end
end