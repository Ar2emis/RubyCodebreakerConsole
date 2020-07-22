# frozen_string_literal: true

RSpec.describe CodebreakerConsole::ExitState do
  subject(:state) { described_class.new }

  before do
    allow(state).to receive(:gets).and_return('')
    allow(state).to receive(:exit)
  end

  describe '#execute' do
    it 'puts message to console' do
      expect { state.execute }.to output(/#{I18n.t(:exit_message)}/).to_stdout
    end
  end
end
