RSpec.describe Gaurun::Client do
  let(:client) { Gaurun::Client.new }

  shared_examples_for '正常系' do
    it 'statusが200' do
      expect(subject.status_code).to eq 200
    end

    it 'bodyがHashで想定通り' do
      expect(subject.body).to be_a Hash
      expect(subject.body).to eq example
    end
  end

  describe '.push' do
    subject { client.push(notification) }

    let(:notification) { Gaurun::Notification.new(message: message) }
    let(:message) { 'this is test message' }

    before do
      notification.ios.token = '2483c552480a553035d4eda67cf7a0512463729c5158ea7cd72b8a5947a3ece2'
    end

    it_behaves_like '正常系' do
      let(:example) do
        {
          message: 'ok',
        }
      end
    end
  end

  describe '.parallel_push' do
    subject { client.parallel_push(notifications) }

    let(:notifications) do
      [
        Gaurun::Notification.new(message: message),
        Gaurun::Notification.new(message: message),
        Gaurun::Notification.new(message: message)
      ]
    end
    let(:message) { 'this is test message' }

    before do
      notifications.each do |notification|
        notification.ios.token = '2483c552480a553035d4eda67cf7a0512463729c5158ea7cd72b8a5947a3ece2'
      end
    end

    let(:example) do
      {
        message: 'ok',
      }
    end

    it 'bodyが配列で想定どうり' do
      expect(subject).to be_a Array
      expect(subject).to all be_a Gaurun::Response
      subject.each do |sub|
        expect(sub.body).to eq example
      end
    end
  end

  describe 'config_pushers' do
    subject { client.config_pushers(10) }

    it_behaves_like '正常系' do
      let(:example) do
        {
          message: 'ok',
        }
      end
    end
  end

  describe '.stat_go' do
    subject { client.stat_go }

    it_behaves_like '正常系' do
      let(:example) do
        {
          time: 1509619981770605566,
          go_version: 'go1.9.2',
          go_os: 'darwin',
          go_arch: 'amd64',
          cpu_num: 4,
          goroutine_num: 16,
          gomaxprocs: 4,
          cgo_call_num: 1,
          memory_alloc: 2385600,
          memory_total_alloc: 2385600,
          memory_sys: 6285560,
          memory_lookups: 16,
          memory_mallocs: 10850,
          memory_frees: 437,
          memory_stack: 491520,
          heap_alloc: 2385600,
          heap_sys: 3309568,
          heap_idle: 81920,
          heap_inuse: 3227648,
          heap_released: 0,
          heap_objects: 10413,
          gc_next: 4473924,
          gc_last: 0,
          gc_num: 0,
          gc_per_second: 0,
          gc_pause_per_second: 0,
          gc_pause: [],
        }
      end
    end
  end

  describe '.stat_app' do
    subject { client.stat_app }

    it_behaves_like '正常系' do
      let(:example) do
        {
          queue_max: 8192,
          queue_usage: 9,
          pusher_max: 16,
          pusher_count: 0,
          ios: {
            push_success: 2759,
            push_error: 10,
          },
          android: {
            push_success: 2985,
            push_error: 35,
          },
        }
      end
    end
  end
end
