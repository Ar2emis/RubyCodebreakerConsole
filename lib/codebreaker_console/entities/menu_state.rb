# frozen_string_literal: true

module CodebreakerConsole
  class MenuState < GameState
    START_COMMAND = I18n.t(:start_command)
    RULES_COMMAND = I18n.t(:rules_command)
    STATS_COMMAND = I18n.t(:stats_command)

    def execute
      puts(I18n.t(:greeting))
      puts(I18n.t(:menu, start: START_COMMAND, rules: RULES_COMMAND, stats: STATS_COMMAND, exit: EXIT_COMMAND))
      command = user_input
      context.transit_to(manage_command(command))
    end

    private

    def manage_command(command)
      case command
      when START_COMMAND then return RegistrationState.new
      when RULES_COMMAND then puts(I18n.t(:rules))
      when STATS_COMMAND then put_statistic
      else
        puts I18n.t(:wrong_command_message)
      end

      self
    end

    def put_statistic
      puts(I18n.t(:statistic_title))

      stats = Codebreaker::Game.user_statistic
      return puts(I18n.t(:empty_statistic)) if stats.empty?

      formated_stats = stats.map.with_index { |stat, index| I18n.t(:statistic_body, **stats_to_hash(index, stat)) }.join
      puts(formated_stats)
    end

    def stats_to_hash(index, stat)
      {
        rating: index + 1,
        name: stat.user.name,
        difficulty: stat.difficulty.name,
        total_attempts: stat.difficulty.attempts,
        used_attempts: stat.attempts,
        total_hints: stat.difficulty.hints,
        used_hints: stat.hints
      }
    end
  end
end
