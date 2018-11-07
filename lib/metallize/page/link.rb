class Metallize::Page::Link

  attr_reader :driver, :link, :metz

  def initialize(driver, link, metz)
    @driver = driver
    @link   = link
    @metz   = metz

    wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    wait.until {
      driver.execute_script("return document.readyState;") == "complete"
    }

  end

  def text
    link.text
  end

  def dom_id
    link.attribute('id')
  end

  def dom_class
    link.attribute('class')
  end

  def href
    link_attribute = link.attribute('href')
    link_attribute = link.attribute('src') if link_attribute.nil?
    URI(link_attribute).path unless link_attribute.nil?
  end

  def target
    link.attribute('target')
  end

  def click
    link.click

    # 1. Wait for the Page State to Return
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    wait.until {
      driver.execute_script("return document.readyState;") == "complete"
    }

    # 2. Return new Page
    Metallize::Page.new(driver, metz)

  end

  def pretty_print(q) # :nodoc:
    q.object_group(self) {
      q.breakable; q.pp text
      q.breakable; q.pp href
    }
  end

end
