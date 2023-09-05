# frozen_string_literal: true

require 'faraday'
require 'json'
require_relative 'user'

# Create API service
class ApiService
  def initialize
    @api_url = 'https://6418014ee038c43f38c45529.mockapi.io/api/v1/'
    @conn = Faraday.new(url: @api_url)
  end

  def users_active
    condition_get = { active: true }
    response = @conn.get('users', condition_get)
    raise "Request failed with status code #{post.status}" unless response.success?

    list_users = JSON.parse(response.body)

    list_users.map { |user| User.new(user.transform_keys(&:to_sym)) }
  end

  def create_user(user)
    new_user_data = {
      name: user.name,
      sex: user.sex,
      active: user.active,
      created_at: Time.now.to_s,
      avatar: user.avatar
    }
    response = @conn.post('users', new_user_data.to_json, 'Content-Type' => 'application/json')

    raise "Request failed with status code #{response.status}" unless response.success?

    puts 'User created successfully.'

    user_data = JSON.parse(response.body)
    User.new(user_data.transform_keys(&:to_sym))
  end

  def edit_user_by_id(user, id)
    edit_user_data = {
      name: user.name,
      sex: user.sex,
      active: user.active,
      created_at: Time.now.to_s,
      avatar: user.avatar
    }

    response = @conn.put("users/#{id}", edit_user_data.to_json, 'Content-Type' => 'application/json')
    p edit_user_data.to_s
    raise "Request failed with status code #{response.status}" unless response.success?

    puts 'User edit successfully.'

    user_data = JSON.parse(response.body)
    User.new(user_data.transform_keys(&:to_sym))
  end

  def delete_user_by_id(id)
    response = @conn.delete("users/#{id}")
    raise "Request failed with status code #{response.status}" unless response.success?

    puts 'User edit successfully.'

    user_data = JSON.parse(response.body)
    User.new(user_data.transform_keys(&:to_sym))
  end
end
