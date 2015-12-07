# A Frame object wrapse a frame HTML element.  Frame objects can be treated
# just like Link objects.  They contain #src, the #link they refer to and a
# #name, the name of the frame they refer to.  #src and #name are aliased to
# #href and #text respectively so that a Frame object can be treated just like
# a Link.

class Metallize::Page::Frame < Metallize::Page::Link

  alias :src :href

  attr_reader :text
  alias :name :text

  def initialize(driver, frame, page)
    super(driver, frame, page)
    @frame = frame
    @text = frame.attribute('name')
    @href = frame.attribute('src')
    @content = nil
  end

  # todo : work out what to do with a frame!
  def content
    @content ||= @mech.get @href, [], page
  end

end

