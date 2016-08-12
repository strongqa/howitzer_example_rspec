require 'spec_helper'

feature 'Destroy comment' do
  background 'Create article, comment' do
    @article = create(:article)
    @comment = @article.comments.create(
      body: 'Some comment',
      user_id: User.where(email: settings.app_test_user).all.first.id
    )
    log_in_as_admin
    ArticlePage.open(id: @article.id)
  end

  scenario 'User can remove comment with confirmation action' do
    comment = @comment
    ArticlePage.on do
      destroy_comment(comment.body, true)
      expect(text).to_not include(comment.body)
    end
  end

  scenario 'User can not remove comment without confirmation action' do
    comment = @comment
    ArticlePage.on do
      destroy_comment(comment.body, false)
      expect(text).to include(comment.body)
    end
  end
end
