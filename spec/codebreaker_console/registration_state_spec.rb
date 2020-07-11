# frozen_string_literal: true

RSpec.describe CodebreakerConsole::RegistrationState do
  subject(:state) do
    state = described_class.new
    state.context = context
    state
  end

  let(:context) do
    context = instance_double(CodebreakerConsole::GameConsole)
    allow(context).to receive(:transit_to)
    allow(context).to receive(:user=)
    context
  end

  before do
    allow(state).to receive(:gets).and_return('John Doe')
  end

  describe '#execute' do
    it 'puts message to console' do
      expect { state.execute }.to output.to_stdout
    end

    it 'puts invalid name message to console if user name is invalid' do
      allow(state).to receive(:gets).and_return('')
      expect { state.execute }.to output.to_stdout
    end

    context 'with game restart' do
      original_stdout = $stdout

      before do
        $stdout = File.open(File::NULL, 'w')
      end

      after do
        $stdout = original_stdout
      end

      it 'registers user if user has entered name' do
        state.execute
        expect(context).to have_received(:user=)
      end

      it "exits from the game if user has entered '#{described_class::EXIT_COMMAND}'" do
        allow(state).to receive(:gets).and_return(described_class::EXIT_COMMAND)
        state.execute
        expect(context).not_to have_received(:user=)
      end
    end
  end
end
