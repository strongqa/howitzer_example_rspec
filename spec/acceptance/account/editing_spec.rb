require 'spec_helper'

feature "Account Editing" do

  background "sign up user" do
    @user1 = build(:user).save!
  end

  scenario "User can edit password and name with correct credentials" do
    user2 = build(:user)
    log_in_as(@user1)
    EditAccountPage.open.fill_form(user_name: user2.name,
                  password: user2.password,
                  password_confirmation: user2.password,
                  current_password: @user1.password).submit_form
    expect(HomePage.given.flash_section.flash_message).to eql('You updated your account successfully.')
    HomePage.given.main_menu_section.choose_menu('Logout')
    expect(HomePage).to be_not_authenticated
    LoginPage.open.fill_form(email: @user1.email,
                  password: user2.password).submit_form
    expect(HomePage).to be_authenticated
    expect(EditAccountPage.open.form_data).to eq({user_name: user2.name,
                                                   email: @user1.email,
                                                   password: '',
                                                  password_confirmation: '',
                                                  current_password: ''})
  end

  scenario "User can edit email with correct credentials", :p1 => true do
    user2 = build(:user)
    log_in_as(@user1)
    EditAccountPage.open.fill_form(user_name: @user1.name,
                  email: user2.email,
                  password: '',
                  password_confirmation: '',
                  current_password: @user1.password).submit_form
    expect(HomePage.given.flash_section.flash_message).to eql('You updated your account successfully, but we need to verify your new email address. Please check your email and click on the confirm link to finalize confirming your new email address.')
    ConfirmationInstructionEmail.
        find_by_recipient(user2.email).
        confirm_my_account
    expect(HomePage.given.flash_section.flash_message).to eql('Your account was successfully confirmed.')
    HomePage.given.main_menu_section.choose_menu('Logout')
    expect(HomePage).to be_not_authenticated
    LoginPage.open.fill_form(email: user2.email,
                              password: @user1.password).submit_form
    expect(HomePage).to be_authenticated
    expect(HomePage.given.flash_section.flash_message).to eql('Signed in successfully.')
  end

  scenario "User can not edit account with incorrect email", :p1 => true do
    log_in_as(@user1)
    EditAccountPage.open.fill_form(email: 'test@.ua',
                  current_password: @user1.password).submit_form
    expect(EditAccountPage).to be_displayed
  end

  scenario "User can not edit account with existing email", :p1 => true do
    user2 = create(:user)
    log_in_as(user2)
    EditAccountPage.open.fill_form(email: @user1.email,
                  current_password: user2.password).submit_form
    expect(EditAccountPage.given.errors_section.error_message).to eql("1 error prohibited this user from being saved: Email has already been taken")
  end

  scenario "User can not edit account with incorrect password", :p1 => true do
    user2 = build(:user)
    log_in_as(@user1)
    EditAccountPage.open.fill_form(password: user2.password,
                  password_confirmation: user2.password,
                  current_password: 'incorrect_password').submit_form
    expect(EditAccountPage.given.errors_section.error_message).to eql("1 error prohibited this user from being saved: Current password is invalid")
  end

  scenario "User can not edit account with incorrect password confirmation", :p1 => true do
    log_in_as(@user1)
    EditAccountPage.open.fill_form(password: '12345678',
                  password_confirmation: '123456789',
                  current_password: @user1.password).submit_form
    expect(EditAccountPage.given.errors_section.error_message).to eql("1 error prohibited this user from being saved: Password confirmation doesn't match Password")
  end

  scenario "User can not edit account with short password (less then 8 characters)", :p1 => true do
    log_in_as(@user1)
    EditAccountPage.open.fill_form(password: '1234567',
                  password_confirmation: '1234567',
                  current_password: @user1.password).submit_form
    expect(EditAccountPage.given.errors_section.error_message).to eql("1 error prohibited this user from being saved: Password is too short (minimum is 8 characters)")
  end
end
