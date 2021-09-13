require 'spec_helper'

RSpec.feature 'Destroy comment' do
  let(:article) { create(:article, category: create(:category, :default)) }
  let!(:comment) { create(:comment, article: article, user: create(:user, :default)) }

  background 'Create article, comment' do
    Howitzer::Cache.store(:teardown, :article, article.id)
    log_in_as(create(:user, :admin))
    ArticlePage.open(id: article.id)
  end

  scenario 'User can remove comment with confirmation action' do
    comment_body = comment.body
    ArticlePage.on do
      destroy_comment(comment_body, confirmation: true)
      expect(self).to have_no_comment_item_element(lambda_args(comment: comment_body))
    end
  end

  scenario 'User can not remove comment without confirmation action' do
    comment_body = comment.body
    ArticlePage.on do
      destroy_comment(comment_body, confirmation: false)
      expect(self).to have_comment_item_element(lambda_args(comment: comment_body))
    end
  end
end
