# frozen_string_literal: true

RSpec.describe ::Upgrader::Modules::Ruby::FileHandlers::BaseFileHandler do
  let(:project) { ::Upgrader::Project.new(name: 'test', opts: { path: 'spec/tmp/ruby-version-test' }) }
  let(:dummy) { Upgrader::Modules::Ruby::FileHandlers::DummyHandler }

  describe '.run' do
    context 'when file_paths throws an error' do
      before do
        allow_any_instance_of(::Upgrader::Modules::Ruby::FileHandlers::BaseFileHandler).to receive(:file_paths).and_raise(StandardError)
      end

      it 'should rescue the error and output a message' do
        expect { dummy.new(project, '3.3.6').run }.to output(/Could not update dummy because/).to_stdout
      end
    end
  end

  describe '.skip?' do
    context 'when there are no paths' do
      before do
        allow_any_instance_of(::Upgrader::Modules::Ruby::FileHandlers::BaseFileHandler).to receive(:file_paths).and_return([])
      end

      it 'should output a message and return true' do
        expect { dummy.new(project, '3.3.6').run }.to output(/No dummy found/).to_stdout
      end
    end

    context 'when there are multiple paths' do
      before do
        allow_any_instance_of(::Upgrader::Modules::Ruby::FileHandlers::BaseFileHandler).to receive(:file_paths).and_return(%w[path1 path2])
      end

      it 'should output a message and return true' do
        expect { dummy.new(project, '3.3.6').run }.to output(/Multiple dummy found, skipping/).to_stdout
      end
    end
  end
end
