FactoryGirl.define do
  factory :comment do
    body { "Comment #{Gen.serial}" }
    user_id { create(:user).id }
    _article_id { create(:article).id }
  end
end