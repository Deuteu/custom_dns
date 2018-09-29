shared_examples :response_ok do
  it 'returns a 200' do
    expect(response).to have_http_status(:ok)
  end
end
