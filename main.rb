# frozen_string_literal: true

require 'rubygems'
require 'zip'
require 'caracal'
require 'csv'
require_relative 'api_service'
require_relative 'drive_service'

def active_users(api_service)
  puts 'GET ALL ACTIVE USERS  '.center(50, '-')
  active_users = api_service.users_active

  active_users.each { |user| puts user }
rescue StandardError => e
  puts "Error: #{e.message}"
end

def create_user(api_service)
  puts 'CREATE USER'.center(50, '-')
  print 'Enter your name: '
  name = gets.chomp
  print 'Enter your sex: '
  sex = gets.chomp.downcase
  print 'Enter your active: '
  active = gets.chomp.downcase
  print 'Enter your avatar link: '
  avatar = gets.chomp
  puts ''
  new_user = User.new({ name: name, sex: sex, active: active, avatar: avatar })
  raise 'The Parameter is Incorrect, try again!' unless valid_user?(new_user)

  new_user.active = active == 'true'
  create_new_user = api_service.create_user(new_user)

  puts "Create new user: #{create_new_user}"
rescue StandardError => e
  puts "Error: #{e.message}"
end

def edit_user(api_service, id)
  puts 'EDIT USER'.center(50, '-')
  print 'Enter your name: '
  name = gets.chomp
  print 'Enter your sex: '
  sex = gets.chomp.downcase
  print 'Enter your active: '
  active = gets.chomp.downcase
  print 'Enter your avatar link: '
  avatar = gets.chomp
  puts ''
  user = User.new({ name: name, sex: sex, active: active, avatar: avatar })
  raise 'The Parameter is Incorrect, try again!' unless valid_user?(user)

  user.active = active == 'true'
  edit_user = api_service.edit_user_by_id(user, id.to_i)

  puts "Edit user: #{edit_user}"
rescue StandardError => e
  puts "Error: #{e.message}"
end

def delete_user(api_service, id)
  puts 'DELETE USER  '.center(50, '-')
  delete_user = api_service.delete_user_by_id(id.to_i)

  puts "Delete user: #{delete_user}"
rescue StandardError => e
  puts "Error: #{e.message}"
end

def export_to_doc(users)
  puts 'EXPORT TO DOC'.center(50, '-')
  doc = Caracal::Document.new('/home/baoanh/Documents/doc_file/users.doc')

  doc.p text: 'Users List', align: :center, b: true, size: 24

  users_array = users.map(&:to_a).unshift(['ID', 'Name', 'Avatar', 'Sex', 'Active', 'Created At'])
  doc.table users_array, border_size: 4 do
    cell_style rows[0], background: '3366cc', color: 'ffffff', bold: true
  end
  doc.save

  puts 'EXPORT SUCCESSFUL'.center(50, '-')
rescue StandardError => e
  puts "Error: #{e.message}"
end

def export_to_doc_and_zip(users, output_zip)
  puts 'EXPORT TO DOC AND ZIP'.center(50, '-')
  export_to_doc(users)
  source_file = '/home/baoanh/Documents/doc_file/users.doc'

  Zip::File.open(output_zip, Zip::File::CREATE) do |zipfile|
    zipfile.add('users.doc', source_file)
  end

  puts "ZIP FILE CREATED: #{output_zip}".center(50, '-')
rescue StandardError => e
  puts "Error: #{e.message}"
end

def upload_to_drive(drive_service, local_file_path, remote_file_path)
  puts 'UPLOAD TO GOOGLE DRIVE'.center(50, '-')
  drive_service.upload_file(local_file_path, remote_file_path)

  puts 'UPLOAD SUCCESSFUL'.center(50, '-')
rescue StandardError => e
  puts "Error: #{e.message}"
end

def import_users_from_csv(api_service, csv_data)
  CSV.foreach(csv_data, headers: true) do |row|
    user = User.new({ name: row['name'],
                      avatar: row['avatar'],
                      sex: row['sex'],
                      active: row['active'],
                      created_at: row['created_at'] })
    raise 'The Parameter is Incorrect, try again!' unless valid_user?(user)

    user.active = row['active'] == 'true'
    api_service.create_user(user)
  end

  puts 'IMPORT SUCCESSFUL'.center(50, '-')
rescue StandardError => e
  puts "Error: #{e.message}"
end

def valid_user?(user)
  !user.name.empty? && %w[true false].include?(user.active) && %w[male female].include?(user.sex)
end

def menu
  output_zip = '/home/baoanh/Documents/doc_file/users.zip'
  credentials_json_path = '/home/baoanh/Documents/Github/config.json'
  remote_file_path = 'users.zip'
  csv_data = 'users.csv'
  drive_service = DriveService.new(credentials_json_path)
  api_service = ApiService.new
  puts "
  1-Get all active users
  2-Create new user
  3-Edit User
  4-Delete User
  5-Import list users from .csv
  Other-Exit"

  loop do
    puts 'Enter number: '
    number = gets.chomp
    case number
    when '1'
      users = active_users(api_service)
      puts "1-Export to doc\n2-Export to doc and zip it\n3-Upload zip to google drive\nOther-Return"
      choice = gets.chomp
      case choice
      when '1'
        export_to_doc(users)
      when '2'
        export_to_doc_and_zip(users, output_zip)
      when '3'
        upload_to_drive(drive_service, output_zip, remote_file_path)
      else
        next
      end
    when '2'
      create_user(api_service)
    when '3'
      print 'Enter your id: '
      id_edit = gets.chomp
      edit_user(api_service, id_edit)
    when '4'
      print 'Enter delete id: '
      id_del = gets.chomp
      delete_user(api_service, id_del)
    when '5'
      import_users_from_csv(api_service, csv_data)
    else
      break
    end
  end
rescue StandardError => e
  puts "Error: #{e.message}"
end

#menu

api_service = ApiService.new

for id in 60..140 do
  delete_user(api_service,id)
end
