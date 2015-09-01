require_relative 'main_menu'

class UserViewPage < WebPage
  URL = '/users'
  validates :title, pattern: /\ADemo web application - User\z/

  include MainMenu

end