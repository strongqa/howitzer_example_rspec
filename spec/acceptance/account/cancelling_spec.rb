require 'spec_helper'

feature "Account cancelling" do
  scenario "User can cancel his own account if he is signed in" do
    user = Gen.user
    sign_up_as(user)
    log_in_as(user)

    EditAccountPage.open
                   .cancel_my_account
    expect(HomePage.given.text).to include("Bye! Your account was successfully cancelled. We hope to see you again soon.")
  end

end


