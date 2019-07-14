class Recipe
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :source, type: String
  field :genre, type: String
  field :ingredients, type: Array, default: []
  field :instructions, type: String

  default_scope { order(genre: :asc, title: :asc) }

  validates_presence_of :title, :source, :genre, :ingredients, :instructions

  def ingredients=(ingredients)
    if ingredients.respond_to?('split')
      self[:ingredients] = ingredients.split("\r\n").map { |ingredient| sanitize(ingredient) }
    else
      self[:ingredients] = ingredients.map { |ingredient| sanitize(ingredient) }
    end
  end

  def instructions=(instructions)
    self[:instructions] = sanitize(instructions)
  end

  def print_ingredients
    text = ''
    self.ingredients.each do |ingredient, i|
      text += ingredient
      text += "\n" 
    end
    return text.chomp
  end

  # class methods
  def self.genres
    return [
      'baked',
      'meat',
      'sauce',
      'seafood',
      'veggie'
    ]
  end

  # private methods live down here
  private
  
  def sanitize(input)
    conversions = {
      '1/2' => '½',
      '1/4' => '¼',
      '1/8' => '⅛',
    }

    conversions.each { |k, v| input = input.sub(k, v) }
    return input;
  end
end
