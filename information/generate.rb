

ruby script/generate controller venues
ruby script/generate model venue

rake db:migrate
ruby script/generate themed venues venue --layout=application --with_will_paginate


ruby script/generate nifty_scaffold venues




