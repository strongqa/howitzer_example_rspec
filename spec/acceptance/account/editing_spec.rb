require 'spec_helper'

RSpec.feature 'Account Editing' do
  scenario 'User can edit password and name with correct credentials' do
    user1 = create(:user)
    user2 = build(:user)
    log_in_as(user1)
    EditAccountPage.open
    EditAccountPage.on do
      fill_form(
        user_name: user2.name,
        email: user1.email,
        password: user2.password,
        password_confirmation: user2.password,
        current_password: user1.password
      )
      submit_form
    end
    expect(HomePage).to be_displayed
    HomePage.on do
      expect(flash_section.flash_message).to eql('You updated your account successfully.')
      main_menu_section.choose_menu('Logout')
    end
    expect(HomePage).to be_not_authenticated
    LoginPage.open
    LoginPage.on do
      fill_form(
        email: user1.email,
        password: user2.password
      )
      submit_form
    end
    expect(HomePage).to be_authenticated
    EditAccountPage.open
    EditAccountPage.on do
      expect(form_data).to eq(user_name: user2.name,
                              email: user1.email,
                              password: '',
                              password_confirmation: '',
                              current_password: '')
    end
  end

  scenario 'User can edit email with correct credentials', p1: true do
    user1 = create(:user)
    user2 = build(:user)
    log_in_as(user1)
    EditAccountPage.open
    EditAccountPage.on do
      fill_form(user_name: user1.name,
                email: user2.email,
                password: '',
                password_confirmation: '',
                current_password: user1.password)
      submit_form
    end
    HomePage.on do
      expect(flash_section.flash_message).to eql(
        'You updated your account successfully, but we need to verify your new email address.' \
        ' Please check your email and click on the confirm link to finalize confirming your new email address.'
      )
    end
    ConfirmationInstructionEmail.find_by_recipient(user2.email).confirm_my_account
    HomePage.on do
      expect(flash_section.flash_message).to eql('Your account was successfully confirmed.')
      main_menu_section.choose_menu('Logout')
    end
    expect(HomePage).to be_not_authenticated
    LoginPage.open
    LoginPage.on do
      fill_form(
        email: user2.email,
        password: user1.password
      )
      submit_form
    end
    expect(HomePage).to be_authenticated
    HomePage.on do
      expect(flash_section.flash_message).to eql('Signed in successfully.')
    end
  end

  scenario 'User can not edit account with incorrect email', p1: true do
    user1 = create(:user)
    log_in_as(user1)
    EditAccountPage.open
    EditAccountPage.on do
      fill_form(
        user_name: user1.name,
        email: 'test@.ua',
        current_password: user1.password
      )
      submit_form
    end
    expect(EditAccountPage).to be_displayed
  end

  scenario 'User can not edit account with existing email', p1: true do
    user1 = create(:user)
    user2 = create(:user)
    log_in_as(user2)
    EditAccountPage.open
    EditAccountPage.on do
      fill_form(
        user_name: user1.name,
        email: user1.email,
        current_password: user2.password
      )
      submit_form
    end
    EditAccountPage.on do
      expect(errors_section.error_message).to eql(
        '1 error must be fixed Email has already been taken'
      )
    end
  end

  scenario 'User can not edit account with incorrect password', p1: true do
    user1 = create(:user)
    user2 = build(:user)
    log_in_as(user1)
    EditAccountPage.open
    EditAccountPage.on do
      fill_form(
        user_name: user1.name,
        email: user1.email,
        password: user2.password,
        password_confirmation: user2.password,
        current_password: 'incorrect_password'
      )
      submit_form
    end
    EditAccountPage.on do
      expect(errors_section.error_message).to eql(
        '1 error must be fixed Current password is invalid'
      )
    end
  end

  scenario 'User can not edit account with incorrect password confirmation', p1: true do
    user1 = create(:user)
    log_in_as(user1)
    EditAccountPage.open
    EditAccountPage.on do
      fill_form(
        user_name: user1.name,
        email: user1.email,
        password: '12345678',
        password_confirmation: '123456789',
        current_password: user1.password
      )
      submit_form
    end
    EditAccountPage.on do
      expect(errors_section.error_message).to eql(
        "1 error must be fixed Password confirmation doesn't match Password"
      )
    end
  end

  scenario 'User can not edit account with short password (less then 8 characters)', p1: true do
    user1 = create(:user)
    log_in_as(user1)
    EditAccountPage.open
    EditAccountPage.on do
      fill_form(
        user_name: user1.name,
        email: user1.email,
        password: '1234567',
        password_confirmation: '1234567',
        current_password: user1.password
      )
      submit_form
    end
    EditAccountPage.on do
      expect(errors_section.error_message).to eql(
        '1 error must be fixed Password is too short (minimum is 8 characters)'
      )
    end
  end
end
