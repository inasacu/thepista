ruby script/generate nifty_scaffold blog
ruby script/generate nifty_scaffold comment
ruby script/generate nifty_scaffold activity
ruby script/generate nifty_scaffold entry
ruby script/generate nifty_scaffold fee
ruby script/generate nifty_scaffold feed
ruby script/generate nifty_scaffold forum
ruby script/generate nifty_scaffold group
ruby script/generate nifty_scaffold marker
ruby script/generate nifty_scaffold match
ruby script/generate nifty_scaffold message
ruby script/generate nifty_scaffold payment
ruby script/generate nifty_scaffold practice
ruby script/generate nifty_scaffold post
ruby script/generate nifty_scaffold role
ruby script/generate nifty_scaffold schedule
ruby script/generate nifty_scaffold scorecard
ruby script/generate nifty_scaffold sport
ruby script/generate nifty_scaffold teammate
ruby script/generate nifty_scaffold topic
ruby script/generate nifty_scaffold type


script/generate themed  blogs blog --layout=application --with_will_paginate
script/generate themed  comments comment --layout=application --with_will_paginate
script/generate themed  activities activitie --layout=application --with_will_paginate
script/generate themed  entries entrie --layout=application --with_will_paginate
script/generate themed  fees fee --layout=application --with_will_paginate
script/generate themed  feeds feed --layout=application --with_will_paginate
script/generate themed  forums forum --layout=application --with_will_paginate
script/generate themed  groups group --layout=application --with_will_paginate
script/generate themed  markers marker --layout=application --with_will_paginate
script/generate themed  matchs match --layout=application --with_will_paginate
script/generate themed  messages message --layout=application --with_will_paginate
script/generate themed  payments payment --layout=application --with_will_paginate
script/generate themed  practices practice --layout=application --with_will_paginate
script/generate themed  posts post --layout=application --with_will_paginate
script/generate themed  roles role --layout=application --with_will_paginate
script/generate themed  schedules schedule --layout=application --with_will_paginate
script/generate themed  scorecards scorecard --layout=application --with_will_paginate
script/generate themed  sports sport --layout=application --with_will_paginate
script/generate themed  teammates teammate --layout=application --with_will_paginate
script/generate themed  topics topic --layout=application --with_will_paginate
script/generate themed  types type --layout=application --with_will_paginate




script/generate themed albums album --layout=application --with_will_paginate

ruby script/generate model conversation
ruby script/generate model groups_markers
ruby script/generate model groups_users
ruby script/generate model roles_user


user_mailer