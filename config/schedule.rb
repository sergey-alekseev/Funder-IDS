
every :day, :at => '2:00am' do
  rake "funders:update"
  rake "funders:save"
end

