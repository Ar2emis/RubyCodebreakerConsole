# frozen_string_literal: true

RSpec.describe CodebreakerConsole::PlayState do
  describe '#execute' do
    subject(:state) do
      state = described_class.new
      state.context = context
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
      allow(game).to receive(:make_turn)
      allow(game).to receive(:take_hint)
      allow(game).to receive(:win?).and_return(false)
      allow(game).to receive(:lose?).and_return(false)
      game
    end
    let(:entered_code) { '1234' }

    it 'puts message to console' do
      allow(state).to receive(:user_input).and_return(entered_code)
      expect { state.execute }.to output(/Enter a guess/).to_stdout
    end

    it 'puts invalid command message if user has entered invalid command or guess' do
      allow(state).to receive(:user_input).and_return('invalid command or guess')
      guess = instance_double(Codebreaker::Guess)
      allow(guess).to receive(:valid?).and_return(false)
      allow(Codebreaker::Guess).to receive(:new).and_return(guess)
      expect { state.execute }.to output(/#{I18n.t(:wrong_command_message)}/).to_stdout
    end

    context 'when hint asked' do
      before do
        allow(state).to receive(:user_input).and_return(described_class::HINT_COMMAND)
      end

      it "gives a hint if user has entered '#{described_class::HINT_COMMAND}'" do
        allow(state).to receive(:puts)
        state.execute
        expect(game).to have_received(:take_hint)
      end

      it 'puts no hints left message if no hints left' do
        allow(game).to receive(:take_hint) { raise Codebreaker::NoHintsLeftError }
        expect { state.execute }.to output(/#{I18n.t(:no_hints_left_message)}/).to_stdout
      end
    end

    context 'when guess entered' do
      let(:results_state) { instance_double(CodebreakerConsole::ResultsState) }
      let(:guess) do
        guess = instance_double(Codebreaker::Guess)
        allow(guess).to receive(:valid?).and_return(true)
        guess
      end
      let(:entered_code) { '1111' }

      before do
        allow(state).to receive(:puts)
        allow(state).to receive(:user_input).and_return(entered_code)
        allow(Codebreaker::Guess).to receive(:new).and_return(guess)
        allow(CodebreakerConsole::ResultsState).to receive(:new).and_return(results_state)
      end

      it 'moves to results state if user has won' do
        allow(game).to receive(:win?).and_return(true)
        state.execute
        expect(context).to have_received(:transit_to).with(results_state)
      end

      it 'moves to results state if user has lost' do
        allow(game).to receive(:win?).and_return(false)
        allow(game).to receive(:lose?).and_return(true)
        state.execute
        expect(context).to have_received(:transit_to).with(results_state)
      end

      it 'stays itself if user is still playing' do
        allow(game).to receive(:win?).and_return(false)
        allow(game).to receive(:lose?).and_return(false)
        state.execute
        expect(context).to have_received(:transit_to).with(state)
      end
    end
  end
end
