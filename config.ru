require 'rubygems'
require 'sinatra'

set :run, false
set :env, :production

require 'main.rb'
run Sinatra.application
