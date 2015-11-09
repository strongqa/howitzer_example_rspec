require 'spec_helper'

feature "Articles list" do

  background "Create article and user" do
    @article1 = build(:article).save!
    @article2 = build(:article).save!
    user = build(:user).save!
    log_in_as(user)
  end

  scenario "User view articles list", :smoke => true do
    ArticleListPage.open
    expect(ArticleListPage.given.text).to include(@article1.title)
    expect(ArticleListPage.given.text).to include(@article1.text)
    expect(ArticleListPage.given.text).to include(@article2.title)
    expect(ArticleListPage.given.text).to include(@article2.text)
  end
end