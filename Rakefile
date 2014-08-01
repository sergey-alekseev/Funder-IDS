require_relative './lib/funders'
require 'moped'

class FundersManager
  include Funders
end

ROOT=File.dirname(__FILE__)
json_filename = File.join(ROOT, "data.json")
xls_filename = File.join(ROOT, "public/funders.xls")
csv_filename = File.join(ROOT, "public/funders.csv")


namespace "funders" do
  task "update" do
    [json_filename, xls_filename, csv_filename].each{|file|File.delete(file) if File.exists? file}
    FundersManager.new.get_funders_and_save(json_filename, csv_filename, xls_filename)
  end

  task "save" do
    funders = FundersManager.new.get_funders_and_save(json_filename, csv_filename, xls_filename)
    session = Moped::Session.new([ "127.0.0.1:27017" ])
    session.use "funders"

    session.with(safe: true) do |db|
      time = Time.now
      db[:ids].insert(year: time.year, day: time.day, month: time.month,  funders: funders)
    end
  end
end
