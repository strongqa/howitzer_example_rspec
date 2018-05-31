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
end
