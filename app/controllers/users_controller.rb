class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.bio = "" if user_params[:bio] == nil
    if @user.valid?
      @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new, notice: 'User was not created.'
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

  def show
    @user = User.find(params[:id])
    debugger
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :username, :bio, :password, :password_confirmation)
  end
end
