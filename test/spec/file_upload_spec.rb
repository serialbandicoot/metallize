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

end
