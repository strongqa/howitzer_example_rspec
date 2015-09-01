require 'spec_helper'

feature "Viewing Users" do

  scenario "User is viewing other user on user page" do
    user1 = build(:user).save!
    user2 = build(:user).save!
    log_in_as(user2)
    UsersPage.open.open_user(user1.email)
    expect(UserViewPage.given.text).to include(user1.email)
  end
end