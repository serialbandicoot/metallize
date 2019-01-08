require_relative 'metallize/version'
require 'selenium-webdriver'
require 'mechanize'
require 'pp'

require_relative 'metallize/element_matcher'
require_relative 'metallize/selenium_webdriver_waiter'
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
require_relative 'metallize/form/file_upload'

require_relative 'metallize/page'
require_relative 'metallize/page/link'
require_relative 'metallize/page/image'
require_relative 'metallize/page/base'
require_relative 'metallize/page/label'
require_relative 'metallize/page/frame'

require_relative 'metallize/selenium_webdriver_element'
require_relative 'metallize/array'
require_relative 'metallize/util'


class Metallize

  attr_reader   :driver

  attr_accessor :history

  attr_accessor :timeout

  attr_accessor :clear_field

  attr_accessor :mechanize

  # #
  # Initialize metz

  def initialize(browser = :chrome, opts = nil)
    @driver = if opts.nil?
                Selenium::WebDriver.for browser
              else
                if opts.include?(:url) && opts.include?(:desired_capabilities)
                  Selenium::WebDriver.for :remote,  :url => opts[:url], :desired_capabilities => opts[:desired_capabilities]
                else
                  Selenium::WebDriver.for :remote, desired_capabilities: opts[:desired_capabilities]
                end
              end

    @history     = Metallize::History.new
    @timeout     = 10
    @mechanize   = nil
    @clear_field = true

    yield self if block_given?
  end

  # #
  # global timeout

  def timeout= timeout
    @timeout = timeout
  end

  def from_mechanize(object)
    # 1. Get the URL and Cookies from Mechanize
    case object
      when Mechanize
        jar = object.agent.cookie_jar.jar
        url = object.page.uri.to_s
      when Mechanize::HTTP::Agent
        jar = object.context.cookie_jar.jar
        url = object.context.page.uri.to_s
      when Mechanize::Page
        jar = object.mech.agent.cookie_jar.jar
        url = object.uri.to_s
      else
        raise('Unknown object ' + object.to_s)
    end

    # 2. Apply Cookies and Update URL for Metallize
    reapply_cookies(jar)
    self.get(url)
  end

  alias :to_metz :from_mechanize

  def to_mechanize
    # 1. Get cookies from web-driver
    cookies = @driver.manage.all_cookies
    cookies.map do |c|
      if c[:expires].nil?
        c[:expires] = DateTime.now.next_year(10).to_s
      else
        c[:expires] = c[:expires].to_s
      end
    end

    # 2. Return a new Mechanize object with the cookies
    @mechanize = Mechanize.new
    cookies.each { |c|
      @mechanize.cookie_jar << Mechanize::Cookie.new(c)
    }
    @mechanize.get @driver.current_url
  end

  alias :to_mech :to_mechanize

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

  private
  def reapply_cookies(jar)
    self.driver.manage.delete_all_cookies

    case jar
      when Array #todo - Implement when required!
        # Forward compatibility
        jar.each {|cookie|
          raise Exception('Not yet implemented!!')
        }
      when Hash
        jar.each {|domain, paths|
          paths.each {|path, names|
            names.each {|cookie_name, cookie|
              self.driver.manage.add_cookie(
                  name: cookie_name,
                  value: cookie.value,
                  domain: domain,
                  path: path,
                  secure: cookie.secure,
                  expires: cookie.expires)
            }
          }
        }
      else
        puts 'Cookie jar could not be initialised'
    end
    self
  end

end
