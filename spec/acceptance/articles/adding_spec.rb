require 'spec_helper'

RSpec.feature 'Article adding' do
  before(:each) do
    log_in_as(create(:user, :admin))
    ArticleListPage.open
    ArticleListPage.on { add_new_article }
  end

  scenario 'User can add article with correct data', smoke: true do
    article = build(:article)
    NewArticlePage.on do
      fill_form(title: article.title, text: article.text)
      submit_form
    end
    ArticlePage.on do
      expect(text).to include(article.title)
      expect(text).to include(article.text)
    end
  end

  scenario 'User can not add article with blank field' do
    NewArticlePage.on do
      fill_form
      submit_form
      expect(text.gsub("\n", ' ').downcase).to include(
        "1 error prohibited this article from being saved: title can't be blank"
      )
    end
  end

  scenario 'User can not add article with title is too short' do
    article = build(:article)
    NewArticlePage.on do
      fill_form(title: '1234', text: article.text)
      submit_form
      expect(text.gsub("\n", ' ').downcase).to include(
        '1 error prohibited this article from being saved: Title is too short (minimum is 5 characters)'.downcase
      )
    end
  end
end
