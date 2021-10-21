# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe 'GET #index' do
    subject { get :index }

    it { is_expected.to have_http_status(:ok) }
    it { is_expected.to render_template(:index) }
    it 'to return empty posts collection' do
      subject
      expect(assigns(:posts)).to match([])
    end

    context 'with posts' do
      let(:posts) { build_list(:post, 5) }

      before do
        allow(Post).to receive(:all).and_return(posts)
        get :index
      end

      it 'to return posts collection' do
        expect(assigns(:posts)).to match(posts)
      end
    end

    context 'with posts 2' do
      let!(:posts) { create_list(:post, 3) }
      before do
        get :index
      end

      it 'to return posts collection' do
        expect(assigns(:posts)).to match(posts)
      end
    end
  end

  describe 'GET #index with shared examples' do
    it_behaves_like 'controller index action', 'post'
  end

  describe 'GET #show' do
    let(:post) { create(:post) }
    subject { get :show, params: { id: post.id } }

    it { is_expected.to have_http_status(:ok) }
    it { is_expected.to render_template(:show) }
    it 'is expected to assigns post' do
      subject
      expect(assigns(:post)).to eq(post)
    end

    context 'with mock post' do
      let(:post) { build(:post) }
      before do
        allow(Post).to receive(:find).and_return(post)
        get :show, params: { id: 1 }
      end

      it { expect(assigns(:post)).to eq(post) }
    end
  end

  describe 'POST #create' do
    context 'without post required params' do
      subject { post :create }

      it 'is expected to raise ActionController::ParameterMissing error' do
        expect { subject }.to raise_error(ActionController::ParameterMissing)
      end
    end

    context 'with post required params' do
      context 'when params valid' do
        let(:user) { create(:user) }
        let(:attributes) { attributes_for(:post).merge(user_id: user.id) }
        subject { post :create, params: { post: attributes } }

        it { is_expected.to have_http_status(:found) }
        it { is_expected.to redirect_to(assigns(:post)) }
        it { is_expected.to_not render_template(:new) }

        it 'is expected to create new post' do
          expect { subject }.to change { Post.count }.from(0).to(1)
        end
      end

      context 'when params are invalid' do
        let(:attributes) { attributes_for(:post) }
        subject { post :create, params: { post: attributes } }

        it { is_expected.to have_http_status(:unprocessable_entity) }
        it { is_expected.to_not redirect_to(assigns(:post)) }
        it { is_expected.to render_template(:new) }

        it 'is expected to dont create new post' do
          expect { subject }.to change { Post.count }.by(0)
        end
      end
    end
  end

  describe 'POST #create second WAY' do
    context 'without post required params' do
      subject { post :create }

      it 'is expected to raise ActionController::ParameterMissing error' do
        expect { subject }.to raise_error(ActionController::ParameterMissing)
      end
    end

    context 'with post required params' do
      context 'when params valid' do
        before { allow_any_instance_of(Post).to receive(:save).and_return(true) }
        subject { post :create, params: { post: attributes } }
        let(:attributes) { attributes_for(:post) }

        it { is_expected.to have_http_status(:found) }
        it { is_expected.to redirect_to(assigns(:post)) }
        it { is_expected.to_not render_template(:new) }
      end

      context 'when params are invalid' do
        before { allow_any_instance_of(Post).to receive(:save).and_return(false) }
        subject { post :create, params: { post: attributes } }
        let(:attributes) { attributes_for(:post) }

        it { is_expected.to have_http_status(:unprocessable_entity) }
        it { is_expected.to_not redirect_to(assigns(:post)) }
        it { is_expected.to render_template(:new) }
      end
    end
  end

  describe 'PUT #update' do
    context 'with post required params' do
      let(:post) { create(:post, title: 'old') }

      context 'when params valid' do
        let(:post_attributes) { { title: 'new' } }
        subject { put :update, params: { id: post.id, post: post_attributes } }

        it { is_expected.to have_http_status(:found) }
        it { is_expected.to redirect_to(assigns(:post)) }
        it { is_expected.to_not render_template(:edit) }

        it 'is expected to update title' do
          expect { subject }.to change { post.reload.title }.from('old').to('new')
        end
      end

      context 'when params are invalid' do
        let(:post_attributes) { { user_id: nil } }
        subject { put :update, params: { id: post.id, post: post_attributes } }

        it { is_expected.to have_http_status(:unprocessable_entity) }
        it { is_expected.to_not redirect_to(assigns(:post)) }
        it { is_expected.to render_template(:edit) }

        it 'is expected to dont update user_id' do
          subject

          expect(post.reload).to_not eq(nil)
        end
      end
    end
  end

  describe 'PUT #update second way' do
    let(:post) { build(:post) }

    context 'with post required params' do
      context 'when params valid' do
        before do
          allow(Post).to receive(:find).and_return(post)
          allow(post).to receive(:update).and_return(true)
        end
        subject { put :update, params: { id: 1, post: attributes } }

        let(:attributes) { attributes_for(:post) }

        it { is_expected.to have_http_status(:found) }
        it { is_expected.to redirect_to(assigns(:post)) }
        it { is_expected.to_not render_template(:edit) }
      end

      context 'when params are invalid' do
        before do
          allow(Post).to receive(:find).and_return(post)
          allow(post).to receive(:update).and_return(false)
        end
        subject { put :update, params: { id: 1, post: attributes } }

        let(:attributes) { attributes_for(:post) }

        it { is_expected.to have_http_status(:unprocessable_entity) }
        it { is_expected.to_not redirect_to(assigns(:post)) }
        it { is_expected.to render_template(:edit) }
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:post) { create(:post) }
    subject { delete :destroy, params: { id: post.id } }

    it { is_expected.to have_http_status(:found) }
    it { is_expected.to render_template(nil) }
  end

  describe 'DELETE #destroy second WAY' do
    context 'when destroy failed' do
      subject { delete :destroy, params: { id: 1 } }
      let(:post) { build(:post) }

      before do
        allow(post).to receive(:destroy).and_return(false)
        allow(Post).to receive(:find).and_return(post)
      end

      it { is_expected.to have_http_status(:found) }
      it { is_expected.to render_template(nil) }
      it { is_expected.to redirect_to(action: :index) }
    end

    context 'when destroy success' do
      subject { delete :destroy, params: { id: 1 } }
      let(:post) { build(:post) }

      before do
        allow(post).to receive(:destroy).and_return(false)
        allow(Post).to receive(:find).and_return(post)
      end

      it { is_expected.to have_http_status(:found) }
      it { is_expected.to render_template(nil) }
      it { is_expected.to redirect_to(post) }
    end
  end
end
