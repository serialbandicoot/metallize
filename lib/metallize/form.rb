require_relative 'element_matcher'

class Metallize::Form

  extend Metallize::ElementMatcher

    attr_accessor :method, :action, :name

    attr_reader :fields, :buttons, :file_uploads, :radiobuttons, :checkboxes

    # Content-Type for form data (i.e. application/x-www-form-urlencoded)
    attr_accessor :enctype

    # Character encoding of form data (i.e. UTF-8)
    attr_accessor :encoding

    # When true, character encoding errors will never be never raised on form
    # submission.  Default is false
    attr_accessor :ignore_encoding_error

    alias :elements :fields

    attr_reader :form_node
    attr_reader :page

    attr_accessor :method, :action

    attr_reader :fields, :buttons

    alias :elements :fields

    def initialize(driver, form)
      @driver = driver
      @form   = form
      @method = (@form.attribute('method') || 'GET').upcase
      @action = @form.attribute('action')
      parse
    end

    def name
      @form.attribute('name')
    end

    def parse
      @fields       = []
      @buttons      = []

      form_node = @driver.find_elements(:tag_name, 'input')
      form_node.each do |node|
        type = (node.attribute('type') || 'text').downcase
        name = node.attribute('name')
        next if name.nil? && !%w[submit button image].include?(type)
        case type
          when 'submit'
            @buttons << Submit.new(node)
          when 'button'
            @buttons << Button.new(node)
          when 'hidden'
            @fields << Hidden.new(node, node.attribute('value') || '')
          when 'text'
            @fields << Text.new(node, node.attribute('value') || '')
          else
            @fields << Field.new(node, node.attribute('value') || '')
        end

        form_node = @driver.find_elements(:tag_name, 'select')
        form_node.each do |node|
          next unless node['name']
          @fields << SelectList.new(node)
        end

        form_node = @driver.find_elements(:tag_name, 'button')
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
        # q.breakable; q.group(1, '{radiobuttons', '}') {
        #   radiobuttons.each { |b| q.breakable; q.pp b }
        # }
        # q.breakable; q.group(1, '{checkboxes', '}') {
        #   checkboxes.each { |b| q.breakable; q.pp b }
        # }
        # q.breakable; q.group(1, '{file_uploads', '}') {
        #   file_uploads.each { |b| q.breakable; q.pp b }
        # }
        q.breakable; q.group(1, '{buttons', '}') {
          buttons.each { |b| q.breakable; q.pp b }
        }
      }
    end

    elements_with :field

    def submit
      # 1. Loop through the non hidden fields and if they're active and displayed enter the value
      fill_in_field_data

      # 2. Submit Form
      @buttons.first.node.click

      wait_for_page(@driver)

      # 4. Return new Page
      Metallize::Page.new(@driver)

    end

    def fill_in_field_data
      @fields.each do |field|
        unless field.kind_of?(Metallize::Form::Hidden)

          element = @driver.find_element(name: field.name)
          if element.displayed? and !field.value.empty?
            element.clear
            element.send_keys field.value
          end

        end
      end
    end

    def wait_for_page(driver)
      # 3. Wait for the Page State to Return
      wait = Selenium::WebDriver::Wait.new(:timeout => 10)
      wait.until {
        driver.execute_script("return document.readyState;") == "complete"
      }
    end


  end
