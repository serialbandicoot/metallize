require 'spec_helper'

describe '#HTML Element Frameset' do

  before(:each) do
    file = File.join(File.dirname(__FILE__),"../","htdocs/iframe.html")
    @page = @metz.get "file://#{file}"
  end

  it 'should contains a iframe' do
    iframes = @page.iframes
    expect(iframes.count).to eq 1
  end

end
