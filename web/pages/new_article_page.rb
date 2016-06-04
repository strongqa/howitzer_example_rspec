class NewArticlePage < Howitzer::Web::Page
  url '/articles/new/'
  validate :title, /\ADemo web application - New Article\z/

  element :article_title_field, :fillable_field, 'article[title]'
  element :article_text_field, :fillable_field, 'article[text]'
  element :create_article_button, :button, 'Create Article'

  def fill_form(title:nil, text:nil)
    log.info "Fill in Create article form with title: #{title} , and body #{text}"
    article_title_field_element.set(title) unless title.nil?
    article_text_field_element.set(text) unless text.nil?
    self
  end

  def submit_form
    log.info "Submit Create article form"
    create_article_button_element.click
    self
  end

end
