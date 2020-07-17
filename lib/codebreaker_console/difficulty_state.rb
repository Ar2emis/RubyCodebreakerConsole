# frozen_string_literal: true

module CodebreakerConsole
  class DifficultyState < GameState
    def execute
      puts I18n.t(:difficulty_message, difficulties: difficulties.keys.join(', '))
      difficulty = difficulties[user_input.downcase]
      if difficulty.nil?
        invalid_difficulty_message
      else
        move_to_next_stage(difficulty)
      end
    end

    private

    def difficulties
      {
        I18n.t(:easy_difficulty) => Codebreaker::Difficulty.difficulty(:easy),
        I18n.t(:medium_difficulty) => Codebreaker::Difficulty.difficulty(:medium),
        I18n.t(:hell_difficulty) => Codebreaker::Difficulty.difficulty(:hell)
      }
    end

    def invalid_difficulty_message
      puts(I18n.t(:invalid_difficulty_message))
      context.transit_to(self)
    end

    def move_to_next_stage(difficulty)
      context.difficulty = difficulty
      context.transit_to(CreateGameState.new)
    end
  end
end
