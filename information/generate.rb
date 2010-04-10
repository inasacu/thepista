

ruby script/generate controller announcements
ruby script/generate model announcement
rake db:migrate
ruby script/generate themed announcements announcement --layout=application --with_will_paginate


ruby script/generate nifty_scaffold feeds

