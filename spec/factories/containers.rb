FactoryGirl.define do
  factory :container, class: Container do
    sequence(:title, '1') do |n|
      "Chapter #{n}"
    end

    factory :contained_page do
      after(:build) do |work|
        work.ordered_members << FactoryGirl.build(:page)
      end
    end
  end
end
