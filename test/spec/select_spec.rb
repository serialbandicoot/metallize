require 'spec_helper'

describe '#HTML Element Select' do

  before(:each) do
    file = File.join(File.dirname(__FILE__),"../","htdocs/select.html")
    @page = @metz.get "file://#{file}"
    @form = @page.forms.first
  end

  it 'should return list of Options' do
    options_value =  @form.field_with(name: 'numbers').options
    expect(options_value.count).to eq 6
  end

  it 'should return a list of Option Values' do
    options_value = @form.field_with(name: 'numbers').options.map(&:value)
    expect(options_value.count).to eq 6
  end

  it 'should return current value of option' do
    option_value = @form.field_with(name: 'numbers').value
    expect(option_value).to eq "4"
  end

  it 'should change when a new value is selected' do
    @form.field_with(name: 'numbers').value = '3'
    page = @page.forms.first
    option_value = page.field_with(name: 'numbers').value
    expect(option_value).to eq '3'
  end

  it 'should return the selected option' do
    option_value = @form.field_with(name: 'numbers').selected_options
    expect(option_value.first.selected).to eq true
  end

  it 'should inspect the option' do
    inspect = @form.field_with(name: 'numbers').inspect
    expect(inspect).to include('value: 4')
  end

end