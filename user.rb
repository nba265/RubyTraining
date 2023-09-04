# frozen_string_literal: true

require 'faraday'
require 'json'

class User
  attr_accessor :id, :name, :avatar, :sex, :active, :created_at

  def initialize(attributes)
    @id = attributes[:id]
    @name = attributes[:name]
    @avatar = attributes[:avatar]
    @sex = attributes[:sex]
    @active = attributes[:active]
    @created_at = attributes[:created_at]
  end

  def to_s
    "- Id: #{@id}\n
     - Name: #{@name}\n
     - Avatar: #{@avatar}\n
     - Sex: #{@sex}\n
     - Active: #{@active}\n
     - Create at: #{@created_at}\n"
  end

  def to_json(*_args)
    { id: @id, name: @name, avatar: @avatar, sex: @sex, active: @active, created_at: @created_at }.to_json
  end
end
