require 'spec_helper'

RSpec.feature 'Articles filtering by category' do
  let(:category) { create(:category) }
  let(:article1) { create(:article, category: category) }
  let(:article2) { create(:article, category: category) }

  background 'Create articles and user' do
    Howitzer::Cache.store(:teardown, :category, category.id)
    user = create(:user)
    log_in_as(user)
  end

  scenario 'User can filter articles by category', smoke: true do
    article1_title = article1.title
    article2_title = article2.title
    category_name = category.name
    ArticleListPage.open
    ArticleListPage.on do
      expect(self).to have_category_item_element(lambda_args(name: category_name))
      open_category_item(category_name)
    end
    CategoriesPage.on do
      expect(self).to have_article_element(lambda_args(name: article1_title))
      expect(self).to have_article_element(lambda_args(name: article2_title))
    end
    CategoriesPage.on { main_menu_section.choose_menu('Logout') }
    log_in_as(create(:user, :admin))
    CategoriesListPage.open
    CategoriesListPage.on do
      delete_category(category_name)
      Capybara.current_session.accept_alert
    end
  end
end
