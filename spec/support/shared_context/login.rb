RSpec.shared_context 'with logged user' do
  let(:user) { create(:user) }
  before { sign_in user }
end
