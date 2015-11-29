require 'spec_helper'

describe '#HTML Element Form' do

  before(:each) do
    file = File.join(File.dirname(__FILE__),"../","htdocs/form.html")
    @page = @metz.get "file://#{file}"
  end

  it 'should display the field contents of the form' do
    @form = @page.forms.first
    expect(@form.fields.count).to eq 2
  end

  # it 'should display form by name' do
  #   # form = @page.form['post_inputs']
  #   # pp form
  # end

end