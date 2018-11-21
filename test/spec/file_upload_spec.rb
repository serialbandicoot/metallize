require_relative 'spec_helper'

describe '#HTML Element File Uploads' do

  before(:each) do
    file = File.join(File.dirname(__FILE__), '../', 'htdocs/file_upload.html')
    @page = @metz.get "file://#{file}"
  end

  it 'should display file_upload' do
    file_uploads = @page.forms.first.fields.first
    expect(file_uploads.type).to eq 'file'
  end

  it 'should upload the file' do
    image = File.expand_path(File.join(File.dirname(__FILE__), '../', 'data/serialbandicoot.png'))
    file_uploads = @page.forms.first
    file_uploads['pic'] = image
    page = file_uploads.submit
    expect(page.title).to eq 'file:///action_page.php?pic=serialbandicoot.png'
  end

  it 'should not blow up after a pretty print' do
    file_uploads = @page.forms.first
    pp file_uploads
  end

end
