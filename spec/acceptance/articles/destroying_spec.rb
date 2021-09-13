require 'spec_helper'

RSpec.feature 'Article destroying' do
  before(:each) do
    log_in_as(create(:user, :admin))
    @article = create(:article, category: create(:category, :default))
    Howitzer::Cache.store(:teardown, :article, @article.id)
    ArticleListPage.open
  end

  scenario 'User can remove article with confirmation action', smoke: true do
    article = @article
    ArticleListPage.on do
      destroy_article(article.title, confirmation: true)
      is_expected.to have_no_article_item_element(lambda_args(title: article.title))
    end
  end

  scenario 'User can not remove article without confirmation action' do
    article = @article
    ArticleListPage.on do
      destroy_article(article.title, confirmation: false)
      is_expected.to have_article_item_element(lambda_args(title: article.title))
    end
  end
end
