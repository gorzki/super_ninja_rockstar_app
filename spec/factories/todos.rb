# frozen_string_literal: true

FactoryBot.define do
  factory :todo do
    traits_for_enum :occupancy, Todo.statuses.keys

    user        { User.first || association(:user) }
    title       { 'todo' }
    description { 'description' }
    deadline    { Date.tomorrow }

    trait :old do
      deadline { Date.yesterday }
    end
  end
end
