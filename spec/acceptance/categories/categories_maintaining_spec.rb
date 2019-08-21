require 'spec_helper'

RSpec.feature 'Category maintaining' do
  background 'Login as admin' do
    @category = build(:category)
    @category1 = create(:category)
    log_in_as(create(:user, :admin))
  end

  scenario 'admin can add new category', smoke: true do
    category = @category
    CategoriesListPage.open
    CategoriesListPage.on { add_new_category }
    NewCategoryPage.on { create_category(category.name) }
    CategoriesListPage.on { is_expected.to have_category_item_element(category.name) }
  end

  scenario 'admin can edit existed category' do
    category1 = @category1
    category_new = "#{@category1.name}_new"
    CategoriesListPage.open
    CategoriesListPage.on { edit_category(category1.name) }
    EditCategoryPage.on { update_category(category_new) }
    CategoriesListPage.on { is_expected.to have_category_item_element(category_new) }
  end

  scenario 'admin can delete existed category' do
    category1 = @category1
    CategoriesListPage.open
    CategoriesListPage.on { delete_category(category1.name) }
    CategoriesListPage.on { is_expected.not_to have_category_item_element(category1.name) }
  end
end
