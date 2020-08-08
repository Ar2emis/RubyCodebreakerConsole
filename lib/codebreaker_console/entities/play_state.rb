# frozen_string_literal: true

module CodebreakerConsole
  class PlayState < GameState
    HINT_COMMAND = I18n.t(:hint_command)

    def execute
      puts(I18n.t(:play_message, hint_command: HINT_COMMAND, exit_command: EXIT_COMMAND))
      manage_command(user_input)
      context.transit_to(next_state)
    end

    private

    def manage_command(command)
      command == HINT_COMMAND ? give_hint : make_turn(command)
    end

    def give_hint
      if @context.game.hints_amount.positive?
        puts(I18n.t(:hint_message, digit: context.game.take_hint))
      else
        puts(I18n.t(:no_hints_left_message))
      end
    end

    def make_turn(code)
      guess = Codebreaker::Guess.new(code)
      return puts(I18n.t(:wrong_command_message)) unless guess.valid?

      puts(I18n.t(:coincidence_message, match: context.game.make_turn(guess)))
    end

    def next_state
      context.game.win? || context.game.lose? ? ResultsState.new : self
    end
  end
end
