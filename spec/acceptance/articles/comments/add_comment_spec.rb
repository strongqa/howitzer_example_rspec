require 'spec_helper'

feature "Adding Comment" do

  attr_accessor :user, :article, :comment
  background "Create article, user, comment" do
    self.article = build(:article).save!
    self.comment = build(:comment)
    self.user = build(:user).save!
    log_in_as(self.user)
    open_article(self.article)
  end

  scenario "User can add comment with valid comment body" do
    ArticlePage.given.fill_comment_form(body: self.comment.body)
    ArticlePage.given.submit_form
    expect(ArticlePage.given.text).to include("Comment was successfully added to current article.")
  end

  scenario "User can not add comment with blank comment body" do
    ArticlePage.given.fill_comment_form(body: nil)
    ArticlePage.given.submit_form
    expect(ArticlePage.given.text).to include("Body can't be blank")
  end
end