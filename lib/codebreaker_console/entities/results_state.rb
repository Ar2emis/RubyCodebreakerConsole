# frozen_string_literal: true

module CodebreakerConsole
  class ResultsState < GameState
    def execute
      context.game.win? ? win_scenario : puts(I18n.t(:lose_message, code: string_code))
      ask_to_restart
    end

    private

    def ask_to_restart
      puts(I18n.t(:restart_message))
      return context.transit_to(MenuState.new) unless user_input == YES

      context.game.restart
      context.transit_to(PlayState.new)
    end

    def win_scenario
      puts(I18n.t(:win_message, code: string_code))
      puts(I18n.t(:save_statistic_message))
      context.game.save_statistic if user_input == YES
    end

    def string_code
      context.game.code.join
    end
  end
end
