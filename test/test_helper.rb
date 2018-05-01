require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper

  def is_logged_in?
    !session[:account_id].nil?
  end

  def log_in_as(account)
    session[:account_id] = account.id
  end
end


class ActionDispatch::IntegrationTest

  def log_in_as(account, password: 'foobar01', remember_me: '1')
    post login_path, params: {session: {email: account.email,
                                        password: password,
                                        remember_me: remember_me}}
  end
end
