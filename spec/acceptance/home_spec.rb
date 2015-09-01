require 'spec_helper'
feature "Home" do
  attr_accessor :article
  background "creating article" do
    log_in_as_admin
    ArticleListPage.open.add_new_article
  end

  scenario "visitor can see home page of web application" do
    self.article=build(:article)
    NewArticlePage.given.fill_form(title: self.article.title, text: self.article.text)
        .submit_form
    HomePage.open
    expect(HomePage.given.find_form_text('Today')).to include(self.article.title)
  end

end