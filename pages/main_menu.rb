module MainMenu
  def self.included(base)
    base.class_eval do
      add_locator   :menu, '#main_menu'
      add_locator   :menu_item,  lambda{|name| {xpath: ".//*[@id='main_menu']//a[.='#{name}']"} }
      add_locator :menu_small, '.navbar-toggle'
      add_locator :error_message, css: '#error_explanation'
      add_locator :flash_message, css: '#flash_notice'

      def self.authenticated?
        find(locator(:menu_small)).click if phantomjs_driver?
        find(locator :menu)
        find(locator(:menu_item).('Logout'))
      rescue Capybara::ElementNotFound
        !first(locator(:menu_item).('Logout')).nil?
      end
    end
  end

  def choose_menu(text)
    log.info "Open '#{text}' menu"
    if phantomjs_driver?
      find(locator(:menu_small)).click
      click_link("#{text}",match: :first)
    else
      find(locator(:menu_item).(text)).click
    end
  end

  def flash_message
    find(locator(:flash_message)).text
  end

  def error_message
    find(locator(:error_message)).text
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