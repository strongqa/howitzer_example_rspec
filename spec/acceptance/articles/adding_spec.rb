require 'spec_helper'

feature "Article adding" do

  before(:each) do
    log_in_as_admin
    ArticleListPage.open.add_new_article
  end

  scenario "User can add article with correct data" do
    article=Gen::article
    NewArticlePage.given.fill_form(title: article.title, text: article.text)
        .submit_form
    expect(ArticlePage.given.text).to include(article.title)
    expect(ArticlePage.given.text).to include(article.text)
  end

  scenario "User can not add article with blank field" do
    NewArticlePage.given
        .fill_form
        .submit_form
    expect(NewArticlePage.given.text).to include("2 errors prohibited this article from being saved: Title can't be blank Title is too short (minimum is 5 characters)")
  end

  scenario "User can not add article with title is too short" do
    article=Gen::article
    NewArticlePage.given.fill_form(title: "1234", text: article.text)
        .submit_form
    expect(NewArticlePage.given.text).to include("1 error prohibited this article from being saved: Title is too short (minimum is 5 characters)")
  end

end





