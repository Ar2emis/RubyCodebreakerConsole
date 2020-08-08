# frozen_string_literal: true

module CodebreakerConsole
  class GameState
    EXIT_COMMAND = I18n.t(:exit_command)
    YES = I18n.t(:yes_command)
    attr_accessor :context

    def execute
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    private

    def user_input
      command = gets.chomp
      return command unless command == EXIT_COMMAND

      puts(I18n.t(:exit_message))
      exit
    end
  end
end
