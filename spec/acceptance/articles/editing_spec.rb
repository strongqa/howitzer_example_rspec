require 'spec_helper'

RSpec.feature 'Article Editing' do
  background 'log in as admin' do
    log_in_as(create(:user, :admin))
    article = create(:article)
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
      expect(errors_section.error_message).to eql(
        '2 errors prohibited this article from being saved:' \
        " Title can't be blank Title is too short (minimum is 5 characters)"
      )
    end
  end

  scenario 'User can not edit article with title is too short' do
    ArticlePage.on { click_article_button('Edit') }
    EditArticlePage.on do
      fill_form(title: '1234', text: '')
      submit_form
      expect(errors_section.error_message).to eql(
        '1 error prohibited this article from being saved: Title is too short (minimum is 5 characters)'
      )
    end
  end
end
