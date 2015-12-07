require_relative 'element_matcher'

class Metallize::Page

  extend Metallize::ElementMatcher

  attr_reader :driver

  def initialize(driver)
    @driver = driver

    wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    wait.until {
      driver.execute_script("return document.readyState;") == "complete"
    }

  end

  def title
    driver.title
  end

  def uri
    URI(driver.current_url)
  end

  def links
    @links ||= driver.find_elements(:tag_name, 'a').map do |link|
      Link.new(driver, link, self)
    end
  end

  def frames
    @frames ||= driver.find_elements(:tag_name, 'frame').map do |frame|
      Frame.new(driver, frame, self)
    end
  end

  def iframes
    @iframes ||= driver.find_elements(:tag_name, 'iframe').map do |iframe|
      Frame.new(driver, iframe, self)
    end
  end

  def labels
    @labels ||= driver.find_elements(:tag_name, 'label').map do |label|
      Label.new(label, self)
    end
  end

  def bases
    @bases ||= driver.find_elements(:tag_name, 'base').map do |base|
      Base.new(driver, base, self)
    end
  end

  ##
  # Return a list of all img tags
  def images
    @images ||= driver.find_elements(:tag_name, 'img').map do |image|
      Image.new(image, self)
    end
  end

  ##
  # Re-Generate Forms each time called

  def forms
    @forms = driver.find_elements(:tag_name, 'form')
    @forms.map do |form|
      Metallize::Form.new(driver, form)
    end
  end

  def at(args)
    if args.kind_of?(String)
      driver.find_element(css: args)
    else
      driver.find_element(args)
    end
  end

  def pretty_print(q)
    q.object_group(self) {
      q.breakable
      q.group(1, '{url', '}') {q.breakable; q.pp uri }
      q.breakable
      # q.group(1, '{meta_refresh', '}') {
      #   meta_refresh.each { |link| q.breakable; q.pp link }
      # }
      # q.breakable
      q.group(1, '{title', '}') { q.breakable; q.pp title }
      q.breakable
      q.group(1, '{iframes', '}') {
        iframes.each { |link| q.breakable; q.pp link }
      }
      q.breakable
      q.group(1, '{frames', '}') {
        frames.each { |link| q.breakable; q.pp link }
      }
      q.breakable
      q.group(1, '{links', '}') {
        links.each { |link| q.breakable; q.pp link }
      }
      # q.breakable
      q.group(1, '{forms', '}') {
        forms.each { |form| q.breakable; q.pp form }
      }
    }
  end

  elements_with :link

  elements_with :form

  elements_with :image

  elements_with :base

  elements_with :frame

  elements_with :iframe

end

