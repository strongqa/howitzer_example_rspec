require 'spec_helper'

feature "Password Resetting" do

  background "sign up user" do
    @user1 = build(:user).save!
  end

  scenario "User can reset password with correct data" do
    user2 = build(:user)
    user_restores_password(@user1.email)
    ChangePasswordPage.given.
        fill_form(new_password: user2.password,
                  confirm_new_password: user2.password).
        submit_form
    expect(HomePage.given.flash_section.flash_message).to eql("Your password was changed successfully. You are now signed in.")
  end

  scenario "user can not reset password with incorrect confirmation password", :p1 => true do
    user_restores_password(@user1.email)
    ChangePasswordPage.given.
        fill_form(new_password: 1234567890,
                  confirm_new_password: 1234567).
        submit_form
    expect(ChangePasswordPage.given.errors_section.error_message).to eql("1 error prohibited this user from being saved: Password confirmation doesn't match Password")
  end

  scenario "user can not reset password with too short new password", :p1 => true do
    user_restores_password(@user1.email)
    ChangePasswordPage.given.
        fill_form(new_password: 1234567,
                  confirm_new_password: 1234567).
        submit_form
    expect(ChangePasswordPage.given.errors_section.error_message).to eql("1 error prohibited this user from being saved: Password is too short (minimum is 8 characters)")
  end

  scenario "user can not reset password with incorrect email", :p1 => true do
    LoginPage.open.
        navigate_to_forgot_password_page
    ForgotPasswordPage.given.
        fill_form(email: "test.1234567890").
        submit_form
    expect(ForgotPasswordPage).to be_displayed
  end

  scenario "user can login with old password until confirmation email for new password is not confirmed" do
    LoginPage.open.
        navigate_to_forgot_password_page
    ForgotPasswordPage.given.
        fill_form(email: @user1.email).
        submit_form
    expect(LoginPage.given.flash_section.flash_message).to eql("You will receive an email with instructions on how to reset your password in a few minutes.")
    log_in_as(@user1)
  end
end
