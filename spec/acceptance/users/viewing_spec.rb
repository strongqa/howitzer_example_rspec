require 'spec_helper'

feature "Viewing Users" do
  scenario "User is viewing other user on user page" do
    user1 = Gen.user
    user2 = Gen.user
    sign_up_as(user1)
    sign_up_as(user2)
    log_in_as(user2)
    UsersPage.open.open_user(user1.email)
    expect(UserViewPage.given.text).to include(user1.email)
  end
end