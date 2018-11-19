class Array

  def with_value(value)
    self.select {|a| a.value == value}.first
  end

end