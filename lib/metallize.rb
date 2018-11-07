require_relative 'metallize/version'
require 'selenium-webdriver'
require 'pp'

require_relative 'metallize/element_matcher'
require_relative 'metallize/history'

require_relative 'metallize/form'
require_relative 'metallize/form/field'
require_relative 'metallize/form/button'
require_relative 'metallize/form/hidden'
require_relative 'metallize/form/submit'
require_relative 'metallize/form/text'
require_relative 'metallize/form/textarea'
require_relative 'metallize/form/multi_select_list'
require_relative 'metallize/form/select_list'
require_relative 'metallize/form/option'
require_relative 'metallize/form/radio_button'
require_relative 'metallize/form/check_box'

require_relative 'metallize/page'
require_relative 'metallize/page/link'
require_relative 'metallize/page/image'
require_relative 'metallize/page/base'
require_relative 'metallize/page/label'
require_relative 'metallize/page/frame'

require_relative 'metallize/selenenium_webdriver_element'
require_relative 'metallize/array'

class Metallize

  attr_reader :driver

  attr_accessor :history

  def initialize(browser, *opts)
    @driver   = Selenium::WebDriver.for browser
    @history  = Metallize::History.new
  end

  def get(uri)
    driver.get(uri)
    Page.new(driver, self)
  end

  def quit
    driver.quit
  end

  alias :close :quit
  alias :shutdown :quit

  def method_missing(sym)
    driver.send sym
  end

  def self.inspect
    'Metallize; Mechanize API using Selenium-WebDriver'
  end
end
