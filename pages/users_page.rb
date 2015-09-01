require_relative 'main_menu'

class UsersPage < WebPage
  URL = '/users'
  validates :title, pattern: /\ADemo web application - Users\z/

  add_locator       :registered_user_date,        lambda{|email| {xpath: ".//li[contains(.,'#{email}')]"}}

  include MainMenu

  def open_user(user_email)
    log.info "Open user '#{user_email}' page"
    click_link_or_button user_email
  end

  def user_registration_date(email)
    find(apply(locator(:registered_user_date),email)).text
  end

end