# frozen_string_literal: true

module CodebreakerConsole
  class DifficultyState < GameState
    def initialize
      @factory = Codebreaker::GameFactory.new
    end

    def execute
      puts I18n.t(:difficulty_message, **interpolation_hash)
      difficulty_keyword = manage_difficulty(gets.chomp)

      context.transit_to(PlayState.new) if initialize_game?(difficulty_keyword)

      handle_invalid_difficulty
    end

    private

    def handle_invalid_difficulty
      puts(I18n.t(:invalid_difficulty_message))
      context.transit_to(self.class.new)
    end

    def interpolation_hash
      {
        easy: Codebreaker::GameFactory::EASY_DIFFICULTY.name,
        medium: Codebreaker::GameFactory::MEDIUM_DIFFICULTY.name,
        hell: Codebreaker::GameFactory::HELL_DIFFICULTY.name
      }
    end

    def manage_difficulty(difficulty_name)
      context.transit_to(ExitState.new) if difficulty_name == EXIT_COMMAND

      case difficulty_name
      when Codebreaker::GameFactory::EASY_DIFFICULTY.name then Codebreaker::GameFactory::EASY
      when Codebreaker::GameFactory::MEDIUM_DIFFICULTY.name then Codebreaker::GameFactory::MEDIUM
      when Codebreaker::GameFactory::HELL_DIFFICULTY.name then Codebreaker::GameFactory::HELL
      end
    end

    def initialize_game?(difficulty_keyword)
      return false if difficulty_keyword.nil?

      context.game = @factory.create_game(context.user, difficulty_keyword)
      true
    end
  end
end
