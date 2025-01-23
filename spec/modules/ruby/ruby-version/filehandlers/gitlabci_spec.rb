# frozen_string_literal: true

RSpec.describe ::Upgrader::Modules::Ruby::FileHandlers::GitlabCI do
  let(:project) { ::Upgrader::Project.new(name: 'test', opts: { path: 'spec/tmp/ruby-version-test' }) }

  describe '.run' do
    context 'when upgrading .gitlab-ci.yml' do
      subject(:handler) { described_class.new(project, '3.3.6') }

      before do
        Dir.mkdir(project.path)
        File.write(File.join(project.path, '.gitlab-ci.yml'), 'image: public.ecr.aws/docker/library/ruby:3.0.0')
      end

      after do
        File.delete(File.join(project.path, '.gitlab-ci.yml'))
        Dir.delete(project.path)
      end

      it 'should upgrade the ruby version' do
        handler.run
        expect(File.read(File.join(project.path, '.gitlab-ci.yml')).strip).to eq('image: public.ecr.aws/docker/library/ruby:3.3.6')
      end
    end
  end
end
