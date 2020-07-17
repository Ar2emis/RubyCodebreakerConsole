# frozen_string_literal: true

RSpec.describe CodebreakerConsole::CreateGameState do
  subject(:state) do
    state = described_class.new
    state.context = context
    state
  end

  let(:context) do
    context = instance_double(CodebreakerConsole::GameConsole)
    allow(context).to receive(:transit_to, &:class)
    allow(context).to receive(:user).and_return(instance_double(Codebreaker::User))
    allow(context).to receive(:difficulty).and_return(instance_double(Codebreaker::Difficulty))
    allow(context).to receive(:game=)
    context
  end
  let(:game) { instance_double(Codebreaker::Game) }

  describe '#execute' do
    before do
      allow(Codebreaker::Game).to receive(:new).and_return(game)
    end

    it 'creates game instance' do
      state.execute
      expect(context).to have_received(:game=).with(game)
    end

    it 'moves to play state' do
      expect(state.execute).to eq CodebreakerConsole::PlayState
    end
  end
end
