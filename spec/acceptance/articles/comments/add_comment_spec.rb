require 'spec_helper'

feature "Adding Comment" do
  background "Create article, user, comment" do
    @article = Gen.article
    @comment = Gen.comment
    @user = Gen.user

    log_in_as_admin
    create_article(@article)
    logout
    sign_up_as(@user)
    log_in_as(@user)
    open_article(@article)
  end

  scenario "User can add comment with valid comment body" do
    ArticlePage.given.fill_comment_form(body: @comment.text)
    ArticlePage.given.submit_form
    expect(ArticlePage.given.text).to include("Comment was successfully added to current article.")
  end

  scenario "User can not add comment with blank comment body" do
    ArticlePage.given.fill_comment_form(body: nil)
    ArticlePage.given.submit_form
    expect(ArticlePage.given.text).to include("Body can't be blank")
  end
end