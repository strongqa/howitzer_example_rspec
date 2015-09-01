require_relative 'main_menu'

class ArticleListPage < WebPage
  URL = '/articles/'
  validates :title, pattern: /\ADemo web application - Listing Articles\z/

  include MainMenu

  add_locator :new_article_button,  xpath: "//a[@href='/articles/new']"
  add_locator :article_button, lambda{|title| {xpath: "//a[contains(.,'#{title}')]"} }
  add_locator :destroy_button, ->(title) { {xpath: "//strong[.='#{title}']/following-sibling::a[normalize-space(.)='Destroy'][1]"} }
  add_locator :edit_button, ->(title) { {xpath: "//strong[.='#{title}']/following-sibling::a[normalize-space(.)='Edit'][1]"} }

  def add_new_article
    log.info "Adding new article"
    find(locator(:new_article_button)).click
    NewArticlePage.given
  end

  def edit_article(title)
    log.info "Edit article: '#{title}'"
    find(apply(locator(:edit_button), title)).click
  end

  def destroy_article(title, confirmation = true)
    log.info "Destroy article: '#{title}' with confirmation: '#{confirmation}'"
    destroy = -> {find(apply(locator(:destroy_button), title)).click}
    if confirmation
      accept_js_confirmation do
        destroy.call
      end
    else
      dismiss_js_confirmation do
        destroy.call
      end
    end
  end

  def open_article(text)
    log.info "Open '#{text}' article"
    if phantomjs_driver?
      click_link(text, match: :first)
    else
      find(apply(locator(:article_button),(text))).click
    end
  end
end