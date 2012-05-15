# AYAH::Integration -- AreYouAHuman.com Publisher Integration

* Integrate the AreYouAHuman.com CAPTCHA-alternative human verification 
into your Ruby application

AreYouAHuman.com provides a novel game-play approach to human verification; 
instead of deciphering some text, you do a simple task in a fun game.  
You can sign up for a free publisher key at AreYouAHuman.com to start 
using it right away.  

* Visit http://areyouahuman.com/ for more information on how to get started

Contact us or check out our website if you are interested in a customization.

# Supported Ruby Versions

The gem has been tested in:

* Ruby 1.8.7 / Rails 3.1.3
* Ruby 1.9.2 / Rails 3.1.3

If you are running this gem in a different environment, be sure to let us 
know so we can add it to the list.

# Installation, Setup, and Integration

## Installation

* Simply install from RubyGems:
    
        gem install ayah_integration

## Setup

1. In order to use the AYAH Integration gem, you'll first need to sign up at 
http://portal.areyouahuman.com/registration
2. Next, get your 'Publisher Key' and 'Scoring Key', these will be used when 
you first instantiate the AYAH::Integration class
    
## Integration (Examples)

Below are the basic steps and examples needed to get the AYAH Integration gem working.
PUBLISHER\_KEY and SCORING\_KEY can be found in the AYAH Portal and CLIENT_IP is the IP 
address of the client playing the AYAH PlayThru.

You can also register a conversion, for example, when a user passes the AYAH PlayThru 
and completes an order or sign up.

1. Get the HTML needed to be embedded in the form page (in your controller perhaps?):
    
        ayah = AYAH::Integration.new(PUBLISHER_KEY, SCORING_KEY)
        @publisher_html = ayah.get_publisher_html
        
2. Handle the form submission and get score (pass/fail):

        session_secret = params['session_secret'] # in this case, using Rails
        ayah = AYAH::Integration.new(PUBLISHER_KEY, SCORING_KEY)
        ayah_passed = ayah.score_result(session_secret, CLIENT_IP)
    
3. Registering a conversion (optional):
    
        session_secret = params['session_secret'] # or anywhere else it's stored
        ayah = AYAH::Integration.new(PUBLISHER_KEY, SCORING_KEY)
        @ayah_conversion_html = ayah.record_conversion(session_secret)
    
4. THAT'S IT! You're Done!
    
# License and Distribution

This software is offered under the MIT License and is copyright (c) 2011 by AreYouAHuman.com LLC

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
