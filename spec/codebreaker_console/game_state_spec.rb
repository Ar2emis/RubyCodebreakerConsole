# frozen_string_literal: true

RSpec.describe CodebreakerConsole::GameState do
  subject(:command) { described_class.new }

  describe '#execute' do
    it 'raises NotImplementedError' do
      expect { command.execute }.to raise_error(NotImplementedError)
    end
  end
end
