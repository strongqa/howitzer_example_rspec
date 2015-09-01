require_relative 'main_menu'

class EditAccountPage < WebPage
  URL = '/users/edit'
  validates :title, pattern: /Demo web application - Edit User\z/

  add_button_locator :cancel_account_button, 'Cancel my account'
  add_button_locator :update_account_btn, 'Update'
  add_field_locator :name, 'user_name'
  add_field_locator :email, 'user_email'
  add_field_locator :password, 'user_password'
  add_field_locator :password_confirmation, 'user_password_confirmation'
  add_field_locator :current_password, 'user_current_password'


  include MainMenu

  def cancel_my_account
    log.info "Cancelling user account"
    accept_js_confirmation do
      click_button(button_locator :cancel_account_button)
    end
  end

  def fill_form(user_name: nil, email: nil, password: nil, password_confirmation: nil, current_password: nil)
    log.info "Fill in Edit Account form with data: user_name: #{user_name}, email: #{email}, password_confirmation: #{password_confirmation}, current_password: #{current_password}"
    fill_in(field_locator(:name), with: user_name) unless user_name.nil?
    fill_in(field_locator(:email), with: email) unless email.nil?
    fill_in(field_locator(:password), with: password) unless password.nil?
    fill_in(field_locator(:password_confirmation), with: password_confirmation) unless password_confirmation.nil?
    fill_in(field_locator(:current_password), with: current_password) unless current_password.nil?
    self
  end

  def submit_form
    log.info "Update user account"
    click_button(button_locator :update_account_btn)
  end

  def form_data
    {:user_name => find_field(field_locator(:name)).value,
     :email => find_field(field_locator(:email)).value,
     :password => find_field(field_locator(:password)).value,
     :password_confirmation => find_field(field_locator(:password_confirmation)).value,
     :current_password => find_field(field_locator(:current_password)).value}
  end

end
