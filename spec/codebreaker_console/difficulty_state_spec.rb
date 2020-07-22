# frozen_string_literal: true

RSpec.describe CodebreakerConsole::DifficultyState do
  describe '#execute' do
    subject(:state) do
      state = described_class.new
      state.context = context
      state
    end

    let(:context) do
      context = instance_double(CodebreakerConsole::GameConsole)
      allow(context).to receive(:transit_to)
      allow(context).to receive(:difficulty=)
      context
    end

    it 'puts message to console' do
      allow(state).to receive(:user_input).and_return('difficulty')
      expect { state.execute }.to output(/Choose difficulty:/).to_stdout
    end

    context 'with difficulty managment' do
      [I18n.t(:easy_difficulty), I18n.t(:medium_difficulty), I18n.t(:hell_difficulty)].each do |difficulty_name|
        it "creates a #{difficulty_name} difficulty if user has entered '#{difficulty_name}'" do
          allow(state).to receive(:user_input).and_return(difficulty_name)
          allow(state).to receive(:puts)
          state.execute
          expect(context).to have_received(:difficulty=)
        end
      end

      it 'put invalid difficulty message if user has entered invalid difficulty' do
        allow(state).to receive(:user_input).and_return('invalid_difficulty')
        expect { state.execute }.to output(/#{I18n.t(:invalid_difficulty_message)}/).to_stdout
      end
    end
  end
end
