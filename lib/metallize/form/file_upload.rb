class Metallize::Form::FileUpload < Metallize::Form::Field
  attr_accessor :file_name # File name
  attr_accessor :mime_type # Mime Type (Optional)

  alias :file_data :value
  alias :file_data= :value=

  def initialize node, file_name
    @file_name = Metallize::Util.html_unescape(file_name)
    @file_data = nil
    @node      = node
    super(node, @file_data)
  end
end