# frozen_string_literal: true

module CodebreakerConsole
  class WinState < GameState
    YES = 'yes'

    def execute
      puts(I18n.t(:win_message, code: context.game.code.join))
      ask_to_save_statistic
      context.transit_to(RestartState.new)
    end

    private

    def ask_to_save_statistic
      puts(I18n.t(:save_statistic_message))
      context.game.save_statistic if user_input == YES
    end
  end
end
