RSpec.describe Gaurun::Notification do
  describe 'initialize' do
    subject { Gaurun::Notification.new(message: message) }

    let(:message) { 'this is test message' }

    it 'ios/android共にインスタンスが生成されている' do
      expect(subject.ios).to be_a Gaurun::Notification::IOS
      expect(subject.android).to be_a Gaurun::Notification::Android
    end

    it 'messageが各platformインスタンスに入っている' do
      expect(subject.ios.message).to eq message
      expect(subject.android.message).to eq message
    end
  end

  describe '.payload' do
    subject { notification.payload }

    let(:notification) do
      Gaurun::Notification.new(message: message)
    end

    let(:message) { 'this is test message' }

    context 'tokenを指定していない' do
      it 'nilが返る' do
        is_expected.to be_nil
      end
    end

    context 'iosだけ指定している' do
      before do
        notification.ios.token = 'device_token'
      end

      it '空でないHashが返る' do
        is_expected.to be_a Hash
        is_expected.not_to be_empty
      end

      context 'key: notificationsにおいて' do
        it '要素は1つだけ' do
          expect(subject[:notifications].count).to eq 1
        end

        it '要素のtoken個数は1つだけ' do
          expect(subject[:notifications][0][:token].count).to eq 1
        end

        it '要素のmessageが入っている' do
          expect(subject[:notifications][0][:message]).to eq message
        end
      end
    end

    context 'androidだけ指定してる' do
      before do
        notification.android.token = 'registration_id'
      end

      it '空でないHashが返る' do
        is_expected.to be_a Hash
        is_expected.not_to be_empty
      end

      context 'key: notificationsにおいて' do
        it '要素は1つだけ' do
          expect(subject[:notifications].count).to eq 1
        end

        it '要素のtoken個数は1つだけ' do
          expect(subject[:notifications][0][:token].count).to eq 1
        end

        it '要素のmessageが入っている' do
          expect(subject[:notifications][0][:message]).to eq message
        end
      end
    end

    context 'ios/androidともに指定してる' do
      before do
        notification.ios.token = 'device_token'
        notification.android.token = 'registration_id'
      end

      it '空でないHashが返る' do
        is_expected.to be_a Hash
        is_expected.not_to be_empty
      end

      context 'key: notificationsにおいて' do
        it '要素は2つ' do
          expect(subject[:notifications].count).to eq 2
        end

        it '要素ごとのtoken個数は1つだけ' do
          expect(subject[:notifications][0][:token].count).to eq 1
          expect(subject[:notifications][1][:token].count).to eq 1
        end

        it '要素のmessageが入っている' do
          expect(subject[:notifications][0][:message]).to eq message
          expect(subject[:notifications][1][:message]).to eq message
        end
      end
    end
  end
end
