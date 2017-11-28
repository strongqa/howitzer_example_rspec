require 'spec_helper'

RSpec.feature 'Sign Up' do
  scenario 'Visitor can open sign up page via menu from home page' do
    HomePage.open
    HomePage.on { main_menu_section.choose_menu('Sign up') }
    expect(SignUpPage).to be_displayed
  end

  scenario 'Visitor can open sign up page via menu from login page' do
    LoginPage.open
    LoginPage.on { main_menu_section.choose_menu('Sign up') }
    expect(SignUpPage).to be_displayed
  end

  scenario 'User can sign up with correct data' do
    user = build(:user)
    SignUpPage.open
    SignUpPage.on do
      fill_form(user_name: user.name,
                email: user.email,
                password: user.password,
                password_confirmation: user.password)
      submit_form
    end
    expect(HomePage).to be_not_authenticated
    HomePage.on do
      expect(text).to include(
        'A message with a confirmation link has been sent to your email address.' \
        ' Please open the link to activate your account.'
      )
    end
    ConfirmationInstructionEmail.find_by_recipient(user.email).confirm_my_account
    LoginPage.on do
      expect(text).to include('Your account was successfully confirmed.')
      fill_form(email: user.email,
                password: user.password)
      submit_form
    end
    expect(HomePage.given.text).to include('Signed in successfully.')
  end

  scenario 'User can not sign up with blank data', p1: true do
    SignUpPage.open
    SignUpPage.on do
      fill_form(user_name: nil,
                email: nil,
                password: nil,
                password_confirmation: nil)
      submit_form
    end
    expect(HomePage).to be_not_authenticated
    SignUpPage.on do
      expect(text).to include(
        "2 errors prohibited this user from being saved: Email can't be blank Password can't be blank"
      )
    end
  end

  scenario 'User can not sign up with blank username and password', p1: true do
    user = build(:user)
    SignUpPage.open
    SignUpPage.on do
      fill_form(user_name: nil,
                email: user.email,
                password: nil,
                password_confirmation: nil)
      submit_form
    end
    expect(HomePage).to be_not_authenticated
    SignUpPage.on do
      expect(text).to include("1 error prohibited this user from being saved: Password can't be blank")
    end
  end

  scenario 'User can not sign up with blank email', p1: true do
    user = build(:user)
    SignUpPage.open
    SignUpPage.on do
      fill_form(user_name: nil,
                email: nil,
                password: user.password,
                password_confirmation: user.password)
      submit_form
    end
    expect(HomePage).to be_not_authenticated
    SignUpPage.on do
      expect(text).to include("1 error prohibited this user from being saved: Email can't be blank")
    end
  end

  scenario 'User can not sign up with invalid email and empty password', p1: true do
    SignUpPage.open
    SignUpPage.on do
      fill_form(user_name: nil,
                email: 'test.1234567890',
                password: nil,
                password_confirmation: nil)
      submit_form
    end
    expect(HomePage).to be_not_authenticated
    expect(SignUpPage).to be_displayed
  end

  scenario 'User can not sign up with too short password', p1: true do
    user = build(:user)
    SignUpPage.open
    SignUpPage.on do
      fill_form(user_name: nil,
                email: user.email,
                password: '1234567',
                password_confirmation: '1234567')
      submit_form
    end
    expect(HomePage).to be_not_authenticated
    SignUpPage.on do
      expect(text).to include(
        '1 error prohibited this user from being saved: Password is too short (minimum is 8 characters)'
      )
    end
  end

  scenario 'User can not sign up when password confirmation doesn`t match', p1: true do
    user = build(:user)
    SignUpPage.open
    SignUpPage.on do
      fill_form(user_name: nil,
                email: user.email,
                password: '1234567890',
                password_confirmation: '1234567890123')
      submit_form
    end
    expect(HomePage).to be_not_authenticated
    SignUpPage.on do
      expect(text).to include(
        "1 error prohibited this user from being saved: Password confirmation doesn't match Password"
      )
    end
  end

  scenario 'User cannot sign up with duplicated email', p1: true do
    user = create(:user)
    SignUpPage.open
    SignUpPage.on do
      fill_form(email: user.email,
                password: user.password,
                password_confirmation: user.password)
      submit_form
    end
    expect(HomePage).to be_not_authenticated
    SignUpPage.on do
      expect(text).to include('1 error prohibited this user from being saved: Email has already been taken')
    end
  end
end
