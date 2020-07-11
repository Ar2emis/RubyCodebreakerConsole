# frozen_string_literal: true

module CodebreakerConsole
  class RestartState < GameState
    YES = 'yes'

    def execute
      puts I18n.t(:restart_message)
      answer = gets.chomp

      if answer.downcase == YES
        context.game.restart
        context.transit_to(PlayState.new)
      else
        context.transit_to(MenuState.new)
      end
    end
  end
end
