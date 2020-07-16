# frozen_string_literal: true

module CodebreakerConsole
  class GameState
    EXIT_COMMAND = 'exit'

    attr_accessor :context

    def execute
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    private

    def user_input
      command = gets.chomp.downcase
      context.transit_to(ExitState.new) if command == EXIT_COMMAND
      command
    end
  end
end
