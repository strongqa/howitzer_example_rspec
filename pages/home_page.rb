require_relative 'main_menu'

class HomePage < WebPage
  URL = '/'
  validates :title, pattern: /\ADemo web application - Home\z/
  validates :url, pattern: /\A(?:.*?:\/\/)?[^\/]*\/?\z/

  add_locator :article_link, lambda{|title| {xpath: ".//a[.='#{title}']"}}
  add_locator :panel_heading, lambda{|title| {xpath: "//h3[text()=\"#{title}\"]/parent::*/following-sibling::*"}}

  include MainMenu

  def view_article(article_title)
    log.info "Open article page byb title: '#{article_title}'"
    find(apply(locator(:article_link), article_title)).click
    ArticlePage.given
  end

  def find_form_text(panel_title)
    find(apply(locator(:panel_heading), panel_title)).text
  end
end