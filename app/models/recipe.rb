class Recipe
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :source, type: String
  field :ingredients, type: Array
  field :instructions, type: String
end
