# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    user { User.first || association(:user) }
    title { 'test' }
    text { 'test' }

    trait :published do
      published_at { Time.current }
    end
  end
end
