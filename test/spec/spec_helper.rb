require 'metallize'
require 'rubygems'
require 'webrick'

include WEBrick

RSpec.configure do |config|
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.before(:all) do
    browser = [:chrome, :firefox].sample
    puts "Used Browser: #{browser}"
    @metz = Metallize.new(browser)
  end

  config.after(:all) do
    @metz.quit
  end

end
