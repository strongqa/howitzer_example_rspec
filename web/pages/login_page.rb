require_relative 'main_menu'

class LoginPage < Howitzer::Web::Page
  url '/users/sign_in'
  validate :title, /\ADemo web application - Log In\z/
  validate :url, /\/sign_in\/?\z/

  element :email_input, :fillable_field, 'user_email'
  element :password_input, :fillable_field, 'user_password'
  element :remember_me, :checkbox, 'user_remember_me'

  element :sign_up_link, :link, 'new_user_sign_up'
  element :forgot_password_link, :link, 'Forgot password?'

  include MainMenu

  def fill_form(email: nil, password: nil, remember_me: nil)
    log.info "Fill in Login Form with data: email: #{email}, password: #{password}, remember_me: #{remember_me}"
    email_input_element.set(email) unless email.nil?
    password_input_element.set(password) unless password.nil?
    remember_me_element.set(true) unless remember_me.nil?
    self
  end

  def submit_form
    log.info "Submit Login Form"
    page.execute_script("$('[name=\"commit\"]').trigger('click')")
    sleep settings.timeout_tiny
  end

  def login_as(email, password, remember_me=false)
    log.info "Login with: Email=#{email}, Password=#{password}, Remember Me=#{remember_me}"
    fill_form(email: email, password: password, remember_me: remember_me)
    submit_form
    HomePage.given
  end

  def navigate_to_forgot_password_page
    log.info "Navigate to forgot password page"
    forgot_password_link_element.click
  end
end
