# frozen_string_literal: true

require 'bundler'
Bundler.setup
require 'codebreaker'

require 'i18n'
require_relative 'config/i18n_config'

require_relative 'entities/game_state'
require_relative 'entities/menu_state'
require_relative 'entities/registration_state'
require_relative 'entities/play_state'
require_relative 'entities/results_state'
require_relative 'entities/game_console'
