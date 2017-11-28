require 'spec_helper'

feature 'Howitzer - Capybara screenshot integration' do
  scenario 'Test suite can create page screenshot' do
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
