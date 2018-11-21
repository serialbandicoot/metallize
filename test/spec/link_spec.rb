require_relative 'spec_helper'

describe '#HTML Element Link' do

  before(:each) do
    file = File.join(File.dirname(__FILE__),"../","htdocs/link.html")
    @page = @metz.get "file://#{file}"
  end

  it 'should display href' do
    link = @page.link_with(text: 'UKSA')
    expect(link.href).to include '/result.html'
  end

  it 'should be found by its dom id' do
    link = @page.link_with(id: 'uksa_id')
    expect(link.text).to eq 'UKSA'
  end

  it 'should be found by its id' do
    link = @page.link_with(id: 'uksa_id')
    expect(link.text).to eq 'UKSA'
  end

  it 'should be found by its class' do
    link = @page.link_with(class: 'uksa_class')
    expect(link.text).to eq 'UKSA'
  end

  it 'should be found with href' do
    file = File.join(File.dirname(__FILE__),"../","htdocs/link_href.html")
    page = @metz.get "file://#{file}"
    link = page.link_with(href: '/articles-main')
    expect(link.text).to eq 'UKSA'
  end

  it 'should go to the location after being clicked' do
    link = @page.links_with(text: 'UKSA').first
    page = link.click
    expect(page.title).to include('Metallize Results Title')
  end

  it 'should contain an input field with a selenium-webdriver type attribute' do
    a = @page.link_with(text: 'UKSA')
    expect(a.link.attribute('type')).to eq 'text/css'
  end

  it 'should contain an input field with a selenium-webdriver tag_name attribute' do
    a = @page.link_with(text: 'UKSA')
    expect(a.link.tag_name).to eq 'a'
  end

  it 'should contain a base target' do
    a = @page.link_with(text: 'UKSA')
    expect(a.target).to eq '_self'
  end

  it 'should go to the location after being clicked' do
    link = @page.links_with(text: 'UKSA').first
    page = link.click
    expect(page.title).to include('Metallize Results Title')
  end

end
