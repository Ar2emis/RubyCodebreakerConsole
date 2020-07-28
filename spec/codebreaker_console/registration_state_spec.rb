# frozen_string_literal: true

RSpec.describe CodebreakerConsole::RegistrationState do
  describe '#execute' do
    subject(:state) { described_class.new }

    let(:context) { instance_double(CodebreakerConsole::GameConsole) }
    let(:game) { instance_double(Codebreaker::Game) }

    let(:valid_name) { Faker::Name.first_name }
    let(:invalid_name) { 'a' * (Codebreaker::User::USERNAME_MIN_LENGTH - 1) }
    let(:valid_difficulty_name) { I18n.t(:easy_difficulty) }
    let(:invalid_difficulty_name) { 'invalid_difficulty_name' }
    let(:exit_command) { described_class::EXIT_COMMAND }
    let(:valid_inputs) { [valid_name, valid_difficulty_name] }
    let(:invalid_name_inputs) { [invalid_name, valid_name, valid_difficulty_name] }
    let(:invalid_difficulty_inputs) { [valid_name, invalid_difficulty_name, valid_difficulty_name] }
    let(:exit_inputs) { [exit_command, valid_name, valid_difficulty_name] }

    before do
      state.context = context
      allow(context).to receive(:transit_to)
      allow(context).to receive(:game=)
      allow(context).to receive(:game).and_return(game)
      allow(game).to receive(:start)
    end

    it 'puts message to console' do
      allow(state).to receive(:gets).and_return(*valid_inputs)
      expect { state.execute }.to output(/#{I18n.t(:user_name_message)}/).to_stdout
    end

    it 'puts invalid name message to console if name is invalid' do
      allow(state).to receive(:gets).and_return(*invalid_name_inputs)
      expect { state.execute }.to output(/#{I18n.t(:invalid_user_name_message)}/).to_stdout
    end

    it 'puts invalid difficulty message to console if difficulty is invalid' do
      allow(state).to receive(:gets).and_return(*invalid_difficulty_inputs)
      expect { state.execute }.to output(/#{I18n.t(:invalid_difficulty_message)}/).to_stdout
    end

    it "puts exit message and exits from the game if user has entered #{described_class::EXIT_COMMAND}" do
      allow(state).to receive(:gets).and_return(*exit_inputs)
      allow(state).to receive(:exit)
      expect { state.execute }.to output(/#{I18n.t(:exit_message)}/).to_stdout
    end
  end
end
