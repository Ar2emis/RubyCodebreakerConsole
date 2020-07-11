# frozen_string_literal: true

module CodebreakerConsole
  class PlayState < GameState
    HINT_COMMAND = 'hint'

    def execute
      puts I18n.t(:play_message, hint_command: HINT_COMMAND, exit_command: EXIT_COMMAND)

      command = gets.chomp
      context.transit_to(manage_command(command).new)
    end

    private

    def manage_command(command)
      case command
      when EXIT_COMMAND then ExitState
      when HINT_COMMAND then give_hint
      else handle_guess(command)
      end
    end

    def give_hint
      begin
        puts(I18n.t(:hint_message, digit: context.game.take_hint))
      rescue Codebreaker::NoHintsLeftError
        puts(I18n.t(:no_hints_left_message))
      end

      self.class
    end

    def handle_guess(code)
      guess = Codebreaker::Guess.new(code)
      manage_turn(guess)
    rescue Codebreaker::InvalidStringLengthError, Codebreaker::NonNumericStringError
      puts(I18n.t(:wrong_command_message))
      self.class
    end

    def manage_turn(guess)
      response = context.game.make_turn(guess)

      puts(I18n.t(:coincidence_message, match: response[:result]))

      case response[:status]
      when Codebreaker::Game::WIN_STATUS then WinState
      when Codebreaker::Game::LOSE_STATUS then LoseState
      else self.class
      end
    end
  end
end
