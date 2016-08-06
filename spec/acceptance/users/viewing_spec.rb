require 'spec_helper'

feature 'Viewing Users' do
  scenario 'User is viewing other user on user page' do
    user1 = create(:user)
    user2 = create(:user)
    log_in_as(user2)
    UsersPage.open
    UsersPage.on { open_user(user1.email) }
    UserViewPage.on { expect(text).to include(user1.email) }
  end
end
