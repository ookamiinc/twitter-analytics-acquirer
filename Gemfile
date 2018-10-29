# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '2.4.4'
gem 'derailed', group: :development
gem 'byebug', platforms: %i[mri mingw x64_mingw]
gem 'google_drive'
gem 'mechanize'
gem 'mysql2'
