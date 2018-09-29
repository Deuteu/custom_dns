describe TelegramController do
  describe '#webhook' do
    let(:telegram_client) { TelegramAPI.new('') }
    let(:webhook_token)   { 'telegram_webhook_token' }
    let(:command_answer)  { 'Some command result' }
    let(:api_mock)        { nil }
    let(:token)           { Telegram.webhook_token }
    let(:message)         { nil }
    let(:request)         { post :webhook, params: {token: token, message: message}, as: :json }
    let(:catch_request)   { false }

    before(:each) do
      allow(Telegram).to        receive(:client).and_return(telegram_client)
      allow(Telegram).to        receive(:webhook_token).and_return(webhook_token)
      allow(TelegramCommand).to receive(:exec).and_return(command_answer)
      api_mock
      request unless catch_request
    end

    shared_examples :telegram_webhook_response do
      it 'returns a 200' do
        request
        expect(response).to have_http_status(:ok)
      end

      it 'with an empty hash' do
        request
        expect(response.body).to eq({}.to_json)
      end
    end

    context 'providing wrong token' do
      let(:token) { 'wrong_token' }

      include_examples :response_ok

      it 'with a blank body' do
        expect(response.body).to be_blank
      end
    end

    context 'providing good token' do
      context 'without message' do
        include_examples :telegram_webhook_response
      end

      context 'with message' do
        let(:chat) { nil }
        let(:from) { nil }
        let(:text) { nil }

        let(:message) { {chat: chat, from: from, text: text} }

        context 'with no chat' do
          include_examples :telegram_webhook_response
        end

        context 'with a chat without id' do
          let(:chat) { {} }

          include_examples :telegram_webhook_response
        end

        context 'with a chat id' do
          let(:chat) { {id: 1} }

          context 'and no from' do
            let(:catch_request) { true }

            it 'raises a missing method' do
              expect { request }.to raise_error(NoMethodError)
            end
          end

          context 'and a non admin from' do
            let(:from) { {} }

            let(:catch_request) { true }
            let(:api_mock)      { ApiMock.telegram_client }

            include_examples :telegram_webhook_response

            it 'and send a rejecting message' do
              expect(telegram_client).to receive(:sendMessage).exactly(1).times.with(chat[:id], TelegramController::NOT_ADMIN_MESSAGE)
              request
            end
          end

          context 'and an admin from' do
            let(:from) { {id: Telegram.super_admin_id} }

            context 'and no text' do
              include_examples :telegram_webhook_response
            end

            context 'and a text' do
              let(:text) { 'Some text' }

              let(:catch_request) { true }
              let(:api_mock)      { ApiMock.telegram_client }

              include_examples :telegram_webhook_response

              it 'and send a command result message' do
                expect(TelegramCommand).to receive(:exec).exactly(1).times.with(text.split(' '))
                expect(telegram_client).to receive(:sendMessage).exactly(1).times.with(chat[:id], command_answer)
                request
              end
            end
          end
        end
      end
    end
  end
end
