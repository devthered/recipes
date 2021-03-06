class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :index_saved_recipes, :show, :edit, :update, :index, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :admin_user, only: [:destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /saved_recipes
  # GET /saved_recipes.json
  def index_saved_recipes
    @recipe_saver = current_user
    @recipes = current_user.saved_recipes.search(params)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @recipes = @user.recipes.search(params)
  end

  # GET /users/new
  def new
    redirect_to root_path if logged_in?
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html do
          UserMailer.account_activation(@user).deliver_now
          flash[:info] = "Please check your email to activate your account."
          redirect_to login_url
        end
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :admin)
    end

    # Confirms the correct user is logged in.
    def correct_user
      set_user
      redirect_to(root_url) unless current_user? @user or current_user.admin?
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
