require_relative 'spec_helper'

describe '#HTML Element Checkboxes' do

  before(:each) do
    file = File.join(File.dirname(__FILE__),"../","htdocs/checkbox.html")
    @page = @metz.get "file://#{file}"
  end

  it 'should display checkboxes' do
    form = @page.forms.first
    expect(form.checkboxes.count).to eq 3
  end

  it 'should be click-able by position' do
    form = @page.forms.first
    form.checkboxes_with(name: 'animal').last.click
    form = @page.forms.first
    checkbox = form.checkboxes_with(name: 'animal').last
    expect(checkbox.checked).to eq true
  end

end
