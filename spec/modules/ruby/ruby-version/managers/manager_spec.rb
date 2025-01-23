# frozen_string_literal: true

RSpec.describe ::Upgrader::Modules::Ruby::Managers do
  describe '.manager' do
    context 'when calling the manager' do
      before do
        allow(::Config).to receive(:languages).and_return({ ruby: { manager: 'rvm' } })
      end

      it 'should return the correct manager' do
        expect(described_class.manager).to eq(::Upgrader::Modules::Ruby::Managers::Rvm)
      end
    end
  end
end
