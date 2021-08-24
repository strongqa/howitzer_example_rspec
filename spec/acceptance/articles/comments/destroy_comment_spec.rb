require 'spec_helper'

RSpec.feature 'Destroy comment' do
  background 'Create article, comment' do
    @article = create(:article, category: create(:category, :default))
    Howitzer::Cache.store(:teardown, :article, @article.id)
    @comment = create(:comment, article: @article, user: create(:user, :default))
    log_in_as(create(:user, :admin))
    ArticlePage.open(id: @article.id)
  end

  scenario 'User can remove comment with confirmation action' do
    comment = @comment
    ArticlePage.on do
      destroy_comment(comment.body, confirmation: true)
      is_expected.to have_no_comment_item_element(comment.body)
    end
  end

  scenario 'User can not remove comment without confirmation action' do
    comment = @comment
    ArticlePage.on do
      destroy_comment(comment.body, confirmation: false)
      is_expected.to have_comment_item_element(comment.body)
    end
  end
end
