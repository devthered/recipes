module RecipesHelper
  def saved_by_current_user?(recipe)
    @current_user.saved_recipe?(recipe)
  end
end
