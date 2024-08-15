class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  def index
    @users = User.paginate(page: params[:page])
  end
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.bio = "" if user_params[:bio] == nil
    if @user.save
      flash[:success] = "Welcome to Messenger!"
      log_in @user
      redirect_to @user
    else
      flash[:danger] = "There was a problem creating your account. Please try again."
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:success] = "Updated account."
      redirect_to @user
    else
      flash[:danger] = "There was a problem updating your account. Please try again."
      render :edit
    end
  end

  def destroy
    store_location
    user = User.find(params[:id])
    if user.present?
      user.destroy
    end
    redirect_back_or root_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :username, :bio, :password, :password_confirmation)
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_path
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path unless (current_user.admin || current_user?(@user))
  end
end
