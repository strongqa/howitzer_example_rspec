require_relative 'main_menu'

class EditAccountPage < Howitzer::Web::Page
  url '/users/edit'
  validate :title, /Demo web application - Edit User\z/

  element :cancel_account_button, :button, 'Cancel my account'
  element :update_account_btn, :button, 'Update'
  element :name, :fillable_field, 'user_name'
  element :email, :fillable_field, 'user_email'
  element :password, :fillable_field, 'user_password'
  element :password_confirmation, :fillable_field, 'user_password_confirmation'
  element :current_password, :fillable_field, 'user_current_password'

  include MainMenu

  def cancel_my_account
    log.info "Cancelling user account"
    accept_js_confirmation do
      cancel_account_button_element.click
    end
  end

  def fill_form(user_name: nil, email: nil, password: nil, password_confirmation: nil, current_password: nil)
    log.info "Fill in Edit Account form with data: user_name: #{user_name}, email: #{email}, password_confirmation: #{password_confirmation}, current_password: #{current_password}"
    name_element.set(user_name) unless user_name.nil?
    email_element.set(email) unless email.nil?
    password_element.set(password) unless password.nil?
    password_confirmation_element.set(password_confirmation) unless password_confirmation.nil?
    current_password.set(current_password) unless current_password.nil?
    self
  end

  def submit_form
    log.info "Update user account"
    update_account_btn_element.click
  end

  def form_data
    {:user_name => name_element.value,
     :email => email_element.value,
     :password => password_element.value,
     :password_confirmation => password_confirmation_element.value,
     :current_password => current_password_element.value}
  end

end
