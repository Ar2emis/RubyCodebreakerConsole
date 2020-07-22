# frozen_string_literal: true

RSpec.describe CodebreakerConsole::RegistrationState do
  subject(:state) do
    state = described_class.new
    state.context = context
    state
  end

  let(:context) do
    context = instance_double(CodebreakerConsole::GameConsole)
    allow(context).to receive(:transit_to)
    allow(context).to receive(:user=)
    allow(context).to receive(:user).and_return(user)
    context
  end
  let(:user) do
    user = instance_double(Codebreaker::User)
    allow(user).to receive(:valid?).and_return(true)
    user
  end

  before do
    allow(state).to receive(:user_input).and_return('John Doe')
  end

  describe '#execute' do
    it 'puts message to console' do
      expect { state.execute }.to output(/#{I18n.t(:user_name_message)}/).to_stdout
    end

    it 'puts invalid name message to console if user name is invalid' do
      allow(state).to receive(:user_input).and_return('')
      allow(user).to receive(:valid?).and_return(false)
      expect { state.execute }.to output(/#{I18n.t(:invalid_user_name_message)}/).to_stdout
    end

    context 'with user logic' do
      before do
        allow(state).to receive(:puts)
      end

      it 'registers user if user has entered name' do
        state.execute
        expect(context).to have_received(:user=)
      end
    end
  end
end
