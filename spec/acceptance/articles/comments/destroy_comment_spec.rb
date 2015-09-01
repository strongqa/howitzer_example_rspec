require 'spec_helper'

feature "Destroy comment" do
  background "Create article, comment" do
    @article = Gen.article
    @comment = Gen.comment

    log_in_as_admin
    create_article(@article)
    open_article(@article)
    ArticlePage.given.fill_comment_form(body: @comment.text)
    ArticlePage.given.submit_form
  end

  scenario "User can remove comment with confirmation action" do
    ArticlePage.given.destroy_comment(@comment.text, true)
    expect(ArticlePage.given.text).to_not include(@comment.text)
  end

  scenario "User can not remove comment without confirmation action" do
    ArticlePage.given.destroy_comment(@comment.text, false)
    expect(ArticlePage.given.text).to include(@comment.text)
  end
end
