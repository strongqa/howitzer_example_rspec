module PasswordResettingHelper
  def user_restores_password(email)
    LoginPage.open.
        navigate_to_forgot_password_page
    ForgotPasswordPage.given.
        fill_form(email: email).
        submit_form
    expect(LoginPage.given.flash_message).to eql("You will receive an email with instructions on how to reset your password in a few minutes.")
    ResetPasswordConfirmationEmail.
        find_by_recipient(email).
        confirm_my_account
  end
end

RSpec.configure do |config|
  config.include PasswordResettingHelper
end