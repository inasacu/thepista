

ruby script/generate controller tournaments
ruby script/generate model tournament
rake db:migrate
ruby script/generate themed tournaments tournament --layout=application --with_will_paginate


ruby script/generate nifty_scaffold feeds

