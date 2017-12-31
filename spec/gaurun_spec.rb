RSpec.describe Gaurun do
  context 'version number is' do
    it "not nil" do
      expect(Gaurun::VERSION).not_to be nil
    end
  end
end
