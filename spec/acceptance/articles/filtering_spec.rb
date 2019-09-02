require 'spec_helper'

RSpec.feature 'Articles filtering by category' do
  background 'Create articles and user' do
    @category = create(:category)
    @article1 = create(:article, category: @category)
    @article2 = create(:article, category: @category)
    user = create(:user)
    log_in_as(user)
  end

  scenario 'User can filter articles by category', smoke: true do
    article1 = @article1
    article2 = @article2
    category = @category
    ArticleListPage.open
    ArticleListPage.on do
      is_expected.to have_category_item_element(category.name)
      open_category_item(category.name)
    end
    CategoriesPage.on do
      is_expected.to have_article_element(article1.title)
      is_expected.to have_article_element(article2.title)
    end
    CategoriesPage.on { main_menu_section.choose_menu('Logout') }
    log_in_as(create(:user, :admin))
    CategoriesListPage.open
    CategoriesListPage.on do
      delete_category(category.name)
      if Howitzer.driver == 'webkit'
        driver.browser.accept_js_confirms
      else
        Capybara.current_session.accept_alert
      end
    end
  end
end
