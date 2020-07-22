# frozen_string_literal: true

module CodebreakerConsole
  class StatsState < GameState
    def execute
      puts(I18n.t(:statistic_title))
      puts(formated_statistic)
      context.transit_to(MenuState.new)
    end

    private

    def formated_statistic
      statistic = Codebreaker::Game.user_statistic
      return I18n.t(:empty_statistic) if statistic.empty?

      statistic.map.with_index { |stats, index| I18n.t(:statistic_body, **interpolation_hash(index, stats)) }.join
    end

    def interpolation_hash(index, stats)
      {
        rating: index + 1,
        name: stats.user.name,
        difficulty: stats.difficulty.name,
        total_attempts: stats.difficulty.attempts,
        used_attempts: stats.attempts,
        total_hints: stats.difficulty.hints,
        used_hints: stats.hints
      }
    end
  end
end
