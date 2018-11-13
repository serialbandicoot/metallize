require_relative 'spec_helper'

describe '#Sainsburys' do

  before(:each) do
    @page = @metz.get 'http://www.sainsburys.co.uk/shop/gb/groceries'
  end

  it 'should show welcome page' do
    expect(@page.title).to eq "Sainsbury's online Grocery Shopping and Fresh Food Delivery"
  end

  it 'should search for some groceries' do
    @forms = @page.form_with(name: 'sol_search')
    @forms['searchTerm'] = 'Apples'
    @page = @forms.submit
    expect(@page.ats(css: '.productLister > li').length).to be > 10
  end

end