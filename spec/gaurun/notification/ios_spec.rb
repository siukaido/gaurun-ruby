RSpec.describe Gaurun::Notification::IOS do
  describe '.payload' do
    subject { notification.payload }

    let(:notification) do
      Gaurun::Notification::IOS.new(message: message)
    end

    let(:message) { 'this is test message' }

    shared_examples_for '正常系' do
      it '空値でないhashが返る' do
        is_expected.not_to be_empty
        is_expected.to be_a Hash
      end

      it 'platformの値が1' do
        expect(subject[:platform]).to eq 1
      end

      it 'tokenの個数が指定した値' do
        expect(subject[:token].count).to eq token_count
      end

      it 'messageが入っている' do
        expect(subject[:message]).to eq message
      end
    end

    context 'tokenをstringで渡している時' do
      before { notification.token = 'device_token1' }

      it_behaves_like '正常系' do
        let(:token_count) { 1 }
      end
    end

    context 'tokenをarrayで渡している時' do
      before { notification.token = ['device_token1', 'device_token2'] }

      it_behaves_like '正常系' do
        let(:token_count) { 2 }
      end
    end

    context 'tokenを重複ありのarrayで渡している時' do
      before { notification.token = ['device_token1', 'device_token1'] }

      it_behaves_like '正常系' do
        let(:token_count) { 1 }
      end
    end

    context 'tokenを渡していない時' do
      it '空値のHashが返る' do
        is_expected.to be_a Hash
        is_expected.to be_empty
      end
    end
  end
end
