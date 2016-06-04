require_relative 'main_menu'

class ChangePasswordPage < Howitzer::Web::Page
  url '/users/password/new'
  validate :url, /\/users\/password/

  element :password_input, :fillable_field, 'user_password'
  element :confirm_password_input, :fillable_field, 'user_password_confirmation'
  element :submit_form, :button, 'Change my password'

  include MainMenu

  def fill_form(new_password: nil, confirm_new_password: nil)
    log.info "Fill in Change Password form with new password: '#{new_password}'"
    password_input_element.set(new_password) unless new_password.nil?
    confirm_password_input_element.set(confirm_new_password) unless confirm_new_password.nil?
    self
  end

  def submit_form
    log.info "Submit Change Password form"
    submit_form_element.click
  end
end
