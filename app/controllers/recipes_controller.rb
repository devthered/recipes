class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy, :toggle_saved]
  before_action :logged_in_user, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :owner, only: [:edit, :update, :destroy]

  # GET /recipes
  # GET /recipes.json
  def index
    @recipes = Recipe.search(params)
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
    
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
  end

  # GET /recipes/1/edit
  def edit
  end

  # POST /recipes
  # POST /recipes.json
  def create
    @recipe = current_user.recipes.build(recipe_params)

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to recipes_url, notice: 'Recipe was successfully created.' }
        format.json { render :show, status: :created, location: @recipe }
      else
        format.html { render :new }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipes/1
  # PATCH/PUT /recipes/1.json
  def update
    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to @recipe, notice: 'Recipe was successfully updated.' }
        format.json { render :show, status: :ok, location: @recipe }
      else
        format.html { render :edit }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.json
  def destroy
    @recipe.destroy
    respond_to do |format|
      format.html { redirect_to recipes_url, notice: 'Recipe was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def toggle_saved
    if current_user.saved_recipe?(@recipe)
      current_user.unsave_recipe(@recipe)
    else
      current_user.save_recipe(@recipe)
    end
  end

  private
    def owner
      unless current_user == @recipe.owner
        flash[:danger] = "You do not have the ability to modify that recipe."
        redirect_to root_url
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recipe_params
      params.require(:recipe).permit(:owner_id, :title, :source, :ingredients, :instructions, :genre, :serving_type, :servings, :time_hours, :time_minutes)
    end
end
