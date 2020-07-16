# frozen_string_literal: true

RSpec.describe CodebreakerConsole::PlayState do
  subject(:state) do
    state = described_class.new
    state.context = context
    state
  end

  let(:context) do
    context = instance_double(CodebreakerConsole::GameConsole)
    allow(context).to receive(:transit_to, &:class)
    allow(context).to receive(:game).and_return(game)
    context
  end
  let(:game) do
    game = instance_double(Codebreaker::Game)
    allow(game).to receive(:make_turn).and_return({ status: Codebreaker::Game::PLAY_STATUS, result: '++++' })
    allow(game).to receive(:take_hint)
    game
  end

  describe '#execute' do
    it 'puts message to console' do
      allow(state).to receive(:gets).and_return('1234')
      expect { state.execute }.to output.to_stdout
    end

    context 'with game managment' do
      original_stdout = $stdout

      before do
        $stdout = File.open(File::NULL, 'w')
      end

      after do
        $stdout = original_stdout
      end

      it "gives a hint if user has entered '#{described_class::HINT_COMMAND}'" do
        allow(state).to receive(:gets).and_return(described_class::HINT_COMMAND)
        state.execute
        expect(game).to have_received(:take_hint)
      end

      it 'puts no hints left message if no hints left' do
        allow(state).to receive(:gets).and_return(described_class::HINT_COMMAND)
        allow(game).to receive(:take_hint) { raise Codebreaker::NoHintsLeftError }
        expect { state.execute }.to output.to_stdout
      end

      it 'puts invalid command message if user has entered invalid guess' do
        allow(state).to receive(:gets).and_return('invalid guess')
        allow(Codebreaker::Guess).to receive(:new) { raise Codebreaker::NonNumericStringError }
        expect(state.execute).to eq described_class
      end

      it 'moves to win state if user has won' do
        allow(state).to receive(:gets).and_return('1111')
        allow(game).to receive(:make_turn).and_return({ status: Codebreaker::Game::WIN_STATUS, result: '++++' })
        expect(state.execute).to eq CodebreakerConsole::WinState
      end

      it 'moves to lose state if user has lost' do
        allow(state).to receive(:gets).and_return('1111')
        allow(game).to receive(:make_turn).and_return({ status: Codebreaker::Game::LOSE_STATUS, result: '+-' })
        expect(state.execute).to eq CodebreakerConsole::LoseState
      end

      it 'stays itself if user is still playing' do
        allow(state).to receive(:gets).and_return('1111')
        allow(game).to receive(:make_turn).and_return({ status: Codebreaker::Game::PLAY_STATUS, result: '++' })
        expect(state.execute).to eq described_class
      end
    end
  end
end
