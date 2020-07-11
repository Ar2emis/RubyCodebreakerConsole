# frozen_string_literal: true

RSpec.describe CodebreakerConsole::DifficultyState do
  subject(:state) do
    state = described_class.new
    state.context = context
    state
  end

  let(:context) do
    context = instance_double(CodebreakerConsole::GameConsole)
    allow(context).to receive(:transit_to)
    allow(context).to receive(:user).and_return(Codebreaker::User.new('John Doe'))
    allow(context).to receive(:game=)
    context
  end

  describe '#execute' do
    it 'puts message to console' do
      allow(state).to receive(:gets).and_return('difficulty')
      expect { state.execute }.to output.to_stdout
    end

    context 'with difficulty managment' do
      let(:factory) do
        factory = instance_double(Codebreaker::GameFactory)
        allow(factory).to receive(:create_game)
        factory
      end

      original_stdout = $stdout

      before do
        $stdout = File.open(File::NULL, 'w')
        allow(Codebreaker::GameFactory).to receive(:new).and_return(factory)
      end

      after do
        $stdout = original_stdout
      end

      it "exits from the game if user has entered '#{described_class::EXIT_COMMAND}'" do
        allow(state).to receive(:gets).and_return(described_class::EXIT_COMMAND)
        exit_state_instance = instance_double(CodebreakerConsole::ExitState)
        allow(CodebreakerConsole::ExitState).to receive(:new).and_return(exit_state_instance)
        state.execute
        expect(context).to have_received(:transit_to).with(exit_state_instance)
      end

      difficulties = {
        Codebreaker::GameFactory::EASY_DIFFICULTY.name => Codebreaker::GameFactory::EASY,
        Codebreaker::GameFactory::MEDIUM_DIFFICULTY.name => Codebreaker::GameFactory::MEDIUM,
        Codebreaker::GameFactory::HELL_DIFFICULTY.name => Codebreaker::GameFactory::HELL
      }

      difficulties.each do |difficulty_name, difficulty_keyword|
        it "creates a game with #{difficulty_name} difficulty if user has entered '#{difficulty_name}'" do
          allow(state).to receive(:gets).and_return(difficulty_name)
          state.execute
          expect(factory).to have_received(:create_game).with(context.user, difficulty_keyword)
        end
      end

      it 'put invalid difficulty message if user has entered invalid difficulty' do
        allow(state).to receive(:gets).and_return('invalid_difficulty')
        expect { state.execute }.to output.to_stdout
      end
    end
  end
end
