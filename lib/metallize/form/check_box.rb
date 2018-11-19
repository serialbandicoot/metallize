class Metallize::Form::CheckBox < Metallize::Form::RadioButton

def query_value
    [[@name, @value || "on"]]
  end

  def inspect # :nodoc:
    "[%s:0x%x type: %s name: %s value: %s]" % [
        self.class.name.sub(/Mechanize::Form::/, '').downcase,
        object_id, type, name, checked
    ]
  end

end
