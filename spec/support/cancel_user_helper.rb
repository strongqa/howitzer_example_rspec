module CancelUserHelper
  def cancel_account
    EditAccountPage.open
    EditAccountPage.on { cancel_my_account }
    HomePage.on do
      expect(text).to include('Bye! Your account was successfully cancelled. We hope to see you again soon.')
    end
  end
end

RSpec.configure do |config|
  config.include CancelUserHelper
end
