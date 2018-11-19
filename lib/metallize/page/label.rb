class Metallize::Page::Label

  attr_reader :label
  attr_reader :text
  attr_reader :page
  alias :to_s :text

  def initialize(label, page)
    @label = label
    @text = label.text
    @page = page
  end

  # todo: Add For code in.
  def for
    (id = @label['for']) && page.search("##{id}") || nil
  end

end