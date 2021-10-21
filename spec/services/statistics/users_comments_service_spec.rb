# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Statistics::UsersCommentsService, type: :model do
  let(:user) { create(:user) }

  describe '.comments_statistic' do
    subject { described_class.new(user).posts_statistic }

    xit 'create tests like Statistics::UserPostsService' do
    end
  end
end
