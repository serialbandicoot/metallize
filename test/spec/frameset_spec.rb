require 'spec_helper'

describe '#HTML Element Frameset' do

  before(:each) do
    file = File.join(File.dirname(__FILE__),"../","htdocs/frameset.html")
    @page = @metz.get "file://#{file}"
  end

  it 'should contains several frames in a frameset' do
    frames = @page.frames
    expect(frames.count).to eq 2
  end

end
