FactoryGirl.define do
  factory :comment do
    body { "Comment #{Gen.serial}" }
  end
end