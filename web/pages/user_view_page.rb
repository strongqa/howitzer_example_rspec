require_relative 'main_menu'

class UserViewPage < Howitzer::Web::Page
  url '/users'
  validate :title, /\ADemo web application - User\z/

  include MainMenu

end
