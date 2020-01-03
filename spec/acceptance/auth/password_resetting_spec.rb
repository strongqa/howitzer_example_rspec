require 'spec_helper'

RSpec.feature 'Password Resetting' do
  scenario 'User can reset password with correct data' do
    user1 = create(:user)
    user2 = build(:user)
    user_restores_password(user1.email)
    ChangePasswordPage.on do
      fill_form(new_password: user2.password,
                confirm_new_password: user2.password)
      submit_form
    end
    HomePage.on do
      expect(flash_section.flash_message).to eql('Your password was changed successfully. You are now signed in.')
    end
  end

  scenario 'user can not reset password with incorrect confirmation password', p1: true do
    user = create(:user)
    user_restores_password(user.email)
    ChangePasswordPage.on do
      fill_form(new_password: 1_234_567_890,
                confirm_new_password: 1_234_567)
      submit_form
      expect(sanitized_alert_text).to eql(
        "1 ERROR PROHIBITED THIS USER FROM BEING SAVED: Password confirmation doesn't match Password"
      )
    end
  end

  scenario 'user can not reset password with too short new password', p1: true do
    user = create(:user)
    user_restores_password(user.email)
    ChangePasswordPage.on do
      fill_form(new_password: 1_234_567,
                confirm_new_password: 1_234_567)
      submit_form
      expect(sanitized_alert_text).to eql(
        '1 ERROR PROHIBITED THIS USER FROM BEING SAVED: Password is too short (minimum is 8 characters)'
      )
    end
  end

  scenario 'user can not reset password with incorrect email', p1: true do
    LoginPage.open
    LoginPage.on { navigate_to_forgot_password_page }
    ForgotPasswordPage.on do
      fill_form(email: 'test.1234567890')
      submit_form
    end
    expect(ForgotPasswordPage).to be_displayed
  end

  scenario 'user can login with old password until confirmation email for new password is not confirmed' do
    user = create(:user)
    LoginPage.open
    LoginPage.on { navigate_to_forgot_password_page }
    ForgotPasswordPage.on do
      fill_form(email: user.email)
      submit_form
    end
    LoginPage.on do
      expect(flash_section.flash_message).to eql(
        'You will receive an email with instructions on how to reset your password in a few minutes.'
      )
    end
    log_in_as(user)
  end
end
