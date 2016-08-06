require 'spec_helper'

feature 'Article Viewing' do
  background 'Create article, comment' do
    @article = create(:article)
    @comment = @article.comments.create(
      body: 'Some comment',
      user_id: User.where(email: settings.def_test_user).all.first.id
    )
    log_in_as_admin
    ArticlePage.open(id: @article.id)
  end

  scenario 'Admin is viewing article page' do
    article = @article
    comment = @comment
    ArticlePage.on do
      expect(text).to include(article.title)
      expect(text).to include(article.text)
      expect(text).to include(settings.def_test_user)
      expect(text).to include(comment.body)
      is_expected.to have_comment_form_element
      is_expected.to have_comment_field_element
      is_expected.to have_edit_article_button_element
      is_expected.to have_add_comment_button_element
      is_expected.to have_destroy_comment_element(comment.body)
    end
  end

  scenario 'Admin can be redirected from article page back to article list', p1: true do
    ArticlePage.on { back_to_article_list }
    expect(ArticleListPage).to be_displayed
  end
end
