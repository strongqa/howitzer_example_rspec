class NewArticlePage < WebPage
  URL = '/articles/new/'
  validates :title, pattern: /\ADemo web application - New Article\z/

  add_field_locator :article_title_field, 'article[title]'
  add_field_locator :article_text_field, 'article[text]'
  add_button_locator :create_article_button, 'Create Article'

  def fill_form(title:nil, text:nil)
    log.info "Fill in Create article form with title: #{title} , and body #{text}"
    fill_in(field_locator(:article_title_field), with: title) unless title.nil?
    fill_in(field_locator(:article_text_field), with: text) unless text.nil?
    self
  end

  def submit_form
    log.info "Submit Create article form"
    click_button(button_locator :create_article_button)
    self
  end

end
