require 'spec_helper'

RSpec.feature 'Category maintaining' do
  let(:category) { build(:category) }
  let(:category1) { create(:category) }

  background 'Login as admin' do
    Howitzer::Cache.store(:teardown, :category1, category1.id)
    log_in_as(create(:user, :admin))
  end

  scenario 'admin can add new category', smoke: true do
    category_name = category.name
    CategoriesListPage.open
    CategoriesListPage.on { add_new_category }
    NewCategoryPage.on { create_category(category_name) }
    CategoriesListPage.on { expect(self).to have_category_item_element(lambda_args(name: category_name)) }
    CategoriesListPage.on do
      delete_category(category_name)
      Capybara.current_session.accept_alert
    end
    CategoriesListPage.on { expect(self).to have_no_category_item_element(lambda_args(name: category_name)) }
  end

  scenario 'admin can edit existing category' do
    category1_name = category1.name
    category_new = "#{category1_name}_new"
    CategoriesListPage.open
    CategoriesListPage.on { edit_category(category1_name) }
    EditCategoryPage.on { update_category(category_new) }
    CategoriesListPage.on { expect(self).to have_category_item_element(lambda_args(name: category_new)) }
    CategoriesListPage.on do
      delete_category(category_new)
      Capybara.current_session.accept_alert
    end
    CategoriesListPage.on { expect(self).to have_no_category_item_element(lambda_args(name: category_new)) }
  end

  scenario 'admin can delete existing category' do
    category1_name = category1.name
    CategoriesListPage.open
    CategoriesListPage.on do
      delete_category(category1_name)
      Capybara.current_session.accept_alert
    end
    CategoriesListPage.on { expect(self).to have_no_category_item_element(lambda_args(name: category1_name)) }
  end
end
