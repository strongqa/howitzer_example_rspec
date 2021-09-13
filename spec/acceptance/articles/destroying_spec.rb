require 'spec_helper'

RSpec.feature 'Article destroying' do
  let(:article) { create(:article, category: create(:category, :default)) }

  background 'Create user' do
    log_in_as(create(:user, :admin))

    Howitzer::Cache.store(:teardown, :article, article.id)
    ArticleListPage.open
  end

  scenario 'User can remove article with confirmation action', smoke: true do
    article_title = article.title
    ArticleListPage.on do
      destroy_article(article_title, confirmation: true)
      expect(self).to have_no_article_item_element(lambda_args(title: article_title))
    end
  end

  scenario 'User can not remove article without confirmation action' do
    article_title = article.title
    ArticleListPage.on do
      destroy_article(article_title, confirmation: false)
      expect(self).to have_article_item_element(lambda_args(title: article_title))
    end
  end
end
