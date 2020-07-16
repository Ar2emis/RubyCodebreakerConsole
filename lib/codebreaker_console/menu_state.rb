# frozen_string_literal: true

module CodebreakerConsole
  class MenuState < GameState
    START_COMMAND = 'start'
    RULES_COMMAND = 'rules'
    STATS_COMMAND = 'stats'

    def execute
      puts I18n.t(:menu, start: START_COMMAND, rules: RULES_COMMAND, stats: STATS_COMMAND, exit: EXIT_COMMAND)

      command = user_input
      context.transit_to(manage_command(command))
    end

    private

    def manage_command(command)
      case command
      when START_COMMAND then RegistrationState.new
      when RULES_COMMAND then RulesState.new
      when STATS_COMMAND then StatsState.new
      else
        puts I18n.t(:wrong_command_message)
        self
      end
    end
  end
end
