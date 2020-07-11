# frozen_string_literal: true

RSpec.describe CodebreakerConsole::LoseState do
  subject(:state) { described_class.new }

  before do
    context = instance_double(CodebreakerConsole::GameConsole)
    allow(context).to receive(:transit_to)

    game = instance_double(Codebreaker::Game)
    allow(game).to receive(:code).and_return([1, 2, 3, 4])
    allow(context).to receive(:game).and_return(game)

    state.context = context
  end

  describe '#execute' do
    it 'puts message to console' do
      expect { state.execute }.to output.to_stdout
    end
  end
end
