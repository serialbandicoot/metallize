require_relative 'spec_helper'

describe '#HTML Element Image' do

  before(:each) do
    file = File.join(File.dirname(__FILE__),'../','htdocs/image.html')
    @page = @metz.get "file://#{file}"
  end

  it 'should display an image' do
    expect(@page.images.count).to eq 1
  end

  it 'should display the image alt tag' do
    image = @page.images.first
    expect(image.alt).to eq 'uksa alt'
  end

  it 'should display the image src tag' do
    image = @page.images.first
    expect(image.src).to include('uksa.png')
  end

  it 'should display the image title' do
    image = @page.images.first
    expect(image.title).to eq 'uksa image'
  end

  it 'should display the image id' do
    image = @page.images.first
    expect(image.dom_id).to eq 'img_id'
  end

  it 'should display the image class' do
    image = @page.images.first
    expect(image.dom_class).to eq 'img_class'
  end

  it 'should display the image caption' do
    image = @page.images.first
    expect(image.caption).to eq 'uksa image'
  end

  it 'should find image_with alt' do
    image = @page.image_with(alt: 'uksa alt')
    expect(image.alt).to eq 'uksa alt'
  end

  it 'should find image_with title' do
    image = @page.image_with(title: 'uksa image')
    expect(image.title).to eq 'uksa image'
  end

  it 'should find image_with id' do
    image = @page.image_with(id: 'img_id')
    expect(image.title).to eq 'uksa image'
  end

  it 'should find image_with class' do
    image = @page.image_with(class: 'img_class')
    expect(image.title).to eq 'uksa image'
  end

  it 'should show the image height' do
    image = @page.images.first
    expect(image.height).to eq '128'
  end

  it 'should show the image width' do
    image = @page.images.first
    expect(image.width).to eq '128'
  end

  it 'should show the url' do
    image = @page.images.first
    expect(image.uri.path).to include('image.html')
  end

end

