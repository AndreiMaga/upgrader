# frozen_string_literal: true

RSpec.describe ::Upgrader::Modules::Ruby::FileHandlers do
  let(:project) { ::Upgrader::Project.new(name: 'test', opts: { path: 'spec/tmp/ruby-version-test' }) }
  let(:dummy) { Upgrader::Modules::Ruby::FileHandlers::DummyHandler }
  describe '.register_file_handler' do
    context 'when registering a file handler' do
      before do
        described_class.clear_file_handlers
      end

      it 'should register the file handler' do
        described_class.register_file_handler(dummy.to_s, dummy)
        expect(described_class.file_handlers).to include(dummy.to_s => dummy)
      end
    end
  end

  describe '.run_file_handlers' do
    context 'when upgrading a file' do
      before do
        described_class.clear_file_handlers
        described_class.register_file_handler(dummy.to_s, dummy)
      end

      it 'should upgrade the file' do
        expect(dummy).to receive(:new).with(project, '3.3.6').and_call_original
        expect_any_instance_of(dummy).to receive(:run)
        described_class.run_file_handlers(project, '3.3.6')
      end
    end
  end
end
