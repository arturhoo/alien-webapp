require 'sinatra'
require 'alien'
require 'better_errors'
require 'faye'
require 'json'
require 'sucker_punch'
require_relative 'my_alien'

class MyAlienNotifierJob
  include SuckerPunch::Job

  def perform(logger, faye_client)
    logger.info 'Enabling auto mode'
    MyAlien::Notifier.enable
    logger.info 'Disabled auto mode'
    faye_client.publish '/alien', text: 'disabled'
  end
end

class MyApp < Sinatra::Base

  configure :development do
    use BetterErrors::Middleware
    BetterErrors.application_root = File.expand_path('..', __FILE__)
    enable :logging
  end
  set :public_folder, 'assets/'
  set :faye_client, Faye::Client.new('http://localhost:9000/faye')

  get '/' do
    erb :application, locals: { partial: :_index }
  end

  get '/manual' do
    erb :application, locals: { partial: :_manual }
  end

  get '/auto' do
    erb :application, locals: { partial: :_auto }
  end

  get '/tags.json' do
    content_type :json
    tag_list = MyAlien::TagList.retrieve
    tag_list << '--'
    tag_list.to_json
  end

  post '/api' do
    request.body.rewind
    data = request.body.read
    parsed_msg = parse_msg(data)
    settings.faye_client.publish '/alien', text: parsed_msg
  end

  post '/job' do
    MyAlienNotifierJob.new.async.perform(logger, settings.faye_client)
    'From sinatra: auto mode enabled'
  end
end

def parse_msg(msg)
  parsed_lines = []
  msg.split("\n").each do |l|
    parsed_lines << l if l.include? 'Tag:'
    parsed_lines << l if l.include? '#Time'
  end
  parsed_lines << '--'
  parsed_lines.join "\n"
end
