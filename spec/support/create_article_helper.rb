module CreateArticleHelper
  def create_article(article)
    NewArticlePage.open
    NewArticlePage.on do
      fill_form(title: article.title, text: article.text)
      submit_form
    end
    ArticlePage.on do
      expect(text).to include(article.title)
      expect(text).to include(article.text)
    end
  end

  def logout
    ArticlePage.on do
      main_menu_section
      choose_menu('Logout')
    end
  end

  def open_article(article)
    ArticleListPage.open
    ArticleListPage.on { open_article(article.title) }
    expect(ArticlePage).to be_authenticated
    expect(ArticlePage).to be_displayed
  end
end

RSpec.configure do |config|
  config.include CreateArticleHelper
end
