# frozen_string_literal: true

RSpec.describe ::Upgrader::Modules::Ruby::RSpecModule do
  let(:project) { ::Upgrader::Project.new(name: 'test', opts: { path: 'spec/tmp/rspec-test' }) }
  let(:manager_class) { double('ManagerClass') }
  let(:manager_instance) { double('ManagerInstance') }

  subject { described_class.new(project) }

  before do
    Dir.mkdir(project.path) unless Dir.exist?(project.path)
    allow(::Upgrader::Modules::Ruby::Managers).to receive(:manager).and_return(manager_class)
    allow(manager_class).to receive(:new).and_return(manager_instance)
    allow(Config).to receive(:options).and_return({ no_frame: true })
  end

  after do
    Dir.delete(project.path) if Dir.exist?(project.path)
  end

  describe '.run' do
    context 'when all examples pass' do
      before do
        allow(manager_instance).to receive(:run_command).and_return('10 examples, 0 failures')
        system('true')
      end

      it 'should not raise an error' do
        expect { subject.run }.not_to raise_error
      end
    end

    context 'when all examples pass with pending' do
      before do
        allow(manager_instance).to receive(:run_command).and_return('10 examples, 0 failures, 2 pending')
        system('true')
      end

      it 'should not raise an error' do
        expect { subject.run }.not_to raise_error
      end
    end

    context 'when there is a single example' do
      before do
        allow(manager_instance).to receive(:run_command).and_return('1 example, 0 failures')
        system('true')
      end

      it 'should not raise an error' do
        expect { subject.run }.not_to raise_error
      end
    end

    context 'when there are failures' do
      before do
        allow(manager_instance).to receive(:run_command).and_return('10 examples, 3 failures')
        allow(subject).to receive(:graceful_exit)
      end

      it 'should output an error message' do
        expect { subject.run }.to output(/3 example\(s\) failed/).to_stdout
      end
    end

    context 'when there are failures with pending' do
      before do
        allow(manager_instance).to receive(:run_command).and_return('10 examples, 2 failures, 1 pending')
        allow(subject).to receive(:graceful_exit)
      end

      it 'should output an error message' do
        expect { subject.run }.to output(/2 example\(s\) failed/).to_stdout
      end
    end

    context 'when output cannot be parsed' do
      before do
        allow(manager_instance).to receive(:run_command).and_return('some unexpected output')
        allow(subject).to receive(:graceful_exit)
      end

      it 'should output a cannot get output error' do
        expect { subject.run }.to output(/Cannot get output from RSpec/).to_stdout
      end
    end

    context 'when rspec exits with non-zero but output shows 0 failures' do
      before do
        allow(manager_instance).to receive(:run_command).and_return('10 examples, 0 failures')
        system('false')
        allow(subject).to receive(:graceful_exit)
      end

      it 'should output an error about rspec failing' do
        expect { subject.run }.to output(/RSpec failed with output/).to_stdout
      end
    end
  end

  describe 'module registration' do
    it 'should be registered as rspec' do
      expect(::Upgrader::Modules.modules['rspec']).to eq(described_class)
    end

    it 'should register the run step' do
      expect(::Upgrader::Modules.steps['ruby']['rspec']['run']).not_to be_nil
    end
  end
end
