require 'spec_helper'

feature "Article Editing" do

  attr_accessor :article, :article1

  background "log in as admin" do
    log_in_as_admin
    self.article = build(:article).save!
    open_article(self.article)
  end

  scenario "User can edit article with correct credentials" do
    self.article1 = build(:article)
    ArticlePage.given.click_article_button('Edit')
    EditArticlePage.given.fill_form(title: self.article1.title, text: self.article1.text)
        .submit_form
    expect(ArticlePage.given.text).to include(self.article1.title)
    expect(ArticlePage.given.text).to include(self.article1.text)
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
