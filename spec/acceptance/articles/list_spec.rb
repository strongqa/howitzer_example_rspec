require 'spec_helper'

RSpec.feature 'Articles list' do
  let(:article1) { create(:article, category: create(:category, :default)) }
  let(:article2) { create(:article, category: create(:category, :default)) }

  background 'Create article and user' do
    Howitzer::Cache.store(:teardown, :article1, article1.id)
    Howitzer::Cache.store(:teardown, :article2, article2.id)
    user = create(:user)
    log_in_as(user)
  end

  scenario 'User view articles list', smoke: true do
    article1_obj = article1
    article2_obj = article2
    ArticleListPage.open
    ArticleListPage.on do
      expect(text).to include(article1_obj.title.upcase)
      expect(text).to include(article1_obj.text)
      expect(text).to include(article2_obj.title.upcase)
      expect(text).to include(article2_obj.text)
    end
  end

  scenario 'User can find necessary articles by name in article list', smoke: true do
    article1_title = article1.title
    ArticleListPage.open
    ArticleListPage.on { search_article(article1_title) }
    SearchPage.on { expect(self).to have_article_element(lambda_args(name: article1_title)) }
  end

  scenario 'User can see and open recently created articles in right sidebar of article list', smoke: true, wip: true do
    article1_obj = article1
    ArticleListPage.open
    ArticleListPage.on do
      expect(self).to have_recent_post_element(lambda_args(name: article1_obj.title))
      open_recent_post(article1_obj.title)
    end
    ArticlePage.on do
      expect(text).to include(article1_obj.title.upcase)
      expect(text).to include(article1_obj.text)
    end
  end
end
