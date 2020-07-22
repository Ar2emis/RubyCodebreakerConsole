# frozen_string_literal: true

RSpec.describe CodebreakerConsole::GreetingState do
  subject(:state) { described_class.new }

  describe '#execute' do
    before do
      context = instance_double(CodebreakerConsole::GameConsole)
      allow(context).to receive(:transit_to)
      state.context = context
    end

    it 'puts message to console' do
      expect { state.execute }.to output(/#{I18n.t(:greeting)}/).to_stdout
    end
  end
end
