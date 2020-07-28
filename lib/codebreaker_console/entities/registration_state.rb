# frozen_string_literal: true

module CodebreakerConsole
  class RegistrationState < GameState
    def execute
      ask_username
      ask_difficulty
      context.game = Codebreaker::Game.new(@difficulty, @user)
      context.game.start
      context.transit_to(PlayState.new)
    end

    private

    def ask_username
      loop do
        puts I18n.t(:user_name_message)
        @user = Codebreaker::User.new(user_input)
        return if @user.valid?

        puts(I18n.t(:invalid_user_name_message))
      end
    end

    def ask_difficulty
      loop do
        puts I18n.t(:difficulty_message, difficulties: difficulties.keys.join(', '))
        @difficulty = difficulties[user_input]
        return unless @difficulty.nil?

        puts(I18n.t(:invalid_difficulty_message))
      end
    end

    def difficulties
      {
        I18n.t(:easy_difficulty) => Codebreaker::Difficulty.difficulties(:easy),
        I18n.t(:medium_difficulty) => Codebreaker::Difficulty.difficulties(:medium),
        I18n.t(:hell_difficulty) => Codebreaker::Difficulty.difficulties(:hell)
      }
    end
  end
end
