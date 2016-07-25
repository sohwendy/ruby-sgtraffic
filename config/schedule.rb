job_type :command, "cd :path && :task :output"
set :output, error: 'tmp/cron_error_log.log', standard: 'tmp/cron_log.log'

weekday = (8..12).map{ |time| "#{time}:00".rjust(5, '0') } + (16..23).map{ |time| "#{time}:00" }
weekend = weekday + (8..11).map{ |time| "#{time}:30".rjust(5, '0') } + (16..22).map{ |time| "#{time}:30" }

every :weekday, at: weekday do
  command 'ruby image_scraper.rb'
end

every :weekend, at: weekend do
  command 'ruby image_scraper.rb'
end
