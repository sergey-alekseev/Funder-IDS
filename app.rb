require 'sinatra'
require 'json'
require 'haml'
require 'coffee_script'
require 'csv'
require 'sheets'
require 'moped'

require_relative './lib/funders.rb'
require_relative './lib/time.rb'

ROOT=File.dirname(__FILE__)
json_filename = File.join(ROOT, "data.json")
xls_filename = File.join(ROOT, "public/funders.xls")
csv_filename = File.join(ROOT, "public/funders.csv")

session = Moped::Session.new([ "127.0.0.1:27017" ])
session.use "funders"

set :port, 3456

helpers do
  include Funders


  def funders_from_db(session)
    criteria = Time.now.to_hash(only: [:day, :month, :year])
    if session[:ids].find(criteria).count > 0
      funders = session[:ids].find(criteria).first.to_hash[:funders]
    else
      funders = session[:ids].find().first.to_hash[:funders] # For time range since 0.00am to 2.00am
    end
  end
end


get '/'  do
  funders = funders_from_db(session)
  haml :funders_ids, locals: { funders: funders }
end

get '/json', provides: :json  do
  funders = funders_from_db(session)

  funders.to_json
end

get '/funders_list_ids.json' do
  funders_list = to_list(funders_from_db(session))
  funders_list.to_json
end
