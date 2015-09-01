module SignUpHelper
  def sign_up_as(user)
    SignUpPage.
        open.fill_form(
        user_name: user.full_name,
        email: user.email,
        password: user.password,
        password_confirmation: user.password).
        submit_form
    ConfirmationInstructionEmail.
        find_by_recipient(user.email).
        confirm_my_account
    expect(LoginPage.given.text).to include('Your account was successfully confirmed.')
  end

  def sign_up_without_confirmation(user)
    SignUpPage.
        open.fill_form(
        user_name: user.full_name,
        email: user.email,
        password: user.password,
        password_confirmation: user.password).
        submit_form
    expect(HomePage.given.text).to include('A message with a confirmation link has been sent to your email address. Please open the link to activate your account.')
  end

  def log_in_as(user)
    LoginPage.
        open.
        fill_form(email: user.email, password: user.password).
        submit_form
    expect(HomePage).to be_authenticated
    HomePage.wait_for_opened
  end

  def log_in_as_admin
    LoginPage.
        open.
        fill_form(email: settings.def_test_user, password: settings.def_test_pass).
        submit_form
    expect(HomePage).to be_authenticated
    HomePage.wait_for_opened
  end
end

RSpec.configure do |config|
  config.include SignUpHelper
end
