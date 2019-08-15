require 'spec_helper'

RSpec.feature 'Articles list' do
  background 'Create article and user' do
    @article1 = create(:article)
    @article2 = create(:article)
    user = create(:user)
    log_in_as(user)
  end

  scenario 'User view articles list', smoke: true do
    article1 = @article1
    article2 = @article2
    ArticleListPage.open
    ArticleListPage.on do
      expect(text).to include(article1.title.upcase)
      expect(text).to include(article1.text)
      expect(text).to include(article2.title.upcase)
      expect(text).to include(article2.text)
    end
  end

  scenario 'user can find necessary articles by name in Article list', smoke: true do
    article1 = @article1
    ArticleListPage.open
    ArticleListPage.on { search_article(article1.title) }
    SearchPage.on { is_expected.to have_article_element(article1.title) }
  end

  scenario 'user can see and open recently created articles in right sidebar of Article list', smoke: true do
    article1 = @article1
    ArticleListPage.open
    ArticleListPage.on do
      is_expected.to have_recent_post_element(article1.title)
      open_recent_post(article1.title)
    end
    ArticlePage.on do
      expect(text).to include(article1.title.upcase)
      expect(text).to include(article1.text)
    end
  end
end
