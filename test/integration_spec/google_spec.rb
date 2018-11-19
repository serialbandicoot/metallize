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

  config.before(:all) do
    @metz = Metallize.new
  end

  config.after(:all) do
    @metz.quit
  end

end

describe '#Sainsburys' do

  before(:each) do
    @page = @metz.get 'http://google.com'
  end

  it 'should open an external site' do
    expect(@page.title).to eq 'Google'
  end

  it 'should check the readme.md example 1' do
    form = @page.form_with(name: 'f')
    form['q'] = 'Metallize Github'
    search_page = form.submit('Google Search', { instance: 1 })
    expect(search_page.title).to eq 'Metallize Github - Google Search'
  end

  it 'should check the readme.md example 2' do
    mech = @metz.to_mechanize
    expect(mech.title).to eq 'Google'
    expect(mech.class).to eq Mechanize::Page
  end

end