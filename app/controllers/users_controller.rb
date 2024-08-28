class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @page = params[:page].nil? ? 0 : Integer(params[:page])
    @per_page = 30
    @set_page_to = "#{users_path}?page="
    @list_to_paginate = User.all
    @users_to_show = @list_to_paginate.each_slice(@per_page).to_a[@page]
  end

  def show
    # Prep micropost for user in-case they wanna post
    @micropost = current_user.microposts.build if logged_in?
    #prep the stuff needed for arrows
    @page = params[:page].nil? ? 0 : Integer(params[:page])
    @per_page = 15
    @user = User.find(params[:id])
    @set_page_to = "#{user_path(@user)}?page="
    @list_to_paginate = @user.microposts.all
    @microposts_to_show = @list_to_paginate.all.each_slice(@per_page).to_a[@page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.bio = "" if user_params[:bio] == nil
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
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
      log_out unless current_user.admin
      user.destroy
    end
    redirect_to users_path
  end

  def delete
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :username, :bio, :password, :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path unless (current_user.admin || current_user?(@user))
  end
end
