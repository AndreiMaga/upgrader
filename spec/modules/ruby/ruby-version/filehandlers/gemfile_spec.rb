# frozen_string_literal: true

RSpec.describe ::Upgrader::Modules::Ruby::FileHandlers::Gemfile do
  let(:project) { ::Upgrader::Project.new(name: 'test', opts: { path: 'spec/tmp/ruby-version-test' }) }

  describe '.run' do
    context 'when upgrading Gemfile' do
      subject(:handler) { described_class.new(project, '3.3.6') }

      before do
        Dir.mkdir(project.path)
        File.write(File.join(project.path, 'Gemfile'), 'ruby "3.0.0"')
      end

      after do
        File.delete(File.join(project.path, 'Gemfile'))
        Dir.delete(project.path)
      end

      it 'should upgrade the ruby version' do
        handler.run
        expect(File.read(File.join(project.path, 'Gemfile')).strip).to eq('ruby "3.3.6"')
      end
    end
  end
end
