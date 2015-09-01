require_relative 'main_menu'

class SignUpPage < WebPage
  URL = '/users/sign_up'
  validates :title, pattern: /\ADemo web application - Sign Up\z/

  add_field_locator :user_name_input, 'user_name'
  add_field_locator :email_input, 'user_email'
  add_field_locator :password_input, 'user_password'
  add_field_locator :password_confirmation_input, 'user_password_confirmation'
  add_button_locator :sign_up_btn, 'Sign up'

  include MainMenu

  def fill_form(user_name:nil, email:nil, password:nil, password_confirmation:nil)
    fill_in(field_locator(:user_name_input), with: user_name) unless user_name.nil?
    fill_in(field_locator(:email_input), with: email) unless email.nil?
    fill_in(field_locator(:password_input), with: password) unless password.nil?
    fill_in(field_locator(:password_confirmation_input), with: password_confirmation) unless password_confirmation.nil?
    self
  end

  def submit_form
    click_button button_locator(:sign_up_btn)
  end

  def sign_up_as(user_name, email, password)
    log.info "Sign up with: User name=#{user_name}, Email=#{email}, Password=#{password}"
    fill_form(user_name: user_name, email: email, password: password, password_confirmation: password)
    submit_form
    HomePage.given
  end
end