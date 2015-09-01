require 'spec_helper'

feature "Log In" do
    background "sign up user" do
      @user = Gen.user
      sign_up_as(@user)
    end
  scenario "user can open login page via menu" do
    HomePage.
        open.
        choose_menu('Login')
    LoginPage.wait_for_opened
  end
  scenario "Visitor can login with correct credentials" do
    log_in_as(@user)
    expect(HomePage).to be_authenticated
    HomePage.wait_for_opened
  end
  scenario "User can not login with blank password" do
    LoginPage.
        open.fill_form(
        email: @user.email,
        password: nil).submit_form
    expect(HomePage).to_not be_authenticated
    expect(LoginPage.given.text).to include("Invalid email or password.")
  end
  scenario "User can not login with blank email" do
      LoginPage.
          open.fill_form(
          email: nil,
          password: @user.email).submit_form
      expect(HomePage).to_not be_authenticated
      expect(LoginPage.given.text).to include("Invalid email or password.")
  end
  scenario "User can not login with blank email and passwnord" do
    LoginPage.
        open.fill_form(
        email: nil,
        password: nil ).submit_form
      expect(HomePage).to_not be_authenticated
      expect(LoginPage.given.text).to include("Invalid email or password.")
  end
  scenario "User can not login with incorrect email" do
    LoginPage.
        open.fill_form(
        email: 'test@test.com',
        password: @user.password ).submit_form
      expect(HomePage).to_not be_authenticated
      expect(LoginPage.given.text).to include("Invalid email or password.")
  end
  scenario "User can not login with incorrect password" do
     LoginPage.
         open.fill_form(
         email: @user.email,
         password: 'test_password' ).submit_form
     expect(HomePage).to_not be_authenticated
     expect(LoginPage.given.text).to include("Invalid email or password.")
  end
  scenario "User can not login with incorrect email and password" do
    LoginPage.
        open.fill_form(
        email: 'test@test.com',
        password: 'test_password' ).submit_form
    expect(HomePage).to_not be_authenticated
    expect(LoginPage.given.text).to include("Invalid email or password.")
  end
  scenario "User can not login with incorrect email and blank password" do
    LoginPage.
        open.fill_form(
        email: 'test.1234567890',
        password: nil ).submit_form
    expect(HomePage).to_not be_authenticated
    expect(LoginPage.given.text).to include("Invalid email or password.")
  end
  scenario "User can not login until confirmation email is not confirmed" do
    user = Gen.user
    sign_up_without_confirmation(user)
    LoginPage.
        open.fill_form(
        email: user.email,
        password: user.password).submit_form
    expect(HomePage).to_not be_authenticated
    expect(LoginPage.given.text).to include("You have to confirm your account before continuing.")
  end
  scenario "Canceled user can not login" do
    log_in_as(@user)
    cancel_account
    LoginPage.
        open.fill_form(
        email: @user.email,
        password: @user.password).submit_form
    expect(HomePage).to_not be_authenticated
    expect(LoginPage.given.text).to include("Invalid email or password.")
  end
end