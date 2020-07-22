# frozen_string_literal: true

require 'bundler'
Bundler.setup
require 'codebreaker'

require 'i18n'
require_relative 'config/i18n_config'

require_relative 'entities/game_state'
require_relative 'entities/greeting_state'
require_relative 'entities/menu_state'
require_relative 'entities/play_state'
require_relative 'entities/rules_state'
require_relative 'entities/stats_state'
require_relative 'entities/exit_state'
require_relative 'entities/registration_state'
require_relative 'entities/difficulty_state'
require_relative 'entities/create_game_state'
require_relative 'entities/win_state'
require_relative 'entities/lose_state'
require_relative 'entities/restart_state'
require_relative 'entities/game_console'
