require 'spec_helper'

describe '#HTML Element Radio Button' do

  before(:each) do
    file = File.join(File.dirname(__FILE__),"../","htdocs/radio.html")
    @page = @metz.get "file://#{file}"
  end

  it 'should display radio buttons' do
    form = @page.forms.first
    expect(form.radiobuttons.count).to eq 3
  end

  it 'should display radio button with' do
    form = @page.forms.first
    form.radiobuttons_with(name: 'country').each do |field|
      expect(field.type).to eq 'radio'
    end
  end

  it 'should display a checked/unchecked value' do
    form = @page.forms.first
    radiobutton = form.radiobuttons_with(name: 'country')
    expect(radiobutton.first.checked).to eq true
    expect(radiobutton.last.checked).to eq false
  end

  it 'should be click-able by value' do
    form = @page.forms.first
    form.radiobuttons_with(name: 'country').with_value("fr_FR").click
    form = @page.forms.first
    radiobutton = form.radiobuttons_with(name: 'country')
    expect(radiobutton.last.checked).to eq true
  end

  it 'should be click-able by position' do
    form = @page.forms.first
    form.radiobuttons_with(name: 'country').last.click
    form = @page.forms.first
    radiobutton = form.radiobuttons_with(name: 'country')
    expect(radiobutton.last.checked).to eq true
  end

end


