# frozen_string_literal: true

module CodebreakerConsole
  class RegistrationState < GameState
    def execute
      puts I18n.t(:user_name_message)
      context.user = Codebreaker::User.new(user_input)
      if context.user.valid?
        context.transit_to(DifficultyState.new)
      else
        invalid_user_name_message
      end
    end

    private

    def invalid_user_name_message
      puts(I18n.t(:invalid_user_name_message))
      context.transit_to(self)
    end
  end
end
