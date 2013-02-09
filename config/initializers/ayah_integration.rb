# Get the HTML needed to be embedded in the form page (in your controller perhaps?):
# ayah = AYAH::Integration.new(PUBLISHER_KEY, SCORING_KEY)
# @publisher_html = ayah.get_publisher_html
# 
# Handle the form submission and get score (pass/fail):
# session_secret = params['session_secret'] 
# ayah = AYAH::Integration.new(PUBLISHER_KEY, SCORING_KEY)
# ayah_passed = ayah.score_result(session_secret, CLIENT_IP)
# 
# Registering a conversion (optional):
# session_secret = params['session_secret'] # or anywhere else it's stored
# ayah = AYAH::Integration.new(PUBLISHER_KEY, SCORING_KEY)
# @ayah_conversion_html = ayah.record_conversion(session_secret)
# 
# THAT'S IT! You're Done!



ENV['PUBLISHER_KEY'] = '39977ccc8a123d851cbbd10a305c891ac8ac310c'
ENV['SCORING_KEY'] = 'd439d6aeba317f92c254c1de3dc8e7f65bf0edf8' 




