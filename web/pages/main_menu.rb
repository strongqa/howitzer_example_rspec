module MainMenu
  def self.included(base)
    base.class_eval do
      element :menu, '#main_menu'
      element :menu_item, :xpath, ->(name){ ".//*[@id='main_menu']//a[.='#{name}']" }
      element :menu_small, '.navbar-toggle'
      element :error_message, '#error_explanation'
      element :flash_message, '#flash_notice'
      element :first_link, ->(text){ text }, match: :first

      def self.authenticated?
        menu_small_element.click if phantomjs_driver?
        menu_element
        has_menu_item_element?('Logout')
      rescue Capybara::ElementNotFound
        menu_item_elements('Logout').first.nil?
      end
    end
  end

  def choose_menu(text)
    log.info "Open '#{text}' menu"
    if phantomjs_driver?
      menu_small_element.click
      first_link(text).click
    else
      menu_item_element(text).click
    end
  end

  def flash_message
    flash_message_element.text
  end

  def error_message
    error_message_element.text
  end

  private

  def accept_js_confirmation
    page.execute_script 'window.confirm = function(){return true;}'
    yield
    window_confirm
  end

  def dismiss_js_confirmation
    page.execute_script 'window.confirm = function(){return false;}'
    yield
    window_confirm
  end

  def window_confirm
    page.execute_script 'return window.confirm'
  end
end
