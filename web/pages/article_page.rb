require_relative 'main_menu'

class ArticlePage < Howitzer::Web::Page
  url '/articles{/id}'
  validate :title, /\ADemo web application - Article\z/
  validate :url, /\/articles\/\d+\/?\z/

  element :comment_field, :fillable_field, 'comment_body'
  element :add_comment_button, :button, 'Create comment'
  element :commenter_name, :xpath, ".//p[contains(.,'Commenter:')]"
  element :comment_text, :xpath, ".//p[contains(.,'Comment:')]"
  element :destroy_comment, :xpath, ->(comment) { ".//p[contains(.,'#{comment}')]/following-sibling::p/a[.='Destroy Comment']" }
  element :article_button, :xpath, ->(title){ "//a[contains(.,'#{title}')]" }
  element :comment_form, "#new_comment"
  element :back_to_articles, :xpath, ".//a[contains(.,'Back to Articles')]"
  element :edit_article_button, :xpath, ".//a[contains(.,'Edit Article')]"

  include MainMenu

  def fill_comment_form(body: nil)
    log.info "Fill in Add Comment form with body: #{body}"
    comment_field.set(body) unless body.nil?
  end

  def submit_form
    log.info "Submit Add Comment form"
    add_comment_button_element.click
  end

  def comment_data
    {
        commenter: commenter_name_element.text.gsub(/Commenter: /, ''),
        comment: comment_text_element.text.gsub(/Comment: /, '')
    }
  end

  def click_article_button(text)
    log.info "Open '#{text}' article"
    article_button_element(text).click
  end

  def destroy_comment(comment_text,confirmation = true)
    log.info "Destroy comment  '#{comment_text}' on article page with confirmation: '#{confirmation}'"
    destroy = -> { destroy_comment_element(comment_text).click }
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

  def back_to_article_list
    back_to_articles_element.click
  end

end
