require 'spec_helper'

feature "Blank page" do
  scenario "Testing General Blank Page" do
    HomePage.open
    HomePage.displayed?
    Howitzer::Web::BlankPage.open
    Howitzer::Web::BlankPage.displayed?
  end

end
