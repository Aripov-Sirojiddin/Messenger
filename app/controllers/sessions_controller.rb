class SessionsController < ApplicationController
  def new

  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)

    if @user&.authenticate(params[:session][:password])
      unless @user.activated
        flash[:warning] = "Please activate your account. Check your email for activation link."
        render :new
        return
      end
      flash[:success] = "Welcome back #{@user.name.split(" ")[0]}!"
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      flash[:danger] = 'Invalid email/password combination'
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
