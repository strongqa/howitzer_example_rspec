# require 'capybara-screenshot/rspec/text_reporter'
# module Capybara
#   module Screenshot
#     module RSpec
#       module TextReporter
#         private
#         def output_screenshot_info(example)
#           return unless (screenshot = example.metadata[:screenshot])
#           if screenshot[:html]
#             path = screenshot[:html].sub(Howitzer.log_dir, ENV['CI_ARTIFACTS_PATH'] || "file://#{Howitzer.log_dir}")
#             output.puts(long_padding + CapybaraScreenshot::Helpers.yellow("HTML screenshot: #{path}"))
#           end
#           if screenshot[:image]
#             path = screenshot[:image].sub(Howitzer.log_dir, ENV['CI_ARTIFACTS_PATH'] || "file://#{Howitzer.log_dir}")
#             output.puts(long_padding + CapybaraScreenshot::Helpers.yellow("Image screenshot: #{path}"))
#           end
#         end
#       end
#     end
#   end
# end
