# frozen_string_literal: true

RSpec.describe CodebreakerConsole::CreateGameState do
  describe '#execute' do
    subject(:state) do
      state = described_class.new
      state.context = context
      state
    end

    let(:context) do
      context = instance_double(CodebreakerConsole::GameConsole)
      allow(context).to receive(:transit_to)
      allow(context).to receive(:user).and_return(instance_double(Codebreaker::User))
      allow(context).to receive(:difficulty).and_return(instance_double(Codebreaker::Difficulty))
      allow(context).to receive(:game).and_return(game)
      allow(context).to receive(:game=)
      context
    end
    let(:game) do
      game = instance_double(Codebreaker::Game)
      allow(game).to receive(:start)
      game
    end

    before do
      allow(Codebreaker::Game).to receive(:new).and_return(game)
    end

    it 'creates game instance' do
      state.execute
      expect(context).to have_received(:game=).with(game)
    end

    it 'moves to play state' do
      state.execute
      expect(context).to have_received(:transit_to)
    end
  end
end
