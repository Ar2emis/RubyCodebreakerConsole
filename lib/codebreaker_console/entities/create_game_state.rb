# frozen_string_literal: true

module CodebreakerConsole
  class CreateGameState < GameState
    def execute
      context.game = Codebreaker::Game.new(context.difficulty, context.user)
      context.game.start
      context.transit_to(PlayState.new)
    end
  end
end
