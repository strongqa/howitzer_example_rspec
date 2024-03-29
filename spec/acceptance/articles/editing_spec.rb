require 'spec_helper'

RSpec.feature 'Article Editing' do
  let(:article) { create(:article, category: create(:category, :default)) }

  background 'log in as admin' do
    log_in_as(create(:user, :admin))

    Howitzer::Cache.store(:teardown, :article, article.id)
    ArticlePage.open(id: article.id)
  end

  scenario 'User can edit article with correct credentials', smoke: true do
    article1 = build(:article)
    ArticlePage.on { click_article_button('Edit') }
    EditArticlePage.on do
      fill_form(title: article1.title, text: article1.text)
      submit_form
    end
    ArticlePage.on do
      expect(text).to include(article1.title)
      expect(text).to include(article1.text)
    end
  end

  scenario 'User can not edit article with blank title' do
    ArticlePage.on { click_article_button('Edit') }
    EditArticlePage.on do
      fill_form(title: '', text: '')
      submit_form
      expect(article_errors_section.error_message.downcase).to eql(
        '1 error prohibited this article from being saved: title can\'t be blank'
      )
    end
  end

  scenario 'User can not edit article with title is too short' do
    ArticlePage.on { click_article_button('Edit') }
    EditArticlePage.on do
      fill_form(title: '1234', text: '')
      submit_form
      expect(article_errors_section.error_message.downcase).to eql(
        '1 error prohibited this article from being saved: Title is too short (minimum is 5 characters)'.downcase
      )
    end
  end
end
