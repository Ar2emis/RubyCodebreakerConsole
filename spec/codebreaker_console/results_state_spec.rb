# frozen_string_literal: true

RSpec.describe CodebreakerConsole::ResultsState do
  subject(:state) do
    state = described_class.new
    state.context = context
    allow(state).to receive(:user_input).and_return('')
    state
  end

  let(:context) do
    context = instance_double(CodebreakerConsole::GameConsole)
    allow(context).to receive(:transit_to)
    allow(context).to receive(:game).and_return(game)
    context
  end
  let(:game) do
    game = instance_double(Codebreaker::Game)
    allow(game).to receive(:code).and_return(code)
    allow(game).to receive(:restart)
    game
  end
  let(:code) { [1, 2, 3, 4] }

  describe '#execute' do
    it 'puts lose message if user has lost' do
      allow(game).to receive(:win?).and_return(false)
      expect { state.execute }.to output(/#{I18n.t(:lose_message, code: code)}/).to_stdout
    end

    it 'puts win message if user has won' do
      allow(game).to receive(:win?).and_return(true)
      expect { state.execute }.to output(/#{I18n.t(:win_message, code: code)}/).to_stdout
    end

    it 'puts save statistic message if user has won' do
      allow(game).to receive(:win?).and_return(true)
      allow(game).to receive(:save_statistic)
      allow(state).to receive(:user_input).and_return(described_class::YES)
      expect { state.execute }.to output(/Do you want to save statistic?/).to_stdout
    end
  end
end
