module Metallize::SeleniumWebdriverWaiter

  def wait_for_page(driver, metz)
    metz.respond_to?(:timeout) ? tm = metz.timeout : tm = 10

    wait = Selenium::WebDriver::Wait.new(:timeout => tm )
    wait.until {
      driver.execute_script('return document.readyState;') == 'complete'
    }
  end

end