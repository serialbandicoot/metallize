require 'metallize/version'
require 'selenium-webdriver'
require 'pp'

require 'metallize/page'
require 'metallize/element_matcher'

require 'metallize/form'
require 'metallize/form/field'
require 'metallize/form/button'
require 'metallize/form/hidden'
require 'metallize/form/submit'
require 'metallize/form/text'
require 'metallize/form/multi_select_list'
require 'metallize/form/select_list'
require 'metallize/form/option'

require 'metallize/page'
require 'metallize/page/link'

class Metallize

  attr_reader :driver

  def initialize(browser)
    @driver = Selenium::WebDriver.for browser
  end

  def get(uri)
    driver.get(uri)
    Page.new(driver)
  end

  def quit
    driver.quit
  end

  alias :close :quit

  def method_missing(sym)
    driver.send sym
  end

  def self.inspect
    'Metallize; Mechanize API using Selenium-WebDriver'
  end
end
