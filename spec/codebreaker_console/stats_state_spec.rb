# frozen_string_literal: true

RSpec.describe CodebreakerConsole::StatsState do
  subject(:state) { described_class.new }

  before do
    context = instance_double(CodebreakerConsole::GameConsole)
    allow(context).to receive(:transit_to)
    state.context = context
  end

  describe '#execute' do
    let(:stats) { YAML.load_file('spec/codebreaker_console/fixtures/user_statistic.yml')[:user_statistics] }

    it 'puts statistic to console' do
      allow(Codebreaker::Game).to receive(:user_statistic).and_return(stats)
      expect { state.execute }.to output.to_stdout
    end

    it 'puts empty statistic message if no statistic presents' do
      allow(Codebreaker::Game).to receive(:user_statistic).and_return([])
      expect { state.execute }.to output.to_stdout
    end
  end
end
