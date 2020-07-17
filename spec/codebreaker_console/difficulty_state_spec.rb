# frozen_string_literal: true

RSpec.describe CodebreakerConsole::DifficultyState do
  subject(:state) do
    state = described_class.new
    state.context = context
    state
  end

  let(:context) do
    context = instance_double(CodebreakerConsole::GameConsole)
    allow(context).to receive(:transit_to, &:class)
    allow(context).to receive(:user).and_return(Codebreaker::User.new('John Doe'))
    allow(context).to receive(:difficulty=)
    context
  end

  describe '#execute' do
    it 'puts message to console' do
      allow(state).to receive(:gets).and_return('difficulty')
      expect { state.execute }.to output.to_stdout
    end

    context 'with difficulty managment' do
      original_stdout = $stdout

      before do
        $stdout = File.open(File::NULL, 'w')
      end

      after do
        $stdout = original_stdout
      end

      difficulties_names = [
        I18n.t(:easy_difficulty), I18n.t(:medium_difficulty), I18n.t(:hell_difficulty)
      ]

      difficulties_names.each do |difficulty_name|
        it "creates a #{difficulty_name} difficulty if user has entered '#{difficulty_name}'" do
          allow(state).to receive(:gets).and_return(difficulty_name)
          expect(state.execute).to eq CodebreakerConsole::CreateGameState
        end
      end

      it 'put invalid difficulty message if user has entered invalid difficulty' do
        allow(state).to receive(:gets).and_return('invalid_difficulty')
        expect(state.execute).to eq described_class
      end
    end
  end
end
