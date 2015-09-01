FactoryGirl.define do
  factory :article do
    title { "Article title #{Gen.serial}"}
    text { 'Test text' }
  end
end
