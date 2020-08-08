# frozen_string_literal: true

RSpec.describe CodebreakerConsole::GameConsole do
  subject(:console) { described_class.new }

  let(:state) { instance_double(CodebreakerConsole::GameState) }

  before do
    allow(state).to receive(:context=).with(console)
    allow(state).to receive(:execute)
  end

  describe '#transit_to' do
    it 'moves game to another state' do
      console.transit_to(state)
      expect(console.instance_variable_get(:@game_state)).to eql state
    end
  end

  describe '#start' do
    before do
      allow(CodebreakerConsole::MenuState).to receive(:new).and_return(state)
    end

    it 'moves game to menu state' do
      console.start
      expect(console.instance_variable_get(:@game_state)).to eql state
    end
  end
end
