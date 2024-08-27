ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    def get_users_path
      users_path
    end

    # Add more helper methods to be used by all tests here...
    def is_logged_in?
      !session[:user_id].nil?
    end

    def log_in_as(user)
      session[:user_id] = user.id
    end
  end
end

module ActionDispatch
  class IntegrationTest
    def log_in_as(user, password: 'password', remember_me: '1')
      post login_path, params: {
        session: {
          email: user.email,
          password: password,
          remember_me: remember_me
        }
      }
    end
  end
end
