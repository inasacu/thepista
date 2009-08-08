


ruby script/generate nifty_scaffold fees
ruby script/generate nifty_scaffold feeds
ruby script/generate nifty_scaffold payments
ruby script/generate nifty_scaffold practices

script/generate themed  activities activity --layout=application --with_will_paginate
script/generate themed  fees fee --layout=application --with_will_paginate
script/generate themed  feeds feed --layout=application --with_will_paginate
script/generate themed  payments payment --layout=application --with_will_paginate
script/generate themed  practices practice --layout=application --with_will_paginate



ruby script/generate themed types type --layout=application --with_will_paginate
script/generate themed  blogs blog --layout=application --with_will_paginate
script/generate themed  comments comment --layout=application --with_will_paginate
script/generate themed  entries entry --layout=application --with_will_paginate
script/generate themed  forums forum --layout=application --with_will_paginate
script/generate themed  groups group --layout=application --with_will_paginate
script/generate themed  markers marker --layout=application --with_will_paginate
script/generate themed  matchs match --layout=application --with_will_paginate
script/generate themed  messages message --layout=application --with_will_paginate
script/generate themed  posts post --layout=application --with_will_paginate
script/generate themed  schedules schedule --layout=application --with_will_paginate
script/generate themed  scorecards scorecard --layout=application --with_will_paginate
script/generate themed  teammates teammate --layout=application --with_will_paginate
script/generate themed  topics topic --layout=application --with_will_paginate



script/generate themed albums album --layout=application --with_will_paginate
gst

ruby script/generate model roles_user


user_mailer