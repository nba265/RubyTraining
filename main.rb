# frozen_string_literal: true

require 'rubygems'
require 'zip'
require 'htmltoword'
require_relative 'api_service'

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
  raise 'The Parameter is Incorrect, try again!' unless !name.empty? &&
                                                        %w[male female].include?(sex) &&
                                                        %w[true false].include?(active)

  new_user = User.new({ name: name, sex: sex, active: active == 'true', avatar: avatar })
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
  raise 'The Parameter is Incorrect, try again!' unless !name.empty? &&
                                                        %w[male female].include?(sex) &&
                                                        %w[true false].include?(active)

  user = User.new({ name: name, sex: sex, active: active == 'true', avatar: avatar })
  p user.to_s
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
  html = <<-HTML
  <html>
    <head>
    </head>
    <body>
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Avatar</th>
            <th>Sex</th>
            <th>Active</th>
            <th>Created At</th>
          </tr>
        </thead>
        <tbody>
          #{users.map do |user|
            "<tr>
              <td>#{user.id}</td>
              <td>#{user.name}</td>
              <td>#{user.avatar}</td>
              <td>#{user.sex}</td>
              <td>#{user.active}</td>
              <td>#{user.created_at}</td>
            </tr>"
          end.join("\n")}
        </tbody>
      </table>
    </body>
  </html>
  HTML
  html += '</table></body></html>'
  output_path = '/home/baoanh/Documents/doc_file/users.doc'
  Htmltoword::Document.create(html)
  Htmltoword::Document.create_and_save(html, output_path)

  puts 'EXPORT SUCCESSFUL'.center(50, '-')
rescue StandardError => e
  puts "Error: #{e.message}"
end

def export_to_doc_and_zip(users)
  puts 'EXPORT TO DOC AND ZIP'.center(50, '-')
  export_to_doc(users)
  source_file = '/home/baoanh/Documents/doc_file/users.doc'
  output_zip = '/home/baoanh/Documents/doc_file/users.zip'

  Zip::File.open(output_zip, Zip::File::CREATE) do |zipfile|
    zipfile.add('users.doc', source_file)
  end

  puts "Zip file created: #{output_zip}".center(50, '-')
rescue StandardError => e
  puts "Error: #{e.message}"
end

def menu
  api_service = ApiService.new
  puts "1-Get all active users\n2-Create new user\n3-Edit User\n4-Delete User\nOther-Exit"

  loop do
    puts 'Enter number: '
    number = gets.chomp
    case number
    when '1'
      users = active_users(api_service)
      puts "1-Export to doc\n2-Export to doc and zip it\nOther-Return"
      choice = gets.chomp
      case choice
      when '1'
        export_to_doc(users)
      when '2'
        export_to_doc_and_zip(users)
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
    else
      break
    end
  end
rescue StandardError => e
  puts "Error: #{e.message}"
end

menu
