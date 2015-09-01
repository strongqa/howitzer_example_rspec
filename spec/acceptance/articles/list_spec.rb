require 'spec_helper'

feature "Articles list" do
  background "Create article and user" do
    @article1 = Gen.article
    @article2 = Gen.article
    @user1 = Gen.user

    log_in_as_admin
    create_article(@article1)
    create_article(@article2)
    logout
    sign_up_as(@user1)
    log_in_as(@user1)
  end

  scenario "User view articles list" do
    ArticleListPage.open
    expect(ArticleListPage.given.text).to include(@article1.title)
    expect(ArticleListPage.given.text).to include(@article1.text)
    expect(ArticleListPage.given.text).to include(@article2.title)
    expect(ArticleListPage.given.text).to include(@article2.text)
  end
end