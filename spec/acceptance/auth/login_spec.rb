require 'spec_helper'

RSpec.feature 'Log In' do
  scenario 'user can open login page via menu' do
    HomePage.open
    HomePage.on { main_menu_section.choose_menu('Login') }
    expect(LoginPage).to be_displayed
  end

  scenario 'Visitor can login with correct credentials' do
    user = create(:user)
    log_in_as(user)
    expect(HomePage).to be_authenticated
    expect(HomePage).to be_displayed
  end

  scenario 'User can not login with blank password', p1: true do
    user = create(:user)
    LoginPage.open
    LoginPage.on do
      fill_form(email: user.email,
                password: nil)
      submit_form
    end
    # expect(HomePage).to be_not_authenticated
    LoginPage.on do
      expect(text).to include('Invalid email or password.')
    end
  end

  scenario 'User can not login with blank email', p1: true do
    user = create(:user)
    LoginPage.open
    LoginPage.on do
      fill_form(email: nil,
                password: user.email)
      submit_form
    end
    # expect(HomePage).to be_not_authenticated
    LoginPage.on do
      expect(text).to include('Invalid email or password.')
    end
  end

  scenario 'User can not login with blank email and passwnord', p1: true do
    LoginPage.open
    LoginPage.on do
      fill_form(email: nil,
                password: nil)
      submit_form
    end
    # expect(HomePage).to be_not_authenticated
    LoginPage.on do
      expect(text).to include('Invalid email or password.')
    end
  end

  scenario 'User can not login with incorrect email', p1: true do
    user = create(:user)
    LoginPage.open
    LoginPage.on do
      fill_form(email: 'test@test.com',
                password: user.password)
      submit_form
    end
    # expect(HomePage).to be_not_authenticated
    LoginPage.on do
      expect(text).to include('Invalid email or password.')
    end
  end

  scenario 'User can not login with incorrect password', p1: true do
    user = create(:user)
    LoginPage.open
    LoginPage.on do
      fill_form(email: user.email,
                password: 'test_password')
      submit_form
    end
    # expect(HomePage).to be_not_authenticated
    LoginPage.on do
      expect(text).to include('Invalid email or password.')
    end
  end

  scenario 'User can not login with incorrect email and password', p1: true do
    LoginPage.open
    LoginPage.on do
      fill_form(email: 'test@test.com',
                password: 'test_password')
      submit_form
    end
    # expect(HomePage).to be_not_authenticated
    LoginPage.on do
      expect(text).to include('Invalid email or password.')
    end
  end

  scenario 'User can not login with incorrect email and blank password', p1: true do
    LoginPage.open
    LoginPage.on do
      fill_form(email: 'test.1234567890',
                password: nil)
      submit_form
    end
    # expect(HomePage).to be_not_authenticated
    expect(LoginPage).to be_displayed
  end

  scenario 'User can not login until confirmation email is not confirmed' do
    user = build(:user)
    sign_up_without_confirmation(user)
    LoginPage.open
    LoginPage.on do
      fill_form(email: user.email,
                password: user.password)
      submit_form
    end
    # expect(HomePage).to be_not_authenticated
    LoginPage.on do
      expect(text).to include('You have to confirm your account before continuing.')
    end
  end

  scenario 'Canceled user can not login' do
    user = create(:user)
    log_in_as(user)
    cancel_account
    LoginPage.open
    LoginPage.on do
      fill_form(email: user.email,
                password: user.password)
      submit_form
    end
    # expect(HomePage).to be_not_authenticated
    LoginPage.on do
      expect(text).to include('Invalid email or password.')
    end
  end
end
