class Metallize::Form::Option

  attr_reader :value, :selected, :text, :select_list, :node

  alias :selected? :selected

  def has_attribute?(node, attr)
    if node.attribute(attr)
      true
    else
      false
    end
  end

  def initialize(node, select_list)
    @node        = node
    @text        = node.attribute('innerText')
    @value       = node.attribute('value') || node.attribute('innerText')
    @selected    = has_attribute? node, 'selected'
    @select_list = select_list # The select list this option belongs to
  end


  # Select this option
  def select
    unselect_peers
    @selected = true
    # option = Selenium::WebDriver::Support::Select.new(node)
    # option
  end

  # Unselect this option
  def unselect
    @selected = false
  end

  alias :tick   :select
  alias :untick :unselect


  private
  def unselect_peers
    # return unless Mechanize::Form::SelectList === @select_list

    @select_list.select_none
  end

end
