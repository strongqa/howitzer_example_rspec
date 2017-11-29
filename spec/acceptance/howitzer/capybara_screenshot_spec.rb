require 'spec_helper'

RSpec.feature 'Howitzer - Capybara screenshot integration' do
  scenario 'Capybara screenshot library stores screenshot and source page in proper location' do
    HomePage.open
    HomePage.on do
      Capybara::Screenshot.screenshot_and_save_page
    end
    screenshot = File.join(File.dirname(__FILE__), '../../../log/screenshot.png')
    expect(File).to be_exist(screenshot)
    source_page = File.join(File.dirname(__FILE__), '../../../log/screenshot.html')
    expect(File).to be_exist(source_page)
  end
end
