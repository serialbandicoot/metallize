class Metallize::Form::RadioButton < Metallize::Form::Field
  attr_accessor :checked

  attr_reader :form

  def initialize node, form
    @checked = !!node.attribute('checked')
    @form    = form
    super(node)
  end

  def click
    node.click
  end

end
