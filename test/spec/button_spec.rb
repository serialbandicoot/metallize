require 'spec_helper'

describe '#HTML Element Button' do

  before(:each) do
    file = File.join(File.dirname(__FILE__),"../","htdocs/button.html")
    @page = @metz.get "file://#{file}"
  end

  it 'should submit button when clicked' do
    form = @page.forms.first
    form['input_name'] = 'new input value'
    form.submit
    form = @page.forms.first
    expect(form['input_name']).to eq 'input value'
  end

  it 'should display a button on the form' do
    form = @page.forms.first
    expect(form.buttons.count).to eq 1
  end

  it 'should display a button with name attribute' do
    form   = @page.forms.first
    button = form.buttons.first
    expect(button.name).to eq "submit"
  end

  it 'should display a button with name attribute' do
    form   = @page.forms.first
    button = form.buttons.first
    expect(button.name).to eq "submit"
  end

  it 'should display a button with type attribute' do
    form   = @page.forms.first
    button = form.buttons.first
    expect(button.type).to eq "submit"
  end

  it 'should display a button with value attribute' do
    form   = @page.forms.first
    button = form.buttons.first
    expect(button.value).to eq "Submit"
  end

  it 'should display a button with selenium-webdriver node attribute' do
    form   = @page.forms.first
    button = form.buttons.first
    expect(button.node.attribute('type')).to eq "submit"
  end

end