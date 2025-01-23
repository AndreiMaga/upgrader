# frozen_string_literal: true

RSpec.describe ::Upgrader::Modules::Ruby::FileHandlers::Rubocop do
  let(:project) { ::Upgrader::Project.new(name: 'test', opts: { path: 'spec/tmp/ruby-version-test' }) }

  let(:template) do
    <<~RUBOCOP
      AllCops:
       TargetRubyVersion: ${RUBY_VERSION}
    RUBOCOP
  end

  let(:outversion) { '3.3.6' }

  let(:input) { template.gsub('${RUBY_VERSION}', '3.3.0') }
  let(:output) { template.gsub('${RUBY_VERSION}', outversion) }

  describe '.run' do
    context 'when upgrading .rubocop.yml' do
      subject(:handler) { described_class.new(project, outversion) }

      before do
        Dir.mkdir(project.path)
        File.write(File.join(project.path, '.rubocop.yml'), input)
      end

      after do
        File.delete(File.join(project.path, '.rubocop.yml'))
        Dir.delete(project.path)
      end

      it 'should upgrade the ruby version' do
        handler.run
        expect(File.read(File.join(project.path, '.rubocop.yml')).strip).to eq(output.strip)
      end
    end
  end
end
