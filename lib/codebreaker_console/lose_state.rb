# frozen_string_literal: true

module CodebreakerConsole
  class LoseState < GameState
    def execute
      puts I18n.t(:lose_message, code: context.game.code.join)

      context.transit_to(RestartState.new)
    end
  end
end
