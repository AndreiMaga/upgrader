# frozen_string_literal: true

RSpec.describe ::Upgrader::Modules::Ruby::FileHandlers::RubyVersion do
  let(:project) { ::Upgrader::Project.new(name: 'test', opts: { path: 'spec/tmp/ruby-version-test' }) }

  describe '.run' do
    context 'when upgrading .ruby-version' do
      subject(:ruby_version) { described_class.new(project, '3.3.6') }

      before do
        Dir.mkdir(project.path)
        File.write(File.join(project.path, '.ruby-version'), '3.3.0')
      end

      after do
        File.delete(File.join(project.path, '.ruby-version'))
        Dir.delete(project.path)
      end

      it 'should upgrade the ruby version' do
        ruby_version.run
        expect(File.read(File.join(project.path, '.ruby-version')).strip).to eq('3.3.6')
      end
    end
  end
end
