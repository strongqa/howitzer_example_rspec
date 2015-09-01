require 'spec_helper'

feature "Article Editing" do
  background "log in as admin" do
    log_in_as_admin
    ArticleListPage.open.add_new_article
    @article = Gen::article
    NewArticlePage.given.fill_form(title: @article.title, text: @article.text)
        .submit_form
  end

  scenario "User can edit article with correct credentials" do
    article1 = Gen::article
    ArticlePage.given.click_article_button('Edit')
    EditArticlePage.given.fill_form(title: article1.title, text: article1.text)
        .submit_form
    expect(ArticlePage.given.text).to include(article1.title)
    expect(ArticlePage.given.text).to include(article1.text)
  end

  scenario "User can not edit article with blank title" do
    ArticlePage.given.click_article_button('Edit')
    EditArticlePage.given.fill_form(title: '', text: '')
        .submit_form
    expect(EditArticlePage.given.error_message).to eql("2 errors prohibited this article from being saved: Title can't be blank Title is too short (minimum is 5 characters)")
  end

  scenario "User can not edit article with title is too short" do
    ArticlePage.given.click_article_button('Edit')
    EditArticlePage.given.fill_form(title: '1234', text: '')
        .submit_form
    expect(EditArticlePage.given.error_message).to eql("1 error prohibited this article from being saved: Title is too short (minimum is 5 characters)")
  end

end
