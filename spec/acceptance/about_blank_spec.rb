require 'spec_helper'

RSpec.feature 'Blank page' do
  scenario 'Testing General Blank Page' do
    HomePage.open
    expect(HomePage).to be_displayed
    Howitzer::Web::BlankPage.open
    expect(Howitzer::Web::BlankPage).to be_displayed
  end
end
