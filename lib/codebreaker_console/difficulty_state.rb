# frozen_string_literal: true

module CodebreakerConsole
  class DifficultyState < GameState
    def execute
      puts I18n.t(:difficulty_message, difficulties: difficulties.join(', '))

      context.game = Codebreaker::GameFactory.new.create_game(context.user, user_input.to_sym)
      context.transit_to(PlayState.new)
    rescue Codebreaker::UnknownDifficultyError
      handle_invalid_difficulty
    end

    def difficulties
      [
        Codebreaker::GameFactory::EASY_DIFFICULTY.name,
        Codebreaker::GameFactory::MEDIUM_DIFFICULTY.name,
        Codebreaker::GameFactory::HELL_DIFFICULTY.name
      ]
    end

    private

    def handle_invalid_difficulty
      puts(I18n.t(:invalid_difficulty_message))
      context.transit_to(self.class.new)
    end
  end
end
