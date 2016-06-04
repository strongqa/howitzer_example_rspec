require_relative 'main_menu'

class UsersPage < Howitzer::Web::Page
  url '/users'
  validate :title, /\ADemo web application - Users\z/

  element :registered_user_date, :xpath, ->(email){ ".//li[contains(.,'#{email}')]" }
  element :user_email, :link_or_button, ->(email) { email }

  include MainMenu

  def open_user(user_email)
    log.info "Open user '#{user_email}' page"
    user_email_element(user_email).click
  end

  def user_registration_date(email)
    registered_user_date_element(email).text
  end

end
