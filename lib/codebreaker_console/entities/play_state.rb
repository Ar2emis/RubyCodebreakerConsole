# frozen_string_literal: true

module CodebreakerConsole
  class PlayState < GameState
    HINT_COMMAND = I18n.t(:hint_command)

    def execute
      puts I18n.t(:play_message, hint_command: HINT_COMMAND, exit_command: EXIT_COMMAND)
      context.transit_to(manage_command(user_input))
    end

    private

    def manage_command(command)
      command == HINT_COMMAND ? give_hint : manage_turn(command)
    end

    def give_hint
      puts(I18n.t(:hint_message, digit: context.game.take_hint))
      self
    rescue Codebreaker::NoHintsLeftError
      puts(I18n.t(:no_hints_left_message))
      self
    end

    def manage_turn(code)
      guess = Codebreaker::Guess.new(code)
      if guess.valid?
        puts(I18n.t(:coincidence_message, match: context.game.make_turn(guess)))
        next_state
      else
        puts(I18n.t(:wrong_command_message))
        self
      end
    end

    def next_state
      if context.game.win?
        WinState.new
      elsif context.game.lose?
        LoseState.new
      else
        self
      end
    end
  end
end
