require 'spec_helper'
feature 'Home' do
  scenario 'visitor can see home page of web application' do
    log_in_as(create(:user, :admin))

    ArticleListPage.open.add_new_article

    article = build(:article)
    NewArticlePage.on do
      fill_form(title: article.title, text: article.text)
      submit_form
    end
    HomePage.open
    HomePage.on { expect(find_form_text('Today')).to include(article.title) }
  end

  scenario 'visitor can see howitzer banner' do
    HomePage.open
    HomePage.on do
      howitzer_home_iframe do |frame|
        frame.open_quick_start
        expect(frame).to have_install_section_element(visible: true)
      end
    end
  end
end
