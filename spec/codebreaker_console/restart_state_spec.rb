# frozen_string_literal: true

RSpec.describe CodebreakerConsole::RestartState do
  subject(:state) do
    state = described_class.new
    state.context = context
    state
  end

  let(:game) do
    game = instance_double(Codebreaker::Game)
    allow(game).to receive(:restart)
    game
  end
  let(:context) do
    context = instance_double(CodebreakerConsole::GameConsole)
    allow(context).to receive(:transit_to)
    allow(context).to receive(:game).and_return(game)
    context
  end

  before do
    allow(state).to receive(:gets).and_return('no')
  end

  describe '#execute' do
    it 'puts message to console' do
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

      it "restarts the game if user has entered '#{described_class::YES}'" do
        allow(state).to receive(:gets).and_return(described_class::YES)
        state.execute
        expect(game).to have_received(:restart)
      end

      it 'does not restart the game if user has entered anything else' do
        state.execute
        expect(game).not_to have_received(:restart)
      end
    end
  end
end
