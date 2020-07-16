# frozen_string_literal: true

module CodebreakerConsole
  class PlayState < GameState
    HINT_COMMAND = 'hint'

    def execute
      puts I18n.t(:play_message, hint_command: HINT_COMMAND, exit_command: EXIT_COMMAND)
      context.transit_to(manage_command(user_input).new)
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
      self.class
    end

    def manage_turn(code)
      response = context.game.make_turn(Codebreaker::Guess.new(code))

      puts(I18n.t(:coincidence_message, match: response[:result]))

      case response[:status]
      when Codebreaker::Game::WIN_STATUS then WinState
      when Codebreaker::Game::LOSE_STATUS then LoseState
      else self.class
      end
    rescue Codebreaker::InvalidStringLengthError, Codebreaker::NonNumericStringError
      puts(I18n.t(:wrong_command_message))
      self.class
    end
  end
end
