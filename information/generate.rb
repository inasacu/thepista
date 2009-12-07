

ruby script/generate controller tournaments
ruby script/generate model tournament
rake db:migrate
ruby script/generate themed tournaments tournament --layout=application --with_will_paginate


ruby script/generate nifty_scaffold feeds




ruby script/generate controller rounds
ruby script/generate model round
rake db:migrate
ruby script/generate themed rounds round --layout=application --with_will_paginate
