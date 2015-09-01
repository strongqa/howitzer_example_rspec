require 'spec_helper'

feature "Article adding" do

  attr_accessor :article

  before(:each) do
    log_in_as_admin
    ArticleListPage.open.add_new_article
  end

  scenario "User can add article with correct data" do
    self.article = build(:article)
    NewArticlePage.given.fill_form(title: self.article.title, text: self.article.text)
        .submit_form
    expect(ArticlePage.given.text).to include(self.article.title)
    expect(ArticlePage.given.text).to include(self.article.text)
  end

  scenario "User can not add article with blank field" do
    NewArticlePage.given
        .fill_form
        .submit_form
    expect(NewArticlePage.given.text).to include("2 errors prohibited this article from being saved: Title can't be blank Title is too short (minimum is 5 characters)")
  end

  scenario "User can not add article with title is too short" do
    self.article = build(:article)
    NewArticlePage.given.fill_form(title: "1234", text: self.article.text)
        .submit_form
    expect(NewArticlePage.given.text).to include("1 error prohibited this article from being saved: Title is too short (minimum is 5 characters)")
  end

end





