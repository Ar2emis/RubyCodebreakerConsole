# frozen_string_literal: true

module CodebreakerConsole
  class PlayState < GameState
    HINT_COMMAND = 'hint'

    def execute
      puts I18n.t(:play_message, hint_command: HINT_COMMAND, exit_command: EXIT_COMMAND)
      context.transit_to(manage_command(user_input))
    end

    private

    def manage_command(command)
      command.downcase == HINT_COMMAND ? give_hint : manage_turn(command)
    end

    def give_hint
      begin
        puts(I18n.t(:hint_message, digit: context.game.take_hint))
      rescue Codebreaker::NoHintsLeftError
        puts(I18n.t(:no_hints_left_message))
      end
      self
    end

    def manage_turn(code)
      response = context.game.make_turn(Codebreaker::Guess.new(code))
      puts(I18n.t(:coincidence_message, match: response[:result]))
      next_state(response[:status])
    rescue Codebreaker::InvalidStringLengthError, Codebreaker::NonNumericStringError
      puts(I18n.t(:wrong_command_message))
      self
    end

    def next_state(status)
      case status
      when Codebreaker::Game::WIN_STATUS then WinState.new
      when Codebreaker::Game::LOSE_STATUS then LoseState.new
      else self
      end
    end
  end
end
