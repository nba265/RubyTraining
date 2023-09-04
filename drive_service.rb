# frozen_string_literal: true

require 'google_drive'

class DriveService
  def initialize(credentials_json_path)
    @session = GoogleDrive::Session.from_config(credentials_json_path)
  end

  def upload_file(local_file_path, remote_file_path, convert: false)
    @session.upload_from_file(local_file_path, remote_file_path, convert: convert)
  end

  def list_files
    @session.files.each do |file|
      puts "File name: #{file.title}"
    end
  end
end
