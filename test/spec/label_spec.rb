require 'spec_helper'

describe '#HTML Element Label' do

  before(:each) do
    file = File.join(File.dirname(__FILE__),"../","htdocs/label.html")
    @page = @metz.get "file://#{file}"
  end

  it 'should display a label' do
    label = @page.labels.first
    expect(label.text).to eq 'Label'
  end

end
