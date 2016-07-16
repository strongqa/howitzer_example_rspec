require 'spec_helper'

feature "Log In" do

    background "sign up user" do
      @user1 = build(:user).save!
    end

  scenario "user can open login page via menu" do
    HomePage.
        open.
        main_menu_section.
        choose_menu('Login')
    expect(LoginPage).to be_displayed
  end

  scenario "Visitor can login with correct credentials" do
    log_in_as(@user1)
    expect(HomePage).to be_authenticated
    expect(HomePage).to be_displayed
  end

  scenario "User can not login with blank password", :p1 => true do
    LoginPage.
        open.fill_form(
        email: @user1.email,
        password: nil).submit_form
    expect(HomePage).to be_not_authenticated
    expect(LoginPage.given.text).to include("Invalid email or password.")
  end

  scenario "User can not login with blank email", :p1 => true do
      LoginPage.
          open.fill_form(
          email: nil,
          password: @user1.email).submit_form
      expect(HomePage).to be_not_authenticated
      expect(LoginPage.given.text).to include("Invalid email or password.")
  end

  scenario "User can not login with blank email and passwnord", :p1 => true do
    LoginPage.
        open.fill_form(
        email: nil,
        password: nil ).submit_form
      expect(HomePage).to be_not_authenticated
      expect(LoginPage.given.text).to include("Invalid email or password.")
  end

  scenario "User can not login with incorrect email", :p1 => true do
    LoginPage.
        open.fill_form(
        email: 'test@test.com',
        password: @user1.password ).submit_form
      expect(HomePage).to be_not_authenticated
      expect(LoginPage.given.text).to include("Invalid email or password.")
  end

  scenario "User can not login with incorrect password", :p1 => true do
     LoginPage.
         open.fill_form(
         email: @user1.email,
         password: 'test_password' ).submit_form
     expect(HomePage).to be_not_authenticated
     expect(LoginPage.given.text).to include("Invalid email or password.")
  end

  scenario "User can not login with incorrect email and password", :p1 => true do
    LoginPage.
        open.fill_form(
        email: 'test@test.com',
        password: 'test_password' ).submit_form
    expect(HomePage).to be_not_authenticated
    expect(LoginPage.given.text).to include("Invalid email or password.")
  end

  scenario "User can not login with incorrect email and blank password", :p1 => true do
    LoginPage.
        open.fill_form(
        email: 'test.1234567890',
        password: nil ).submit_form
    expect(HomePage).to be_not_authenticated
    expect(LoginPage).to be_displayed
  end

  scenario "User can not login until confirmation email is not confirmed" do
    user2 = build(:user)
    sign_up_without_confirmation(user2)
    LoginPage.
        open.fill_form(
        email: user2.email,
        password: user2.password).submit_form
    expect(HomePage).to be_not_authenticated
    expect(LoginPage.given.text).to include("You have to confirm your account before continuing.")
  end

  scenario "Canceled user can not login" do
    log_in_as(@user1)
    cancel_account
    LoginPage.
        open.fill_form(
        email:@user1.email,
        password: @user1.password).submit_form
    expect(HomePage).to be_not_authenticated
    expect(LoginPage.given.text).to include("Invalid email or password.")
  end

end
