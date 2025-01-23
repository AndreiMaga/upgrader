# frozen_string_literal: true

RSpec.describe ::Upgrader::Modules::Ruby::FileHandlers::Docker do
  let(:project) { ::Upgrader::Project.new(name: 'test', opts: { path: 'spec/tmp/ruby-version-test' }) }

  describe '.run' do
    context 'when upgrading Dockerfile' do
      subject(:handler) { described_class.new(project, '3.3.6') }

      before do
        Dir.mkdir(project.path)
        File.write(File.join(project.path, 'Dockerfile'), 'FROM public.ecr.aws/docker/library/ruby:3.3.0-alpine3.19 as base')
      end

      after do
        File.delete(File.join(project.path, 'Dockerfile'))
        Dir.delete(project.path)
      end

      it 'should upgrade the ruby version' do
        handler.run
        expect(File.read(File.join(project.path, 'Dockerfile')).strip).to eq('FROM public.ecr.aws/docker/library/ruby:3.3.6-alpine3.19 as base')
      end
    end
  end
end
