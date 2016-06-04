require_relative 'main_menu'

class HomePage < Howitzer::Web::Page
  url '/'
  validate :title, /\ADemo web application - Home\z/
  validate :url, /\A(?:.*?:\/\/)?[^\/]*\/?\z/

  element :article_link, :xpath, ->(title) { ".//a[.='#{title}']"} }
  element :panel_heading, :xpath, ->(title) { "//h3[text()=\"#{title}\"]/parent::*/following-sibling::*"} }

  include MainMenu

  def view_article(article_title)
    log.info "Open article page byb title: '#{article_title}'"
    article_link_elemnt(article_title).click
    ArticlePage.given
  end

  def find_form_text(panel_title)
    panel_heading_element(panel_title).text
  end
end
