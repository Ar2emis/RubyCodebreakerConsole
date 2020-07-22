# frozen_string_literal: true

module CodebreakerConsole
  class RestartState < GameState
    def execute
      puts(I18n.t(:restart_message))
      if user_input == YES
        context.game.restart
        context.transit_to(PlayState.new)
      else
        context.transit_to(MenuState.new)
      end
    end
  end
end