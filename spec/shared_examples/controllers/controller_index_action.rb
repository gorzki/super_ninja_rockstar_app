RSpec.shared_examples 'controller index action' do |model_name, collection_value = nil|
  let(:assigns_value) { collection_value || model_name.pluralize }

  subject { get :index }

  it { is_expected.to have_http_status(:ok) }
  it { is_expected.to render_template(:index) }
  it 'to return empty posts collection' do
    subject
    expect(assigns(assigns_value)).to match([])
  end

  context 'with created collection' do
    let(:collection) { create_list(model_name, 3) }

    it 'to return empty posts collection' do
      subject
      expect(assigns(assigns_value)).to match(collection)
    end
  end
end
