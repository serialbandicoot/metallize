require 'spec_helper'

describe '#HTML Element Link' do

  before(:each) do
    file = File.join(File.dirname(__FILE__),"../","htdocs/link.html")
    @page = @metz.get "file://#{file}"
  end

  it 'should display href' do
    link = @page.link_with(text: 'UKSA')
    expect(link.href).to eq 'http://uksa.eu/'
  end

  it 'should should be found by its dom id' do
    link = @page.link_with(id: 'uksa_id')
    expect(link.text).to eq 'UKSA'
  end

  it 'should should be found by its id' do
    link = @page.link_with(id: 'uksa_id')
    expect(link.text).to eq 'UKSA'
  end

  it 'should should be found by its class' do
    link = @page.link_with(class: 'uksa_class')
    expect(link.text).to eq 'UKSA'
  end

  it 'should go to the location after being clicked' do
    page = @page.link_with(text: 'UKSA').click
    expect(page.title).to include('UK Software Alliance')
  end

end
