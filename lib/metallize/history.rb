##
# This class manages history for your mechanize object.

class Metallize::History < Array

  attr_accessor :index

  def initialize
    @index = 0
  end

  def push(value)
    super value
    @index += 1
    self
  end

  alias :<< :push

end

