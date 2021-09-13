require 'spec_helper'

RSpec.feature 'Article Viewing' do
  let(:article) { create(:article, category: create(:category, :default)) }
  let!(:comment) { create(:comment, article: article, user: create(:user, :default)) }

  background 'Create article, comment' do
    Howitzer::Cache.store(:teardown, :article, article.id)
    log_in_as(create(:user, :admin))
    ArticlePage.open(id: article.id)
  end

  scenario 'Admin is viewing article page', smoke: true do
    article_obj = article
    comment_body = comment.body
    ArticlePage.on do
      expect(text).to include(article_obj.title)
      expect(text).to include(article_obj.text)
      expect(text).to include(comment_body)
      expect(self).to have_comment_form_element
      expect(self).to have_comment_field_element
      expect(self).to have_edit_article_button_element
      expect(self).to have_add_comment_button_element
      expect(self).to have_destroy_comment_element
    end
  end

  scenario 'Admin can be redirected from article page back to article list' do
    ArticlePage.on { back_to_article_list }
    expect(ArticleListPage).to be_displayed
  end
end
