require_relative 'main_menu'

class SignUpPage < Howitzer::Web::Page
  url '/users/sign_up'
  validate :title, /\ADemo web application - Sign Up\z/

  element :user_name_input, :fillable_field, 'user_name'
  element :email_input, :fillable_field, 'user_email'
  element :password_input, :fillable_field, 'user_password'
  element :password_confirmation_input, :fillable_field, 'user_password_confirmation'
  element :sign_up_btn, :button, 'Sign up'

  include MainMenu

  def fill_form(user_name:nil, email:nil, password:nil, password_confirmation:nil)
    user_name_input_element.set(user_name) unless user_name.nil?
    email_input_element.set(email) unless email.nil?
    password_input_element.set(password) unless password.nil?
    password_confirmation_input_element.set(password_confirmation) unless password_confirmation.nil?
    self
  end

  def submit_form
    sign_up_btn_element.click
  end

  def sign_up_as(user_name, email, password)
    log.info "Sign up with: User name=#{user_name}, Email=#{email}, Password=#{password}"
    fill_form(user_name: user_name, email: email, password: password, password_confirmation: password)
    submit_form
    HomePage.given
  end
end
