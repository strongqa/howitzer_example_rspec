require 'spec_helper'

RSpec.feature 'Adding Comment' do
  let(:article) { create(:article, category: create(:category, :default)) }
  let(:comment) { build(:comment) }

  background 'Create article, user, comment' do
    Howitzer::Cache.store(:teardown, :article, article.id)
    log_in_as(create(:user, :admin))
    ArticlePage.open(id: article.id)
  end

  scenario 'User can add comment with valid comment body', smoke: true do
    comment_body = comment.body
    ArticlePage.on do
      fill_comment_form(body: comment_body)
      submit_form
      expect(sanitized_alert_text).to eql('Comment was successfully added to current article.')
    end
  end

  scenario 'User can not add comment with blank comment body' do
    ArticlePage.on do
      fill_comment_form(body: nil)
      submit_form
      expect(sanitized_alert_text).to eql("Body can't be blank")
    end
  end
end
