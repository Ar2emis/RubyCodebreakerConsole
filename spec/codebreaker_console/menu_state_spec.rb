# frozen_string_literal: true

RSpec.describe CodebreakerConsole::MenuState do
  subject(:state) do
    state = described_class.new
    state.context = context
    state
  end

  let(:context) do
    context = instance_double(CodebreakerConsole::GameConsole)
    allow(context).to receive(:transit_to)
    context
  end

  describe '#execute' do
    it 'puts message to console' do
      allow(state).to receive(:user_input).and_return(described_class::START_COMMAND)
      expect { state.execute }.to output(/Menu:/).to_stdout
    end

    context 'with command managment' do
      {
        described_class::START_COMMAND => CodebreakerConsole::RegistrationState,
        described_class::RULES_COMMAND => CodebreakerConsole::RulesState,
        described_class::STATS_COMMAND => CodebreakerConsole::StatsState
      }.each do |command, state_to|
        it "moves to #{command} state if user has entered '#{command}'" do
          allow(state).to receive(:user_input).and_return(command)
          allow(state).to receive(:puts)
          allow(context).to receive(:transit_to) { |state_instance| state_instance }
          expect(state.execute).to be_a(state_to)
        end
      end

      it 'put invalid command message if user has entered invalid command' do
        allow(state).to receive(:user_input).and_return('invalid_command')
        expect { state.execute }.to output(/#{I18n.t(:wrong_command_message)}/).to_stdout
      end
    end
  end
end
