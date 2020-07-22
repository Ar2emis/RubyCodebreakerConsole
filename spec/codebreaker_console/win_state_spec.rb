# frozen_string_literal: true

RSpec.describe CodebreakerConsole::WinState do
  subject(:state) do
    state = described_class.new
    state.context = context
    state
  end

  let(:game) do
    game = instance_double(Codebreaker::Game)
    allow(game).to receive(:code).and_return([1, 2, 3, 4])
    allow(game).to receive(:save_statistic)
    game
  end
  let(:context) do
    context = instance_double(CodebreakerConsole::GameConsole)
    allow(context).to receive(:transit_to)
    allow(context).to receive(:game).and_return(game)
    context
  end

  describe '#execute' do
    it 'puts message to console' do
      allow(state).to receive(:user_input).and_return('no')
      expect { state.execute }.to output.to_stdout
    end

    context 'with statistic saving' do
      before do
        allow(state).to receive(:puts)
      end

      it "saves statistic if user has entered '#{described_class::YES}'" do
        allow(state).to receive(:user_input).and_return(described_class::YES)
        state.execute
        expect(game).to have_received(:save_statistic)
      end

      it "exits if user has entered '#{described_class::EXIT_COMMAND}'" do
        allow(state).to receive(:gets).and_return(described_class::EXIT_COMMAND)
        exit_state = instance_double(CodebreakerConsole::ExitState)
        allow(CodebreakerConsole::ExitState).to receive(:new).and_return(exit_state)
        state.execute
        expect(context).to have_received(:transit_to).with(exit_state)
      end

      it 'does not save statistic if user has entered anything else' do
        allow(state).to receive(:user_input).and_return('no')
        state.execute
        expect(game).not_to have_received(:save_statistic)
      end
    end
  end
end
