# frozen_string_literal: true

require 'bundler'
Bundler.setup
require 'codebreaker'
require 'i18n'
I18n.load_path << Dir[File.expand_path('config/locales') + '/*.yml']

require_relative 'game_state'
require_relative 'greeting_state'
require_relative 'menu_state'
require_relative 'play_state'
require_relative 'rules_state'
require_relative 'stats_state'
require_relative 'exit_state'
require_relative 'registration_state'
require_relative 'difficulty_state'
require_relative 'win_state'
require_relative 'lose_state'
require_relative 'restart_state'
require_relative 'game_console'
