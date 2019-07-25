class Recipe
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  field :title, type: String
  field :genre, type: String
  field :ingredients, type: Array, default: []
  field :instructions, type: String
  field :source, type: String

  default_scope { order(genre: :asc, title: :asc) }

  validates_presence_of :title, :genre, :ingredients, :instructions

  def ingredients=(ingredients)
    if ingredients.is_a? String
      self[:ingredients] = ingredients.split("\r\n").map { |ingredient| ingredient }
    else
      self[:ingredients] = ingredients.map { |ingredient| ingredient }
    end
  end

  def instructions=(instructions)
    self[:instructions] = instructions
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

  def self.search(params)
    search_term_regex = /.*#{params[:search]}.*/i
    Recipe.filter_by_user(params[:user]).filter_by_genre(params[:genre]).or(
      {title: search_term_regex},
      {source: search_term_regex},
      {ingredients: search_term_regex},
      {instructions: search_term_regex}
    )
  end

  def self.filter_by_genre(genre)
    if genre != ""
      Recipe.where(genre: genre)
    else
      Recipe.all
    end
  end

  def self.filter_by_user(user)
    if user
      Recipe.where(user_id: user)
    else
      Recipe.all
    end
  end

  # private methods live down here
  private
end
