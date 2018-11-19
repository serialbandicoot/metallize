module Metallize::SeleniumWebdriverWaiter

  def wait_for_page(driver, metz)
    wait = Selenium::WebDriver::Wait.new(:timeout => metz.timeout)
    wait.until {
      driver.execute_script('return document.readyState;') == 'complete'
    }
  end

end