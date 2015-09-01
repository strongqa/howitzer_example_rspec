require 'spec_helper'

feature "Sign Up" do
  scenario "Visitor can open sign up page via menu from home page" do
    HomePage.
        open.
        choose_menu('Sign up')
    SignUpPage.wait_for_opened
  end

  scenario "Visitor can open sign up page via menu from login page" do
    LoginPage.
        open.
        choose_menu('Sign up')
    SignUpPage.wait_for_opened
  end

  scenario "User can sign up with correct data" do
    user = Gen.user
    SignUpPage.
        open.fill_form(
        user_name: user.full_name,
        email: user.email,
        password: user.password,
        password_confirmation: user.password).submit_form
    expect(HomePage).to_not be_authenticated
    expect(HomePage.given.text).to include('A message with a confirmation link has been sent to your email address. Please open the link to activate your account.')

    ConfirmationInstructionEmail.
        find_by_recipient(user.email).
        confirm_my_account
    expect(LoginPage.given.text).to include('Your account was successfully confirmed.')

    LoginPage.
        given.
        fill_form(email: user.email, password: user.password).submit_form
    expect(HomePage.given.text).to include('Signed in successfully.')
  end

  scenario "User can not sign up with blank data" do
    SignUpPage.
        open.fill_form(
        user_name: nil,
        email: nil,
        password: nil,
        password_confirmation: nil).submit_form
    expect(HomePage).to_not be_authenticated
    expect(SignUpPage.given.text).to include("2 errors prohibited this user from being saved: Email can't be blank Password can't be blank")
  end

  scenario "User can not sign up with blank username and password" do
    user = Gen.user
    SignUpPage.
        open.fill_form(
        user_name: nil,
        email: user.email,
        password: nil,
        password_confirmation: nil).submit_form
    expect(HomePage).to_not be_authenticated
    expect(SignUpPage.given.text).to include("1 error prohibited this user from being saved: Password can't be blank")
  end

  scenario "User can not sign up with blank email" do
    user = Gen.user
    SignUpPage.
        open.fill_form(
        user_name: nil,
        email: nil,
        password: user.password,
        password_confirmation: user.password).submit_form
    expect(HomePage).to_not be_authenticated
    expect(SignUpPage.given.text).to include("1 error prohibited this user from being saved: Email can't be blank")
  end

  scenario "User can not sign up with invalid email and empty password" do
    SignUpPage.
        open.fill_form(
        user_name: nil,
        email: 'test.1234567890',
        password: nil,
        password_confirmation: nil).submit_form
    expect(HomePage).to_not be_authenticated
    expect(SignUpPage.given.text).to include("2 errors prohibited this user from being saved: Email is invalid Password can't be blank")
  end

  scenario "User can not sign up with too short password" do
    user = Gen.user
    SignUpPage.
        open.fill_form(
        user_name: nil,
        email: user.email,
        password: '1234567',
        password_confirmation: '1234567').submit_form
    expect(HomePage).to_not be_authenticated
    expect(SignUpPage.given.text).to include("1 error prohibited this user from being saved: Password is too short (minimum is 8 characters)")
  end
  scenario "User can not sign up when password confirmation doesn`t match" do
    user = Gen.user
    SignUpPage.
        open.fill_form(
        user_name: nil,
        email: user.email,
        password: '1234567890',
        password_confirmation: '1234567890123').submit_form
    expect(HomePage).to_not be_authenticated
    expect(SignUpPage.given.text).to include("1 error prohibited this user from being saved: Password confirmation doesn't match Password")
  end

  scenario "User cannot sign up with duplicated email" do
    user = Gen.user
    sign_up_as(user)
    SignUpPage.
        open.fill_form(
        email: user.email,
        password: user.password,
        password_confirmation: user.password).submit_form
    expect(HomePage).to_not be_authenticated
    expect(SignUpPage.given.text).to include('1 error prohibited this user from being saved: Email has already been taken')
  end
end