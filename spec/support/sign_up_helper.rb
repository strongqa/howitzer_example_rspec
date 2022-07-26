module SignUpHelper
  def sign_up_as(user)
    SignUpPage.open
    SignUpPage.on do
      fill_form(
        user_name: user.name,
        email: user.email,
        password: user.password,
        password_confirmation: user.password
      )
      submit_form
    end
    ConfirmationInstructionEmail.find_by_recipient(user.email).confirm_my_account
    LoginPage.on { expect(text).to include('Your account was successfully confirmed.') }
  end

  def sign_up_without_confirmation(user)
    SignUpPage.open
    SignUpPage.on do
      fill_form(
        user_name: user.name,
        email: user.email,
        password: user.password,
        password_confirmation: user.password
      )
      submit_form
    end
    HomePage.on do
      expect(text).to include(
        'A message with a confirmation link has been sent to your email address. ' \
        'Please open the link to activate your account.'
      )
    end
  end

  def log_in_as(user)
    LoginPage.open
    LoginPage.on do
      fill_form(
        email: user.email,
        password: user.password
      )
      submit_form
    end
    expect(HomePage).to be_authenticated
    expect(HomePage).to be_displayed
  end
end

RSpec.configure do |config|
  config.include SignUpHelper
end
