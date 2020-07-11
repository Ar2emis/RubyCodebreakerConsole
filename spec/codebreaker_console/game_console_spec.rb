# frozen_string_literal: true

RSpec.describe CodebreakerConsole::GameConsole do
  subject(:console) { described_class.new }

  describe '#transit_to' do
    let(:state) do
      state = instance_double(CodebreakerConsole::GameState)
      allow(state).to receive(:context=).with(console)
      allow(state).to receive(:execute)
      state
    end

    it 'moves game to another state' do
      console.transit_to(state)
      expect(console.instance_variable_get(:@game_state)).to eql state
    end
  end

  describe '#start' do
    let(:greeting_state) do
      state = instance_double(CodebreakerConsole::GreetingState)
      allow(state).to receive(:context=).with(console)
      allow(state).to receive(:execute)
      state
    end

    before do
      allow(CodebreakerConsole::GreetingState).to receive(:new).and_return(greeting_state)
    end

    it 'moves game to another state' do
      console.start
      expect(console.instance_variable_get(:@game_state)).to eql greeting_state
    end
  end
end
