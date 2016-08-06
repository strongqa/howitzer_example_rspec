require 'spec_helper'

feature 'Article destroying' do
  before(:each) do
    log_in_as_admin
    @article = create(:article)
    ArticleListPage.open
  end

  scenario 'User can remove article with confirmation action' do
    article = @article
    ArticleListPage.on do
      destroy_article(article.title, true)
      expect(text).to_not include(article.title)
    end
  end

  scenario 'User can not remove article without confirmation action' do
    article = @article
    ArticleListPage.on do
      destroy_article(article.title, false)
      expect(text).to include(article.title)
    end
  end
end
