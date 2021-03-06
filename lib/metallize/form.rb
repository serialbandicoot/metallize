require_relative 'element_matcher'

class Metallize::Form

    extend Metallize::ElementMatcher

    include Metallize::SeleniumWebdriverWaiter

    attr_accessor :method, :action, :name

    attr_reader :fields, :buttons, :file_uploads, :radiobuttons, :checkboxes

    alias :elements :fields

    attr_reader :form_node
    attr_reader :page

    attr_reader :fields, :buttons

    attr_reader :metz, :driver

    alias :elements :fields

    def initialize(driver, form, metz)
      @driver = driver
      @form   = form
      @method = (@form.attribute('method') || 'GET').upcase
      @action = @form.attribute('action')
      @metz   = metz
      parse
    end

    def name
      @form.attribute('name')
    end

    def parse
      @fields       = []
      @buttons      = []
      @radiobuttons = []
      @checkboxes   = []

      form_node = @driver.find_elements(:tag_name, 'input')
      form_node.each do |node|
        type = (node.attribute('type') || 'text').downcase
        name = node.attribute('name')
        next if name.nil? && !%w[submit button image].include?(type)
        case type
          when 'checkbox'
            @checkboxes << CheckBox.new(node, self)
          when 'radio'
            @radiobuttons << RadioButton.new(node, self)
          when 'submit'
            @buttons << Submit.new(node)
          when 'button'
            @buttons << Button.new(node)
          when 'hidden'
            @fields << Hidden.new(node, node.attribute('value') || '')
          when 'text'
            @fields << Text.new(node, node.attribute('value') || '')
          when 'textarea'
            @fields << Textarea.new(node, node.attribute('value') || '')
          when 'file'
            @fields << FileUpload.new(node, nil)
          else
            @fields << Field.new(node, node.attribute('value') || '')
        end

      end

      form_node = driver.find_elements(:tag_name, 'textarea')
      form_node.each do |node|
        next unless node['name']
        @fields << Textarea.new(node)
      end

      form_node = driver.find_elements(:tag_name, 'select')
      form_node.each do |node|
        next unless node['name']
        @fields << SelectList.new(node)
      end

      form_node = driver.find_elements(:tag_name, 'button')
      form_node.each do |node|
        @buttons << Button.new(node)
      end

    end

    def has_value?(value)
      fields.find { |f| f.value == value }
    end

    # Returns all field names (keys) for this form
    def keys
      fields.map { |f| f.name }
    end

    # Returns all field values for this form
    def values
      fields.map { |f| f.value }
    end

    # Returns all buttons of type Submit
    def submits
      @submits ||= buttons.select { |f| f.class == Submit }
    end

    # Returns all buttons of type Reset
    def resets
      @resets ||= buttons.select { |f| f.class == Reset }
    end

    # Returns all fields of type Text
    def texts
      @texts ||= fields.select { |f| f.class == Text }
    end

    # Returns all fields of type Hidden
    def hiddens
      @hiddens ||= fields.select { |f| f.class == Hidden }
    end

    # Returns all fields of type Textarea
    def textareas
      @textareas ||= fields.select { |f| f.class == Textarea }
    end

    # Returns all fields of type Keygen
    def keygens
      @keygens ||= fields.select { |f| f.class == Keygen }
    end

    # Returns whether or not the form contains a Submit button named +button_name+
    def submit_button?(button_name)
      submits.find { |f| f.name == button_name }
    end

    # Returns whether or not the form contains a Reset button named +button_name+
    def reset_button?(button_name)
      resets.find { |f| f.name == button_name }
    end

    # Returns whether or not the form contains a Text field named +field_name+
    def text_field?(field_name)
      texts.find { |f| f.name == field_name }
    end

    # Returns whether or not the form contains a Hidden field named +field_name+
    def hidden_field?(field_name)
      hiddens.find { |f| f.name == field_name }
    end

    # Returns whether or not the form contains a Textarea named +field_name+
    def textarea_field?(field_name)
      textareas.find { |f| f.name == field_name }
    end

    # This method is a shortcut to get form's DOM id.
    # Common usage:
    #   page.form_with(:dom_id => "foorm")
    # Note that you can also use +:id+ to get to this method:
    #   page.form_with(:id => "foorm")
    def dom_id
      form_node['id']
    end

    # This method is a shortcut to get form's DOM class.
    # Common usage:
    #   page.form_with(:dom_class => "foorm")
    # Note that you can also use +:class+ to get to this method:
    #   page.form_with(:class => "foorm")
    def dom_class
      form_node['class']
    end

    # Add a field with +field_name+ and +value+
    def add_field!(field_name, value = nil)
      fields << Field.new({'name' => field_name}, value)
    end

    ##
    # This method sets multiple fields on the form.  It takes a list of +fields+
    # which are name, value pairs.
    #
    # If there is more than one field found with the same name, this method will
    # set the first one found.  If you want to set the value of a duplicate
    # field, use a value which is a Hash with the key as the index in to the
    # form.  The index is zero based.
    #
    # For example, to set the second field named 'foo', you could do the
    # following:
    #
    #   form.set_fields :foo => { 1 => 'bar' }
    def set_fields fields = {}
      fields.each do |name, v|
        case v
          when Hash
            v.each do |index, value|
              self.fields_with(:name => name.to_s)[index].value = value
            end
          else
            value = nil
            index = 0

            [v].flatten.each do |val|
              index = val.to_i if value
              value = val unless value
            end

            self.fields_with(:name => name.to_s)[index].value = value
        end
      end
    end

    # Fetch the value of the first input field with the name passed in. Example:
    #  puts form['name']
    def [](field_name)
      f = field(field_name)
      f && f.value
    end

    # Set the value of the first input field with the name passed in. Example:
    #  form['name'] = 'Aaron'
    def []=(field_name, value)
      f = field(field_name)
      if f
        f.value = value
      else
        add_field!(field_name, value)
      end
    end

    def pretty_print(q) # :nodoc:
      q.object_group(self) {
        q.breakable; q.group(1, '{name', '}') { q.breakable; q.pp name }
        q.breakable; q.group(1, '{method', '}') { q.breakable; q.pp method }
        q.breakable; q.group(1, '{action', '}') { q.breakable; q.pp action }
        q.breakable; q.group(1, '{fields', '}') {
          fields.each do |field|
            q.breakable
            q.pp field
          end
        }
        q.breakable; q.group(1, '{radiobuttons', '}') {
          radiobuttons.each { |b| q.breakable; q.pp b }
        }
        q.breakable; q.group(1, '{checkboxes', '}') {
          checkboxes.each { |b| q.breakable; q.pp b }
        }
        # q.breakable; q.group(1, '{file_uploads', '}') {
        #   file_uploads.each { |b| q.breakable; q.pp b }
        # }
        q.breakable; q.group(1, '{buttons', '}') {
          buttons.each { |b| q.breakable; q.pp b }
        }
      }
    end

    elements_with :field

    elements_with :radiobutton

    elements_with :checkbox, :checkboxes

    #todo - 1. Button Name
    #     - 2. Opts; a) Multiple Button names
    def submit(button_name=nil, opts={})
      # 1. Loop through the non hidden fields and if they're active and displayed enter the value
      fill_in_field_data

      # 2. Submit Form
      submit_button = select_submit_button(button_name, opts)

      wait_for_submit(submit_button)
      submit_button.node.click

      # 3. Wait for Page page
      wait_for_page(driver, metz)

      # 4. Return new Page
      Metallize::Page.new(driver, metz)

    end

    def fill_in_field_data
      @fields.each do |field|
        unless field.kind_of?(Metallize::Form::Hidden)

          element = driver.find_element(name: field.name)
          if element.displayed? and !field.value.empty?
            element.clear
            element.send_keys field.value

            # Don't attempt to clear a FileUpload field
	
            # todo: https://github.com/serialbandicoot/metallize/issues/2
            element.send_keys field.value

            if field.kind_of?(Metallize::Form::FileUpload)

              # todo: https://github.com/serialbandicoot/metallize/issues/3
              if @metz.clear_field = true
                element.clear
              end
              element.send_keys field.value

            else

              begin
                # Build Executors
                # todo: Pass this is as one script
                js_size   = "return document.getElementsByName(\"#{field.name}\").length"
                js_update = "document.getElementsByName(\"#{field.name}\")[0].value = '#{field.value}'"

                if execute(driver, js_size) > 0
                  execute(driver, js_update)
                else
                  raise "Unable to locate web element with javascript element #{field.name}"
                end

              rescue Exception => e
                raise "Unable to locate web element with javascript element #{e}"
              end

            end
            
          end

        end
      end
    end

    private
    def select_submit_button(button_name, opts)
      if button_name.nil?
        submit_button = @buttons.select {|x| x.kind_of?(Metallize::Form::Submit)}.first
      else
        submit_buttons = @buttons.select {|x|
          x.kind_of?(Metallize::Form::Submit) && x.value.casecmp?(button_name)
        }

        submit_button = submit_buttons.first
        if opts.include?(:instance)
          unless opts[:instance] != opts[:instance] && (opts[:instance].is_a?(Fixnum) || opts[:instance] > submit_buttons.length)
            submit_button = submit_buttons[opts[:instance]]
          end
        end
      end
      submit_button
    end

    #todo - wait until element is click-able / present
    def wait_for_submit(b)
      # 2. Wait for the submit button to be click-able
      wait = Selenium::WebDriver::Wait.new(:timeout => @metz.timeout)
      # wait.until {
      #   driver.find_element(b.node)
      # }
    end


  end
