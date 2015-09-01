require 'spec_helper'

feature "Article destroying" do

  before(:each) do
    log_in_as_admin
    ArticleListPage.open.add_new_article
    @article=Gen::article
    NewArticlePage.given.fill_form(title: @article.title, text: @article.text)
        .submit_form
    ArticleListPage.open
  end

  scenario "User can remove article with confirmation action" do
    ArticleListPage.given.destroy_article(@article.title, true)
    expect(ArticleListPage.given.text).to_not include(@article.title)
  end

  scenario "User can not remove article without confirmation action" do
    ArticleListPage.given.destroy_article(@article.title, false)
    expect(ArticleListPage.given.text).to include(@article.title)
  end

end