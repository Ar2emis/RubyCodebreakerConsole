# frozen_string_literal: true

module CodebreakerConsole
  class ExitState < GameState
    def execute
      puts(I18n.t(:exit_message))
      gets.chomp
      abort
    end
  end
end
