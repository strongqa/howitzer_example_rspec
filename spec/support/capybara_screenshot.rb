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

    class Saver
      # Bug https://github.com/mattheworiordan/capybara-screenshot/issues/164
      def save_html
        path = html_path
        clear_save_and_open_page_path do
          if Capybara::VERSION.match(/^\d+/)[0] == '1'
            capybara.save_page(page.body, path.to_s)
          else
            capybara.save_page("#{file_base_name}.html")
          end
        end
        @html_saved = true
      end
    end
  end
end
