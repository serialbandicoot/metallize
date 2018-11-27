require_relative '../../lib/metallize'
require 'rubygems'
require 'webrick'

include WEBrick

RSpec.configure do |config|
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.after(:all) do
    @metz.quit
  end

end

describe '#Remote Browser' do

  after(:each) do
    @metz.shutdown
  end

  it 'should open a remote browser with desired_capabilities and url' do
    @metz = Metallize.new(:chrome, { desired_capabilities: :chrome, url: 'http://localhost:4444/wd/hub' })
    @page = @metz.get('http://google.com')
    expect(@page.title).to eq 'Google'
  end

  it 'should open a remote browser with only desired_capabilities' do
    @metz = Metallize.new(:chrome, { desired_capabilities: :chrome })
    @page = @metz.get('http://google.com')
    expect(@page.title).to eq 'Google'
  end

end