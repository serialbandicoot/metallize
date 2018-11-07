require_relative 'spec_helper'

describe '#HTML Element Textarea' do

  before(:each) do
    file = File.join(File.dirname(__FILE__),"../","htdocs/textarea.html")
    @page = @metz.get "file://#{file}"
  end

  it 'should contain a textarea element' do
    textarea = @page.forms.first.fields.first
    expect(textarea.type).to eq 'textarea'
  end

end
