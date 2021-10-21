# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  describe '.valid?' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to validate_presence_of(:title) }
  end

  describe '.all' do
    context 'with created 3 post before' do
      let!(:expected) { create_list(:post, 3) }
      subject { described_class.all }

      it { is_expected.to eq(expected) }
      it { expect(subject.count).to eq(3) }
    end
  end

  describe '#save' do
    subject { described_class.new(attributes).save }

    context 'with valid attributes' do
      let(:user) { create(:user) }
      let(:attributes) { attributes_for(:post).merge(user_id: user.id) }

      it { is_expected.to be_truthy }
    end

    context 'without valid attributes' do
      let(:attributes) { attributes_for(:post) }

      it { is_expected.to be_falsey }
    end
  end

  describe '#update' do
    let(:post) { create(:post) }
    subject { post.update(attributes) }

    context 'with user_id nil' do
      let(:attributes) { { user_id: nil } }

      it { is_expected.to be_falsey }
    end

    context 'without user_id existed' do
      let(:attributes) { { user_id: create(:user).id } }

      it { is_expected.to be_truthy }
    end
  end
end
