module PasswordResettingHelper
  # rubocop:disable Metrics/MethodLength
  def user_restores_password(email)
    LoginPage.open
    LoginPage.on { navigate_to_forgot_password_page }
    ForgotPasswordPage.on do
      fill_form(email: email)
      submit_form
    end
    LoginPage.on do
      expect(flash_section.flash_message).to eql(
        'You will receive an email with instructions on how to reset your password in a few minutes.'
      )
    end
    ResetPasswordConfirmationEmail
      .find_by_recipient(email)
      .reset_password
  end
  # rubocop:enable Metrics/MethodLength
end

RSpec.configure do |config|
  config.include PasswordResettingHelper
end
