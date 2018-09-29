describe ApplicationController do
  describe '#home' do
    before(:each) do
      get :home
    end

    it 'returns a 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns an empty hash' do
      expect(response.body).to eq({}.to_json)
    end
  end

  describe '#ping' do
    let(:token)    { ENV['PING_TOKEN'] }
    let(:api_mock) { nil }

    before(:each) do
      api_mock
      put :ping, params: {token: token}
    end

    context 'wrong token' do
      let(:token) { 'wrong_token' }

      it 'returns a 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a blank body' do
        expect(response.body).to be_blank
      end
    end

    context 'good token' do
      let(:cloudflare_response) { {success: true} }
      let(:api_mock) { ApiMock.cloudflare(cloudflare_response) }

      it 'returns a 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'forward the cloudflare response' do
        expect(response.body).to eq(cloudflare_response.to_json)
      end
    end
  end
end
