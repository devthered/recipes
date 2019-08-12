module RecipesHelper
  def liked_by_current_user?(recipe)
    @current_user.liked_recipes.include?(recipe)
  end
end
