require 'capybara-screenshot/rspec/text_reporter'
require 'capybara-screenshot/saver'
module Capybara
  module Screenshot
    module RSpec
      module TextReporter
        private

        def output_screenshot_info(example)
          return unless (meta = example.metadata[:screenshot])

          output.puts(build_text("HTML screenshot: #{build_path(meta[:html])}")) if meta[:html]
          output.puts(build_text("Image screenshot: #{build_path(meta[:image])}")) if meta[:image]
        end

        def build_text(value)
          long_padding + CapybaraScreenshot::Helpers.yellow(value)
        end

        def build_path(relative_path)
          if ENV['CI'] == 'true'
            File.join(ENV['CI_ARTIFACTS_PATH'], relative_path)
          else
            'file://' + File.expand_path(File.join(__dir__, '..', '..', relative_path))
          end
        end
      end
    end
  end
end
