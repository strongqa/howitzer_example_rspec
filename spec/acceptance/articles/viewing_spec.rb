require 'spec_helper'

feature "Article Viewing" do
  background "Create article, comment" do
    @article = Gen.article
    @comment = Gen.comment

    log_in_as_admin
    create_article(@article)
    open_article(@article)
    ArticlePage.given.fill_comment_form(body: @comment.text)
    ArticlePage.given.submit_form
  end

  scenario "Admin is viewing article page" do
    expect(ArticlePage.given.text).to include(@article.title)
    expect(ArticlePage.given.text).to include(@article.text)
    expect(ArticlePage.given.text).to include(settings.def_test_user)
    expect(ArticlePage.given.text).to include(@comment.text)
    expect(ArticlePage.given).to be_comment_form_present
    expect(ArticlePage.given).to be_body_field_present
    expect(ArticlePage.given).to be_edit_button_present
    expect(ArticlePage.given).to be_add_comment_button_present
    expect(ArticlePage.given).to be_destroy_comment_link_present
  end

  scenario "Admin can be redirected from article page back to article list" do
    ArticlePage.given.back_to_article_list
    expect(ArticleListPage).to be_authenticated
  end
end