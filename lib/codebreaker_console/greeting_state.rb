# frozen_string_literal: true

module CodebreakerConsole
  class GreetingState < GameState
    def execute
      puts I18n.t(:greeting)

      context.transit_to(MenuState.new)
    end
  end
end
