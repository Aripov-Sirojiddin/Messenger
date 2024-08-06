class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.bio = "" if user_params[:bio] == nil
    if @user.valid?
      @user.save
      flash[:success] = "Welcome to Messenger!"
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
    if @user.valid?
      @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit, notice: 'User was not updated.'
    end
  end

  def destroy
    user = User.find(params[:id])
    if user.present?
      user.destroy
    end
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :username, :bio, :password, :password_confirmation)
  end
end
