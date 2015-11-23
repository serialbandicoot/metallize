class Metallize::Page::Link

  attr_reader :driver, :link

  def initialize(driver, link)
    @driver = driver
    @link   = link
  end

  def text
    link.text
  end

  def href
    link_attribute = link.attribute('href')
    URI(link_attribute).path
  end

  def click
    link.click

    # 1. Wait for the Page State to Return
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    wait.until {
      driver.execute_script("return document.readyState;") == "complete"
    }

    # 2. Return new Page
    Metallize::Page.new(driver)
  end

  def pretty_print(q) # :nodoc:
    q.object_group(self) {
      q.breakable; q.pp text
      q.breakable; q.pp href
    }
  end

end
