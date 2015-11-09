require 'spec_helper'

feature "Article Viewing" do
  background "Create article, comment" do
    @article = create(:article)
    @comment = @article.comments.create(body: "Some comment", user_id: User.where(email: settings.def_test_user).all.first.id)

    log_in_as_admin
    ArticlePage.open(id: @article.id)
  end

  scenario "Admin is viewing article page" do
    expect(ArticlePage.given.text).to include(@article.title)
    expect(ArticlePage.given.text).to include(@article.text)
    expect(ArticlePage.given.text).to include(settings.def_test_user)
    expect(ArticlePage.given.text).to include(@comment.body)
    expect(ArticlePage.given).to be_comment_form_present
    expect(ArticlePage.given).to be_body_field_present
    expect(ArticlePage.given).to be_edit_button_present
    expect(ArticlePage.given).to be_add_comment_button_present
    expect(ArticlePage.given).to be_destroy_comment_link_present(@comment.body)
  end

  scenario "Admin can be redirected from article page back to article list", :p1 => true do
    ArticlePage.given.back_to_article_list
    ArticleListPage.wait_for_opened
  end
end