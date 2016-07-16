module CreateArticleHelper
  def create_article(article)
    NewArticlePage.open.fill_form(title: article.title, text: article.text)
        .submit_form
    expect(ArticlePage.given.text).to include(article.title)
    expect(ArticlePage.given.text).to include(article.text)
  end

  def logout
    ArticlePage.given.main_menu_section.choose_menu('Logout')
  end

  def open_article(article)
    ArticleListPage.open.open_article(article.title)
    expect(ArticlePage).to be_authenticated
    expect(ArticlePage).to be_displayed
  end
end

RSpec.configure do |config|
  config.include CreateArticleHelper
end