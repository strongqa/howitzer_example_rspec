require 'spec_helper'

feature "Account cancelling" do
  attr_accessor :user
  scenario "User can cancel his own account if he is signed in" do
    self.user = build(:user).save!
    log_in_as(self.user)

    EditAccountPage.open
                   .cancel_my_account
    expect(HomePage.given.text).to include("Bye! Your account was successfully cancelled. We hope to see you again soon.")
  end

end


