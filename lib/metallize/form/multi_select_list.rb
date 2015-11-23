class Metallize::Form::MultiSelectList < Metallize::Form::Field

  extend Metallize::ElementMatcher

  attr_accessor :options

  def initialize node
    value    = []
    @options = []

    # parse
    node.find_elements(:tag_name, 'option').each do |n|
      @options << Metallize::Form::Option.new(n, self)
    end

    super node, value

  end

  elements_with :option

  # Select no options
  def select_none
    @value = []
    options.each { |o| o.untick }
  end

  def value=(values)
    select_none
    [values].flatten.each do |value|
      option = options.find { |o| o.value == value }
      if option.nil?
        @value.push(value)
      else
        option.node.click
      end
    end
  end

  # Get a list of all selected options
  def selected_options
    @options.find_all { |o| o.selected? }
  end

  def value
    value = []
    value.concat @value
    value.concat selected_options.map { |o| o.value }
    value.first
  end

end

