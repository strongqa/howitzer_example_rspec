require 'spec_helper'

RSpec.feature 'Article Viewing' do
  background 'Create article, comment' do
    @article = create(:article, category: create(:category, :default))
    @comment = create(:comment, article: @article, user: create(:user, :default))
    log_in_as(create(:user, :admin))
    ArticlePage.open(id: @article.id)
  end

  scenario 'Admin is viewing article page', smoke: true do
    article = @article
    comment = @comment
    ArticlePage.on do
      expect(text).to include(article.title)
      expect(text).to include(article.text)
      expect(text).to include(comment.body)
      is_expected.to have_comment_form_element
      is_expected.to have_comment_field_element
      is_expected.to have_edit_article_button_element
      is_expected.to have_add_comment_button_element
      is_expected.to have_destroy_comment_element(comment.body)
    end
  end

  scenario 'Admin can be redirected from article page back to article list' do
    ArticlePage.on { back_to_article_list }
    expect(ArticleListPage).to be_displayed
  end
end
