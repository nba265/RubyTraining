# frozen_string_literal: true

require 'json'

# Create Model User
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
    "- Id: #{@id}
     - Name: #{@name}
     - Avatar: #{@avatar}
     - Sex: #{@sex}
     - Active: #{@active}
     - Create at: #{@created_at}"
  end

  def to_json(*_args)
    { id: @id, name: @name, avatar: @avatar, sex: @sex, active: @active, created_at: @created_at }.to_json
  end

  def to_a
    [@id, @name, @avatar, @sex, @active, @created_at]
  end
end
