# frozen_string_literal: true

module CodebreakerConsole
  class RulesState < GameState
    def execute
      puts(I18n.t(:rules))
      context.transit_to(MenuState.new)
    end
  end
end
