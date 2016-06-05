require 'spec_helper'

feature "Blank page" do
  scenario "Testing General Blank Page" do
    HomePage.open
    HomePage.wait_for_opened
    Howitzer::Web::BlankPage.open
    Howitzer::Web::BlankPage.wait_for_opened
  end

end
