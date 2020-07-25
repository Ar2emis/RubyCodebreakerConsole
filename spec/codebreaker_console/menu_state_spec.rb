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
    let(:registration_state) { instance_double(CodebreakerConsole::RegistrationState) }
    let(:stats_fixture) { File.join('spec', 'codebreaker_console', 'fixtures', 'user_statistic.yml') }

    it 'puts message to console' do
      allow(state).to receive(:user_input).and_return(described_class::START_COMMAND)
      expect { state.execute }.to output(/#{I18n.t(:greeting)}/).to_stdout
    end

    it "moves to registration state if user has entered '#{described_class::START_COMMAND}'" do
      allow(state).to receive(:user_input).and_return(described_class::START_COMMAND)
      allow(state).to receive(:puts)
      allow(CodebreakerConsole::RegistrationState).to receive(:new).and_return(registration_state)
      state.execute
      expect(context).to have_received(:transit_to).with(registration_state)
    end

    it "puts rules if user has entered '#{described_class::RULES_COMMAND}'" do
      allow(state).to receive(:user_input).and_return(described_class::RULES_COMMAND)
      expect { state.execute }.to output(/Game Rules/).to_stdout
    end

    context "when user has entered '#{described_class::STATS_COMMAND}'" do
      it 'puts statistic if statistic exists' do
        allow(state).to receive(:user_input).and_return(described_class::STATS_COMMAND)
        allow(Codebreaker::Game).to receive(:user_statistic) { YAML.load_file(stats_fixture)[:user_statistics] }
        expect { state.execute }.to output(/#{I18n.t(:statistic_title)}/).to_stdout
      end

      it 'puts that statistic empty if no statistic exists' do
        allow(state).to receive(:user_input).and_return(described_class::STATS_COMMAND)
        allow(Codebreaker::Game).to receive(:user_statistic).and_return([])
        expect { state.execute }.to output(/#{I18n.t(:empty_statistic)}/).to_stdout
      end
    end

    it 'put invalid command message if user has entered invalid command' do
      allow(state).to receive(:user_input).and_return('invalid_command')
      expect { state.execute }.to output(/#{I18n.t(:wrong_command_message)}/).to_stdout
    end
  end
end
