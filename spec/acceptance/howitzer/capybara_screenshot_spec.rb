require 'spec_helper'

RSpec.feature 'Howitzer - Capybara screenshot integration' do
  scenario 'Test suite can create page screenshot' do
    HomePage.open
    HomePage.on do
      Capybara::Screenshot.screenshot_and_save_page
    end
    screenshot = File.join(File.dirname(__FILE__), '../../../log/screenshot.png')
    expect(File.exist?(screenshot)).to be_truthy
  end
end
