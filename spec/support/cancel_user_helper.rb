module CancelUserHelper
  def cancel_account()
    EditAccountPage.open
        .cancel_my_account
    expect(HomePage.given.text).to include("Bye! Your account was successfully cancelled. We hope to see you again soon.")
  end
end

RSpec.configure do |config|
  config.include CancelUserHelper
end