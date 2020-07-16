# frozen_string_literal: true

module CodebreakerConsole
  class RegistrationState < GameState
    def execute
      puts I18n.t(:user_name_message)
      context.user = Codebreaker::User.new(user_input)
      context.transit_to(DifficultyState.new)
    rescue Codebreaker::InvalidStringLengthError
      puts(I18n.t(:invalid_user_name_message))
      context.transit_to(self.class.new)
    end
  end
end
