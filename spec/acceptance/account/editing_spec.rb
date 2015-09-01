require 'spec_helper'

feature "Account Editing" do
  background "sign up user" do
    @user = Gen.user
    sign_up_as(@user)
  end

  scenario "User can edit password and name with correct credentials" do
    user1 = Gen.user
    log_in_as(@user)
    EditAccountPage.open.fill_form(user_name: user1.full_name,
                  password: user1.password,
                  password_confirmation: user1.password,
                  current_password: @user.password).submit_form
    expect(HomePage.given.flash_message).to eql('You updated your account successfully.')
    HomePage.given.choose_menu('Logout')
    expect(HomePage).to_not be_authenticated
    LoginPage.open.fill_form(email: @user.email,
                  password: user1.password).submit_form
    expect(HomePage).to be_authenticated
    expect(EditAccountPage.open.form_data).to eq({user_name: user1.full_name,
                                                   email: @user.email,
                                                   password: '',
                                                  password_confirmation: '',
                                                  current_password: ''})
  end

  scenario "User can edit email with correct credentials" do
    user1 = Gen.user
    log_in_as(@user)
    EditAccountPage.open.fill_form(user_name: @user.full_name,
                  email: user1.email,
                  password: '',
                  password_confirmation: '',
                  current_password: @user.password).submit_form
    expect(HomePage.given.flash_message).to eql('You updated your account successfully, but we need to verify your new email address. Please check your email and click on the confirm link to finalize confirming your new email address.')
    ConfirmationInstructionEmail.
        find_by_recipient(user1.email).
        confirm_my_account
    expect(HomePage.given.flash_message).to eql('Your account was successfully confirmed.')
    HomePage.given.choose_menu('Logout')
    expect(HomePage).to_not be_authenticated
    LoginPage.open.fill_form(email: user1.email,
                              password: @user.password).submit_form
    expect(HomePage).to be_authenticated
    expect(HomePage.given.flash_message).to eql('Signed in successfully.')
  end

  scenario "User can not edit account with incorrect email" do
    log_in_as(@user)
    EditAccountPage.open.fill_form(email: 'test@.ua',
                  current_password: @user.password).submit_form
    EditAccountPage.wait_for_opened
  end

  scenario "User can not edit account with existing email" do
    user1 = Gen.user
    SignUpPage.open.sign_up_as(user1.full_name, user1.email, user1.password)

    ConfirmationInstructionEmail.
        find_by_recipient(user1.email).
        confirm_my_account

    expect(LoginPage.given.flash_message).to eql('Your account was successfully confirmed.')
    log_in_as(user1)
    EditAccountPage.open.fill_form(email: @user.email,
                  current_password: user1.password).submit_form
    expect(EditAccountPage.given.error_message).to eql("1 error prohibited this user from being saved: Email has already been taken")
  end

  scenario "User can not edit account with incorrect password" do
    user1 = Gen.user
    log_in_as(@user)
    EditAccountPage.open.fill_form(password: user1.password,
                  password_confirmation: user1.password,
                  current_password: 'incorrect_password').submit_form
    expect(EditAccountPage.given.error_message).to eql("1 error prohibited this user from being saved: Current password is invalid")
  end

  scenario "User can not edit account with incorrect password confirmation" do
    log_in_as(@user)
    EditAccountPage.open.fill_form(password: '12345678',
                  password_confirmation: '123456789',
                  current_password: @user.password).submit_form
    expect(EditAccountPage.given.error_message).to eql("1 error prohibited this user from being saved: Password confirmation doesn't match Password")
  end

  scenario "User can not edit account with short password (less then 8 characters)" do
    log_in_as(@user)
    EditAccountPage.open.fill_form(password: '1234567',
                  password_confirmation: '1234567',
                  current_password: @user.password).submit_form
    expect(EditAccountPage.given.error_message).to eql("1 error prohibited this user from being saved: Password is too short (minimum is 8 characters)")
  end
end