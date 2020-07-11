# frozen_string_literal: true

module CodebreakerConsole
  class GameState
    EXIT_COMMAND = 'exit'

    attr_accessor :context

    def execute
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end
  end
end
