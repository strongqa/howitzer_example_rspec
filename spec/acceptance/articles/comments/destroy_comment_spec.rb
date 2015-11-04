require 'spec_helper'

feature "Destroy comment" do
  background "Create article, comment" do
     @article = create(:article)
     @comment = @article.comments.create(body: "Some comment", user_id: User.where(email: settings.def_test_user).all.first.id)

    log_in_as_admin
     ArticlePage.open(id: @article.id)
  end

  scenario "User can remove comment with confirmation action" do
    ArticlePage.given.destroy_comment(@comment.body, true)
    expect(ArticlePage.given.text).to_not include(@comment.body)
  end

  scenario "User can not remove comment without confirmation action" do
    ArticlePage.given.destroy_comment(@comment.body, false)
    expect(ArticlePage.given.text).to include(@comment.body)
  end
end
