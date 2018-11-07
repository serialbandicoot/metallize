require_relative 'remote_spec_helper'

describe '#HTML Element Base' do

  before(:each) do
    @page = @metz.get 'http://google.com'
  end

  it 'should open a remote browser' do
    expect(@page.title).to eq 'Google'
  end

end