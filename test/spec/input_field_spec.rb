require_relative 'spec_helper'

describe '#HTML Element Input Field' do

  before(:each) do
    file = File.join(File.dirname(__FILE__),"../","htdocs/input_field.html")
    @page = @metz.get "file://#{file}"
  end

  it 'should contain an input field of type text' do
    text_field = @page.forms.first.fields.first
    expect(text_field.type).to eq 'text'
  end

  it 'should contain an input field with a name attribute' do
    text_field = @page.forms.first.fields.first
    expect(text_field.name).to eq 'input_name'
  end

  it 'should contain an input field with a value attribute' do
    text_field = @page.forms.first.fields.first
    expect(text_field.value).to eq 'input value'
  end

  it 'should contain an input field with a selenium-webdriver node attribute' do
    text_field = @page.forms.first.fields.first
    expect(text_field.node.attribute('type')).to eq 'text'
  end

  it 'should be able to change the value' do
    form = @page.forms.first
    form['input_name'] = 'new input value'
    form.fill_in_field_data
    form = @page.forms.first
    expect(form['input_name']).to eq 'new input value'
  end

end
