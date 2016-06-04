require_relative 'main_menu'

class EditArticlePage < Howitzer::Web::Page
  validate :title, /\ADemo web application - Edit Article\z/

  element :article_title_field, :fillable_field, 'article[title]'
  element :article_text_field, :fillable_field, 'article[text]'
  element :create_article_button, :button, 'Update Article'

  include MainMenu

  def fill_form(title:nil, text:nil)
    log.info "Fill in Update Article form with title: #{title} , and body #{text}"
    article_title_field_element.set(title) unless title.nil?
    article_text_field_element.set(text) unless text.nil?
    self
  end

  def submit_form
    log.info "Submit Update Article form"
    create_article_button_element.click
    self
  end

end
