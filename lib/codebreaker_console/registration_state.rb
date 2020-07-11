# frozen_string_literal: true

module CodebreakerConsole
  class RegistrationState < GameState
    def execute
      puts I18n.t(:user_name_message)
      begin
        initialize_user(gets.chomp)
      rescue Codebreaker::InvalidStringLengthError
        puts(I18n.t(:invalid_user_name_message))
        context.transit_to(self.class.new)
      end

      context.transit_to(DifficultyState.new)
    end

    def initialize_user(name)
      if name == EXIT_COMMAND
        context.transit_to(ExitState.new)
      else
        context.user = Codebreaker::User.new(name)
      end
    end
  end
end
