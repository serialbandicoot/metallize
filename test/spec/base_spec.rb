require 'spec_helper'

describe '#HTML Element Base' do

  before(:each) do
    file = File.join(File.dirname(__FILE__),'../','htdocs/base.html')
    @page = @metz.get "file://#{file}"
  end

  it 'should contain a base element' do
    expect(@page.bases.count).to eq 1
  end

  it 'should contain a base target' do
    base = @page.bases.first
    expect(base.target).to eq '_blank'
  end

end