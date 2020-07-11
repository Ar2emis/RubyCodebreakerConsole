# frozen_string_literal: true

module CodebreakerConsole
  class WinState < GameState
    YES = 'yes'

    def execute
      puts I18n.t(:win_message, code: context.game.code.join)

      save_statistic

      context.transit_to(RestartState.new)
    end

    private

    def save_statistic
      puts(I18n.t(:save_statistic_message))
      answer = gets.chomp

      context.game.save_statistic if answer.downcase == YES
    end
  end
end
