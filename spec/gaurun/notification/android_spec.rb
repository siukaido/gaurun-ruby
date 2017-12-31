RSpec.describe Gaurun::Notification::Android do
  describe '.payload' do
    subject { notification.payload }

    let(:notification) do
      Gaurun::Notification::Android.new(message: message)
    end

    let(:message) { 'this is test message' }

    shared_examples_for '正常系' do
      it '空値でないHashが返る' do
        is_expected.not_to be_empty
        is_expected.to be_a Hash
      end

      it 'platformの値が2' do
        expect(subject[:platform]).to eq 2
      end

      it 'tokenの個数が指定した値' do
        expect(subject[:token].count).to eq token_count
      end

      it 'messageが入っている' do
        expect(subject[:message]).to eq message
      end
    end

    context 'tokenをstringで渡している時' do
      before { notification.token = 'registration_id1' }

      it_behaves_like '正常系' do
        let(:token_count) { 1 }
      end
    end

    context 'tokenをarrayで渡している時' do
      before { notification.token = ['registration_id1', 'registration_id2'] }

      it_behaves_like '正常系' do
        let(:token_count) { 2 }
      end
    end

    context 'tokenを重複ありのarrayで渡している時' do
      before { notification.token = ['registration_id1', 'registration_id1'] }

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
