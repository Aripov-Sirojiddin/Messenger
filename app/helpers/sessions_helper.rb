module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if (user_id = session[:user_id])
      user = User.find_by(id: user_id)
      @current_user ||= user
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def forget(user)
    cookies.delete(:remember_token)
    cookies.delete(:user_id)
    user.forget
  end

  def log_out
    if logged_in?
      forget(current_user)
      session.delete(:user_id)
      @current_user = nil
    end
  end

  def remember user
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user?(user)
    user && user == current_user
  end

  def redirect_back_or(default)
    redirect_to (session[:forwarding_url] || default)
    session.delete(:forwarding_url) unless session[:forwarding_url].nil?
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
