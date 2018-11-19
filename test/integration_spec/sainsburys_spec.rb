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
    browser = [:chrome].sample
    puts "Used Browser: #{browser}"
    @metz = Metallize.new(browser) {|m|
      m.timeout = 5
    }
  end

  config.after(:all) do
    @metz.quit
  end

end

describe '#Sainsburys' do

  before(:each) do
    @url  = 'http://www.sainsburys.co.uk/shop/gb/groceries'
    @page = @metz.get @url
  end

  it 'should show welcome page' do
    expect(@page.title).to eq "Sainsbury's online Grocery Shopping and Fresh Food Delivery"
  end

  it 'should search for some groceries' do
    @forms = @page.form_with(name: 'sol_search')
    @forms['searchTerm'] = 'Apples'
    @page = @forms.submit
    expect(@page.title).to eq 'Search results'
    expect(@page.at('.productLister > li').attribute('outerHTML').to_s.scan('li').count).to be >  10
  end

  it 'should link to the multi product search page' do
    shopping_list = @page.link_with(text: 'Multi-product search').click
    expect(shopping_list.title).to eq 'Shopping List'
  end

  it 'should set the timeout' do
    expect(@metz.timeout).to eq 5
  end

  it 'should set switch metallize to mechanize' do
    @mech = @metz.to_mechanize
    @forms = @mech.form_with(name: 'sol_search')
    @forms['searchTerm'] = 'Apples'
    @page = @forms.submit
    expect(@page.title).to eq 'Search results'
    expect(@page.css('#productLister > ul').to_s.scan('<li>').count).to be > 10
  end

  it 'should convert mechanize to metallize using a Mechanize::Page object' do
    # Create a Mechanize object and locate a new page
    agent = Mechanize.new
    agent_page  = agent.get(@url)
    form        = agent_page.form_with(name: 'sol_search')
    form['searchTerm'] = 'Apples'
    sol_page    = form.submit

    #Pass the page to from mechanize and return a new metz
    @metz = @metz.from_mechanize(sol_page)
    expect(@metz.title).to eq 'Search results'
  end

  it 'should convert mechanize to metallize using a Mechanize object' do
    # Create a Mechanize object and locate a new page
    mechanize = Mechanize.new
    agent_page  = mechanize.get(@url)
    form        = agent_page.form_with(name: 'sol_search')
    form['searchTerm'] = 'Apples'
    form.submit

    #Pass the page to from mechanize and return a new metz
    @metz = @metz.from_mechanize(mechanize)
    expect(@metz.title).to eq 'Search results'
  end

  it 'should convert mechanize to metallize using a Mechanize::Agent object' do
    # Create a Mechanize object and locate a new page
    mechanize = Mechanize.new
    agent_page  = mechanize.get(@url)
    form        = agent_page.form_with(name: 'sol_search')
    form['searchTerm'] = 'Apples'
    form.submit

    #Pass the page to from mechanize and return a new metz
    @metz = @metz.from_mechanize(mechanize.agent)
    expect(@metz.title).to eq 'Search results'
  end

end