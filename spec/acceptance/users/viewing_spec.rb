require 'spec_helper'

feature "Viewing Users" do
  attr_accessor :user1, :user2
  scenario "User is viewing other user on user page" do
    self.user1 = build(:user).save!
    self.user2 = build(:user).save!
    log_in_as(self.user2)
    UsersPage.open.open_user(self.user1.email)
    expect(UserViewPage.given.text).to include(self.user1.email)
  end
end