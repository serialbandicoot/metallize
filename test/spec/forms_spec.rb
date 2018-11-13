require_relative 'spec_helper'

describe '#HTML Element Form' do

  before(:each) do
    file = File.join(File.dirname(__FILE__), '../', 'htdocs/forms.html')
    @page = @metz.get "file://#{file}"
  end

  it 'should display the forms' do
    @forms = @page.forms
    expect(@forms.count).to eq 2
  end

  it 'should display forms with name' do
    @forms = @page.forms_with(name: 'name_input_one')
    expect(@forms.count).to eq 1
  end

  it 'should display form with name' do
    @form = @page.form_with(name: 'name_input_one')
    expect(@form.name).to eq 'name_input_one'
  end

end