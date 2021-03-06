class Recipe
  include Mongoid::Document
  include Mongoid::Timestamps

  @genres = [
    'breakfast',
    'bread',
    'grains',
    'noodles',
    'raw veg',
    'cooked veg',
    'meat',
    'seafood',
    'sauces',
    'sweets'
  ]

  @serving_types = [
    'Serves',
    'Makes'
  ]

  belongs_to :owner, class_name: 'User', inverse_of: :recipes
  has_and_belongs_to_many :saved_by_users, class_name: 'User', inverse_of: :saved_recipes
  
  field :title, type: String
  field :genre, type: String, default: 'breakfast'
  field :ingredients, type: Array, default: []
  field :instructions, type: String
  field :source, type: String
  field :serving_type, type: String, default: 'Serves'
  field :servings, type: Integer, default: 0
  field :time_hours, type: Integer, default: 0
  field :time_minutes, type: Integer, default: 0

  default_scope { order(title: :asc) }

  validates_presence_of :title, :genre, :ingredients, :instructions
  validates :genre, inclusion: { in: @genres }
  validates :serving_type, inclusion: { in: @serving_types }

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

  def genre_class
    return 'genre-' + self[:genre].sub(' ', '-')
  end

  # class methods
  def self.sorted
    Recipe.all.sort_by { |recipe| Recipe.genres.find_index(recipe.genre) }
  end

  def self.genres
    return @genres
  end

  def self.serving_types
    return @serving_types
  end

  def self.search(params)
    search_term_regex = /.*#{params[:search]}.*/i
    Recipe.filter_by_saver(params[:saver])
          .filter_by_user(params[:user])
          .filter_by_genre(params[:genre]).or(
            {title: search_term_regex},
            {source: search_term_regex},
            {ingredients: search_term_regex},
            {instructions: search_term_regex})
          .sorted
  end

  def self.filter_by_genre(genre)
    if genre != ""
      self.where(genre: genre)
    else
      self.all
    end
  end

  def self.filter_by_saver(saver)
    if saver
      self.where(saved_by_user_ids: saver)
    else
      self.all
    end
  end

  def self.filter_by_user(user)
    if user
      self.where(owner_id: user)
    else
      self.all
    end
  end

  # private methods live down here
  private
end
