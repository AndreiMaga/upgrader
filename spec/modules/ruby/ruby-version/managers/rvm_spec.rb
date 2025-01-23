# frozen_string_literal: true

RSpec.describe ::Upgrader::Modules::Ruby::Managers::Rvm do
  describe '#list_of_versions' do
    context 'when calling the manager' do
      it 'should raise NotImplementedError' do
        expect { described_class.list_of_versions }.to raise_error(NotImplementedError)
      end
    end
  end
end
