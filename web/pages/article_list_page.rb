require_relative 'main_menu'

class ArticleListPage < Howitzer::Web::Page
  url '/articles/'
  validate :title, /\ADemo web application - Listing Articles\z/

  include MainMenu

  element :new_article_button, :xpath, "//a[@href='/articles/new']"
  element :article_button, :xpath, ->(title) { "//a[contains(.,'#{title}')]" }
  element :destroy_button, :xpath, ->(title) { "//strong[.='#{title}']/following-sibling::a[normalize-space(.)='Destroy'][1]" }
  element :edit_button, :xpath, ->(title) { "//strong[.='#{title}']/following-sibling::a[normalize-space(.)='Edit'][1]" }
  element :article_link, :link, ->(text){ text }, match: :first

  def add_new_article
    log.info "Adding new article"

    new_article_button_element.click
    NewArticlePage.given
  end

  def edit_article(title)
    log.info "Edit article: '#{title}'"
    edit_button_element(title).click
  end

  def destroy_article(title, confirmation = true)
    log.info "Destroy article: '#{title}' with confirmation: '#{confirmation}'"
    destroy = -> { destroy_button_element(title).click }
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
      article_link_element.click
    else
      article_button_element(text).click
    end
  end
end
