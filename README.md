# Metallize

Metallize is a library, which brings together the Mechanize API and the browser testing library, 'Selenium Webdriver'.

Metallize, because of its API similarities Mechanize, allows the interchange between the libraries. 

An example is that you can execute a test using Mechanize initially and then switch to a browser to complete any testing required. This works the other way round and you can start a test in Metallize and switch to Mechanize. The idea of the library is to support running in mechanize mode, which gives a faster performance and then to switch into a browser mode to allow interactions with the browser.

This switching is not limited and can be performed as many times as desired.
 
# Gotchas

Inevitably there is some differences, which could prevent a completely seamless transition. 

Currently Selenium-Webdriver uses find_element / find_elements. Mechanize just allows you to interact with Nokogiri, therefore if you use at_css or css this will act more like find_elements. The future remedy will be to use a parser closer to Mechanize.


## Installation

Add this line to your application's Gemfile:

    gem 'metallize'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install metallize

## Usage

The browser default is chrome, if you do not specify
```Ruby
@metz = Metallize.new
```

To change the browser type, set global timeout (10s default)
```Ruby
@metz = Metallize.new(:firefox) {|m|
  m.timeout = 5
}
```

### Example 1
```Ruby
metz = Metallize.new
page = metz.get 'https://google.com'
form = page.form_with(name: 'f')
form['q']   = 'Metallize Github'
search_page = form.submit('Google Search', { instance: 1 })
pp search_page
```

### Example 2
```Ruby
metz = Metallize.new
metz.get('https://google.com')

mech = metz.to_mechanize
p mech.title
```

## Contributing

Tested with ruby-2.5.0

1. Fork it ( http://github.com/serialbandicoot/metallize/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
