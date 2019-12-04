require 'spec_helper'

RSpec.feature 'Adding Comment' do
  background 'Create article, user, comment' do
    @article = create(:article, category: create(:category, :default))
    Howitzer::Cache.store(:teardown, :article, @article.id)
    @comment = build(:comment)
    log_in_as(create(:user, :admin))
    ArticlePage.open(id: @article.id)
  end

  scenario 'User can add comment with valid comment body', smoke: true do
    comment = @comment
    ArticlePage.on do
      fill_comment_form(body: comment.body)
      submit_form
      expect(alert_text.gsub(/×\s+/, '')).to include('Comment was successfully added to current article.')
    end
  end

  scenario 'User can not add comment with blank comment body' do
    ArticlePage.on do
      fill_comment_form(body: nil)
      submit_form
      expect(alert_text.gsub(/×\s+/, '')).to include("Body can't be blank")
    end
  end
end
