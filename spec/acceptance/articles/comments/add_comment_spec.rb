require 'spec_helper'

feature 'Adding Comment' do
  background 'Create article, user, comment' do
    article = create(:article)
    @comment = build(:comment)
    user = create(:user)
    log_in_as(user)
    ArticlePage.open(id: article.id)
  end

  scenario 'User can add comment with valid comment body', smoke: true do
    comment = @comment
    ArticlePage.on do
      fill_comment_form(body: comment.body)
      submit_form
      expect(text).to include('Comment was successfully added to current article.')
    end
  end

  scenario 'User can not add comment with blank comment body', smoke: true do
    ArticlePage.on do
      fill_comment_form(body: nil)
      submit_form
      expect(text).to include("Body can't be blank")
    end
  end
end
