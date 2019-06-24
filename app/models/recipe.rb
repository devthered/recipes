class Recipe
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :source, type: String
  field :ingredients, type: Array
  field :instructions, type: String
  field :genre, type: String

  def ingredients=(ingredients)
    if ingredients.respond_to?('split')
      self[:ingredients] = ingredients.sub("\r", '').split("\n")
    else
      self[:ingredients] = ingredients
    end
  end

  def instructions=(instructions)
    self[:instructions] = instructions.sub("\n", '<br><br>')
  end
end
