require_relative 'main_menu'

class EditArticlePage < WebPage
  validates :title, pattern: /\ADemo web application - Edit Article\z/

  add_field_locator :article_title_field, 'article[title]'
  add_field_locator :article_text_field, 'article[text]'
  add_button_locator :create_article_button, 'Update Article'

  include MainMenu

  def fill_form(title:nil, text:nil)
    log.info "Fill in Update Article form with title: #{title} , and body #{text}"
    fill_in(field_locator(:article_title_field), with: title) unless title.nil?
    fill_in(field_locator(:article_text_field), with: text) unless text.nil?
    self
  end

  def submit_form
    log.info "Submit Update Article form"
    click_button(button_locator :create_article_button)
    self
  end

end
