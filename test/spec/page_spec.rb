require 'spec_helper'

describe '#HTML Page' do

  before(:each) do
    @file = File.join(File.dirname(__FILE__),"../","htdocs/page.html")
    @page = @metz.get "file://#{@file}"
  end

  it 'should display the page title' do
    expect(@page.title).to eq 'Metallize Test Page'
  end

  it 'should display the page url' do
    expect(@page.uri.path).to include("htdocs/page.html")
  end

  it 'should display a H1 Tag' do
    expect(@page.at('h1').text).to eq 'H1'
    expect(@page.at('h1').content).to eq 'H1'
  end

  it 'should display a H2 Tag' do
    expect(@page.at('h2').text).to eq 'H2'
    expect(@page.at('h2').content).to eq 'H2'
  end

  it 'should display a H3 Tag' do
    expect(@page.at('h3').text).to eq 'H3'
    expect(@page.at('h3').content).to eq 'H3'
  end

  it 'should display a H4 Tag' do
    expect(@page.at('h4').text).to eq 'H4'
    expect(@page.at('h4').content).to eq 'H4'
  end

  it 'should display a H5 Tag' do
    expect(@page.at('h5').text).to eq 'H5'
    expect(@page.at('h5').content).to eq 'H5'
  end

  it 'should display a Span Tag' do
    expect(@page.at('Span').text).to eq 'Span'
    expect(@page.at('Span').content).to eq 'Span'
  end

  it 'should display a div tag' do
    expect(@page.at('#div_id').text).to eq 'DIV Tag'
    expect(@page.at('#div_id').content).to eq 'DIV Tag'
  end

  it 'should display a form on the page' do
    expect(@page.forms.count).to be > 0
  end

end