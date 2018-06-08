require 'spec_helper'

RSpec.feature 'Viewing Users By Users with different roles' do
  scenario "Non-admin user can't be viewing other user on user page" do
    user2 = create(:user)
    log_in_as(user2)
    UsersPage.open(validate: false)
    expect(HomePage).to be_displayed
  end

  scenario 'Admin user can be viewing other user on user page' do
    user1 = create(:user, :admin)
    user2 = create(:user)
    log_in_as(user1)
    UsersPage.open
    UsersPage.on { open_user(user2.name) }
    UserViewPage.on { expect(text).to include(user2.name) }
  end
end
