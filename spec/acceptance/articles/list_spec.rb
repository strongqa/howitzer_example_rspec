require 'spec_helper'

feature "Articles list" do

  attr_accessor :user, :article1,:article2

  background "Create article and user" do
    self.article1 = build(:article).save!
    self.article2 = build(:article).save!
    self.user = build(:user).save!
    log_in_as(self.user)
  end

  scenario "User view articles list" do
    ArticleListPage.open
    expect(ArticleListPage.given.text).to include(self.article1.title)
    expect(ArticleListPage.given.text).to include(self.article1.text)
    expect(ArticleListPage.given.text).to include(self.article2.title)
    expect(ArticleListPage.given.text).to include(self.article2.text)
  end
end