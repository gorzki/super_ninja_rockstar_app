# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Statistics::UserPostsService, type: :model do
  let(:user) { create(:user) }

  describe '.posts_statistic' do
    subject { described_class.new(user).posts_statistic }

    context 'when user dont have posts' do
      it { is_expected.to have_attributes(total_count: 0, published_count: 0) }
    end

    context 'when user have posts' do
      before do
        create_list(:post, 3, user: user)
        create_list(:post, 2, :published, user: user)
      end

      it { is_expected.to have_attributes(total_count: 5, published_count: 2) }
    end
  end
end
