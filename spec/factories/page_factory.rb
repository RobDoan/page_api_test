FactoryGirl.define do
  factory :page, :class => Page do
    title {Faker::Lorem.sentence}
    content { Faker::Lorem.paragraphs}
  end
end
