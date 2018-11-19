class Metallize::Form::Field

  attr_accessor :name, :value, :node, :type

  def initialize(node, value = node.attribute('value'))
    @node  = node
    @name  = node.attribute('name')
    @type  = node.attribute('type')
    @value = value
  end

  def inspect # :nodoc:
    "[%s:0x%x type: %s name: %s value: %s]" % [
        self.class.name.sub(/Metallize::Form::/, '').downcase,
        object_id, type, name, value
    ]
  end

end
