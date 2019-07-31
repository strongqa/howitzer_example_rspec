require 'spec_helper'
RSpec.feature 'Home' do
  scenario 'visitor can see home page of web application', smoke: true do
    log_in_as(create(:user, :admin))

    ArticleListPage.open.add_new_article

    article = build(:article)
    NewArticlePage.on do
      fill_form(title: article.title, text: article.text)
      submit_form
    end
    HomePage.open
    HomePage.on { expect(find_article_group_text(1)).to include(article.title.upcase) }
  end

  scenario 'visitor can see howitzer banner', exception: true, smoke: true do
    HomePage.open
    HomePage.on do
      current_window.resize_to(1920, 1080)
      howitzer_home_iframe do |frame|
        frame.open_quick_start
        expect(frame).to have_install_section_element(visible: true)
      end
    end
  end
end
