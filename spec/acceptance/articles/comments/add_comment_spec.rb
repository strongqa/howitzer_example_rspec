require 'spec_helper'

feature "Adding Comment" do

  background "Create article, user, comment" do
    article = build(:article).save!
    @comment = build(:comment)
    user = build(:user).save!
    log_in_as(user)
    ArticlePage.open(id: article.id)
  end

  scenario "User can add comment with valid comment body" do
    ArticlePage.given.fill_comment_form(body: @comment.body)
    ArticlePage.given.submit_form
    expect(ArticlePage.given.text).to include("Comment was successfully added to current article.")
  end

  scenario "User can not add comment with blank comment body" do
    ArticlePage.given.fill_comment_form(body: nil)
    ArticlePage.given.submit_form
    expect(ArticlePage.given.text).to include("Body can't be blank")
  end
end