require 'spec_helper'
feature 'Home' do
  background 'creating article' do
    log_in_as_admin
    ArticleListPage.open.add_new_article
  end

  scenario 'visitor can see home page of web application' do
    article = build(:article)
    NewArticlePage.on do
      fill_form(title: article.title, text: article.text)
      submit_form
    end
    HomePage.open
    HomePage.on { expect(find_form_text('Today')).to include(article.title) }
  end
end
