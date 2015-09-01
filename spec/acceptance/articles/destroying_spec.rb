require 'spec_helper'

feature "Article destroying" do

  attr_accessor :article

  before(:each) do
    log_in_as_admin
    self.article = build(:article).save!
    ArticleListPage.open
  end

  scenario "User can remove article with confirmation action" do
    ArticleListPage.given.destroy_article(self.article.title, true)
    expect(ArticleListPage.given.text).to_not include(self.article.title)
  end

  scenario "User can not remove article without confirmation action" do
    ArticleListPage.given.destroy_article(self.article.title, false)
    expect(ArticleListPage.given.text).to include(self.article.title)
  end

end