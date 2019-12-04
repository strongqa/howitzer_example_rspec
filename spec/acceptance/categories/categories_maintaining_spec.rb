require 'spec_helper'

RSpec.feature 'Category maintaining' do
  background 'Login as admin' do
    @category = build(:category)
    @category1 = create(:category)
    Howitzer::Cache.store(:teardown, :category1, @category1.id)
    log_in_as(create(:user, :admin))
  end

  scenario 'admin can add new category', smoke: true do
    category = @category
    CategoriesListPage.open
    CategoriesListPage.on { add_new_category }
    NewCategoryPage.on { create_category(category.name) }
    CategoriesListPage.on { is_expected.to have_category_item_element(category.name) }
    CategoriesListPage.on do
      delete_category(category.name)
      if Howitzer.driver == 'webkit'
        driver.browser.accept_js_confirms
      else
        Capybara.current_session.accept_alert
      end
    end
    CategoriesListPage.on { is_expected.to have_no_category_item_element(category.name) }
  end

  scenario 'admin can edit existing category' do
    category1 = @category1
    category_new = "#{@category1.name}_new"
    CategoriesListPage.open
    CategoriesListPage.on { edit_category(category1.name) }
    EditCategoryPage.on { update_category(category_new) }
    CategoriesListPage.on { is_expected.to have_category_item_element(category_new) }
    CategoriesListPage.on do
      delete_category(category_new)
      if Howitzer.driver == 'webkit'
        driver.browser.accept_js_confirms
      else
        Capybara.current_session.accept_alert
      end
    end
    CategoriesListPage.on { is_expected.to have_no_category_item_element(category_new) }
  end

  scenario 'admin can delete existing category' do
    category1 = @category1
    CategoriesListPage.open
    CategoriesListPage.on do
      delete_category(category1.name)
      if Howitzer.driver == 'webkit'
        driver.browser.accept_js_confirms
      else
        Capybara.current_session.accept_alert
      end
    end
    CategoriesListPage.on { is_expected.to have_no_category_item_element(category1.name) }
  end
end
