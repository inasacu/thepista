# GLOBAL VARIABLE

# WIDGET

DIV_ID_WIDGET = 'haypistawidget'

# -------------

HAYPISTA_FOUNDED_YEAR = '09 Sept 2008'

NAME_RANGE_LENGTH = 3..75
DESCRIPTION_RANGE_LENGTH = 3..2000
TITLE_RANGE_LENGTH = 3..75
SUBJECT_RANGE_LENGTH = 3..75
BODY_RANGE_LENGTH = 3..2000

MAJOR_EVENT_TWO_MONTHS = Time.zone.now - 1.day..Time.zone.now + 35.days 
LAST_WEEK_TO_TODAY = Time.zone.now - 7.days..Time.zone.now + 1.day
ONE_WEEK_FROM_TODAY = Time.zone.now - 1.day..Time.zone.now + 7.days
TWO_WEEKS_FROM_TODAY = Time.zone.now - 1.day..Time.zone.now + 14.days
THREE_WEEKS_FROM_TODAY = Time.zone.now - 1.day..Time.zone.now + 21.days
ONE_MONTH_FROM_TODAY = Time.zone.now - 1.day..Time.zone.now + 30.days
YESTERDAY_TO_TODAY = Time.zone.now - 1.day..Time.zone.now + 1.day
# LAST_THREE_DAYS = Time.zone.now - 3.days..Time.zone.now + 1.day

NEXT_WEEK = Time.zone.now + 7.days
LAST_WEEK = Time.zone.now - 7.days

YESTERDAY = Time.zone.now - 1.day

LAST_TWO_DAYS = Time.zone.now - 2.days
LAST_THREE_DAYS = Time.zone.now - 3.days
LAST_FOUR_DAYS = Time.zone.now - 4.days
LAST_FIVE_DAYS = Time.zone.now - 5.days
LAST_SIX_DAYS = Time.zone.now - 6.days

NEXT_TWO_DAYS = Time.zone.now + 2.days
NEXT_THREE_DAYS = Time.zone.now + 3.days
NEXT_FOUR_DAYS = Time.zone.now + 4.days
NEXT_FIVE_DAYS = Time.zone.now + 5.days
NEXT_SIX_DAYS = Time.zone.now + 6.days
NEXT_SEVEN_DAYS = Time.zone.now + 7.days

TWO_WEEKS_AGO = Time.zone.now - 14.days
THREE_WEEKS_AGO = Time.zone.now - 21.days

ONE_MONTH_AGO = Time.zone.now - 30.days
TWO_MONTHS_AGO = Time.zone.now - 60.days
THREE_MONTHS_AGO = Time.zone.now - 90.days
FOUR_MONTHS_AGO = Time.zone.now - 120.days
SIX_MONTHS_AGO = Time.zone.now - 180.days
NINE_MONTHS_AGO = Time.zone.now - 270.days
TWELVE_MONTHS_AGO = Time.zone.now - 365.days

PAST_THREE_DAYS = Time.zone.now - 3.days
PAST_TWO_DAYS = Time.zone.now - 2.days

LAST_12_HOURS = Time.zone.now - 12.hours
LAST_24_HOURS = Time.zone.now - 1.day
NEXT_24_HOURS = Time.zone.now + 1.day
NEXT_48_HOURS = Time.zone.now + 2.days

ONE_HOURS_BEFORE_GAME = Time.zone.now - 1.hours
TWO_HOURS_BEFORE_GAME = Time.zone.now - 2.hours
THREE_HOURS_BEFORE_GAME = Time.zone.now - 3.hours
FOUR_HOURS_BEFORE_GAME = Time.zone.now - 4.hours
FIVE_HOURS_BEFORE_GAME = Time.zone.now - 5.hours
SIX_HOURS_BEFORE_GAME = Time.zone.now - 6.hours

TIME_ONE_DAY_AGO = 1.day.ago
TIME_THREE_DAYS_AGO = 2.days.ago
TIME_WEEK_AGO = 1.week.ago

TIME_ONE_MONTH_AGO = 1.month.ago
TIME_TWO_MONTHS_AGO = 2.months.ago
TIME_THREE_MONTHS_AGO = 3.months.ago
TIME_FOUR_MONTHS_AGO = 4.months.ago
TIME_FIVE_MONTHS_AGO = 5.months.ago
TIME_SIX_MONTHS_AGO = 6.months.ago

# variable for pagination
COMMENTS_PER_PAGE = 100
MESSAGES_PER_PAGE = 25

# model link length
USER_NAME_LENGTH = 15

GAMES_PLAYED = 12

# true skill values
InitialMean = 25.0
# InitialMean = 1200.0
K_FACTOR = 3

#variables for login
SHOW_OPENID_LOGIN = false
SHOW_LOGIN = true
SHOW_RPX_NOW = true

# Database strings typically can't be longer than 255.
MAX_STRING_LENGTH = 255
MEDIUM_STRING_LENGTH = 100
SMALL_STRING_LENGTH = 40

MAX_TEXT_LENGTH = 5000
MEDIUM_TEXT_LENGTH = 500
SMALL_TEXT_LENGTH = 300

EMAIL_REGEX = /\A[A-Z0-9\._%+-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}\z/i

# Recent activities feed size
SMALL_FEED_SIZE = 8
MEDIUM_FEED_SIZE = 15
LARGE_FEED_SIZE = 20
EXTENDED_FEED_SIZE = 200

DUNBAR_NUMBER = 150

LOOKING_USERS = 24
LOOKING_GROUPS = 24

MAX_NAME = 40
MAX_DESCRIPTION = 5000

NUM_RECENT_MESSAGES = 4
NUM_WALL_COMMENTS = 10
NUM_RECENT = 8

NUMBER_RECENT_MATCH_NOTES = 3

COEFICIENT_LOW = 20.0
COEFICIENT_MEDIUM_LOW = 19.0
COEFFICIENT_MEDIUM_HIGH = 50.09
COEFFICIENT_HIGH = 49.0

COEFICIENT_FULL_LOW = 40.0
COEFICIENT_FULL_MEDIUM_LOW = 39.0
COEFFICIENT_FULL_MEDIUM_HIGH = 60.0
COEFFICIENT_FULL_HIGH = 59.0

HAS_USER_STATISTICS = 0

# gmap variables
NUMBER_LOCAL_METER = 0.5
NUMBER_LOCAL_KM = 15
NUMBER_NATIONAL_KM = 1000
NUMBER_LATITUDE = 40.416698
NUMBER_LONGITUDE = -3.700354

# display options
DISPLAY_MAP_POINTS = 1000
DISPLAY_SOCIAL_MEDIA = false
DISPLAY_TRUESKILL = false
DISPLAY_HOWTO = false   # default = false
DISPLAY_UPCOMING = true
DISPLAY_QR_CODE = false   # default = false 
DISPLAY_GMAP = false
DISPLAY_GEO_CODE = true
DISPLAY_GROUP_GMAP = false
DISPLAY_DEFAULTS = false
DISPLAY_USER_GROUP_FULL = false
DISPLAY_USER_PETITION = false
DISPLAY_MESSAGE_FLAG = false
DISPLAY_USER_VOICE = false
DISPLAY_REGISTER = true
DISPLAY_MAX_GAMES_PLAYED = false
DISPLAY_PRIVATE_PROFILE = false
DISPLAY_LAST_MINUTE_CANCEL = true
DISPLAY_PLAYER_POSITION = false
DISPLAY_FUTBOL_ASSIST = false
DISPLAY_SEARCH_OPTION = false
DISPLAY_HAYPISTA_TEMPLATE = false
DISPLAY_HAYPISTA_SIGNUP = true
DISPLAY_SEND_REMINDERS = true
DISPLAY_RECAPTCHA = false
DISPLAY_ARE_YOU_A_HUMAN = false
DISPLAY_ZOPIM = false
DISPLAY_ANALYTICS = false
DISPLAY_YO = true
DISPLAY_USER_STATISTICS = false
DISPLAY_HEADER_0PTIONS = false
DISPLAY_MESSAGES = true

DISPLAY_CORE_SERVICES = true
DISPLAY_FREMIUM_SERVICES = false
DISPLAY_PROFESSIONAL_SERVICES = false
DISPLAY_HAYPISTA_SERVICES = false
DISPLAY_BROWSER_ID = false
DISPLAY_DISQUS = false

MINUTES_TO_RESERVATION  = 15.minutes
DAYS_IN_A_WEEK = 7
DAYS_IN_TWO_WEEK = 14
DAYS_IN_THREE_WEEK = 21

# reputation options
REPUTATION_PERCENT = 85
REPUTATION_GAME_MINIMUM = 2
REPUTATION_LAST_MINUTE_INFRINGE = 3

ALLOW_REMOVE_GROUP = false

# cup default values
POINTS_FOR_SINGLE = 0
POINTS_FOR_DOUBLE = 15
POINTS_FOR_WINNER = 5
POINTS_FOR_DRAW = 3
POINTS_FOR_GOAL_DIFFERENCE = 2
POINTS_FOR_GOAL_TOTAL = 1

SCHEDULE_DISPLAY_LIMIT = 3

# image default values
IMAGE_CONVOCADO = 'icons/status_convocado.png'
IMAGE_ULTIMA_HORA = 'icons/status_ultima_hora.png' 
IMAGE_AUSENTE = 'icons/status_ausente.png' 
IMAGE_NO_DISPONIBLE = 'icons/status_no_disponible.png'

IMAGE_SUBIR_CLASIFICACION = 'icons/subir_clasificacion.png'
IMAGE_BAJAR_CLASIFICACION = 'icons/bajar_clasificacion.png'
IMAGE_MANTENER_CLASIFICACION = 'icons/mantener_clasificacion.png'


IMAGE_CHALLENGE = 'icons/challenge.png'
IMAGE_CUP = 'icons/cup.png'
IMAGE_AVATAR = "icons/avatar.png"
IMAGE_GROUP_AVATAR = 'icons/group_avatar.png'
IMAGE_CALENDAR = 'icons/calendar.png'
IMAGE_EMAIL_ADD = "icons/email_add.png"
IMAGE_EMAIL_GO = "icons/email_go.png"
IMAGE_EMAIL_DELETE = 'icons/email_delete.png'
IMAGE_RESERVATION = 'icons/reservation.png'
IMAGE_VENUE = 'icons/venue.png'

# .sport.icon

IGNORE_HOME = ['home_about', 'home_terms_of_use', 'home_faq', 'home_persona', 'home_feedback', 'home_how_it_work', 'home_launch', 'home_for_website']

DISABLE_PROVIDER_EMAIL = ['google','facebook','linkedin','yahoo']

COMMON_YEAR_DAYS_IN_MONTH = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
MOBILE_BROWSERS = ["smartphone", "iphone",  "blackberry", "playbook", "windows phone", "android", "ipod", 
									 "opera mini", "palm", "hiptop", "avantgo","plucker", "xiino","blazer","elaine", 
									"windows ce; ppc;", "windows ce; smartphone;","windows ce; iemobile", "up.browser","up.link",
									"mmp","symbian","midp","wap","vodafone","o2","pocket","kindle", "mobile","pda","psp","treo"]


CONTACT_RECIPIENT = ENV["CONTACT_RECIPIENT"]
CONTACT_RECIPIENT_SUBJECT = ENV["CONTACT_RECIPIENT_SUBJECT"]
CONTACT_FEEDBACK = ENV["CONTACT_FEEDBACK"]

LANGUAGES = ['es', 'en']

DEFAULT_AMAZON_S3_IMAGES_URL = ENV["DEFAULT_AMAZON_S3_IMAGES_URL"]
DEFAULT_GROUP_USERS = [1, 2, 3]


# YO Request
YO_REQUEST_URL = "http://api.justyo.co/"
YO_REQUEST_URL_ALL = "http://api.justyo.co/yoall/"


# PRICE RANGES
PRICE_RANGE_UNDER_50 = 1...49
PRICE_RANGE_UNDER_500 = 50...499
PRICE_RANGE_UNDER_5000 = 500...4999
PRICE_RANGE_OVER_5000 = 5000

# launch page display
LAUNCH_PAGE = false

# use delayed jobs
USE_DELAYED_JOBS = false


# TYPES FOR STATUS
TYPE_CONVOCADO=1
TYPE_ULTIMAHORA=2
TYPE_AUSENTE=3

# MOBILE
MOBILE_LOGIN_REGISTERED=11
MOBILE_LOGIN_SHOULD_SIGNUP=12
MOBILE_LOGIN_FAILURE=13

# LOGIN OPTIONS
TWITTER_LOGIN_OPTION = true
FACEBOOK_LOGIN_OPTION = true
LINKEDIN_LOGIN_OPTION = true
GOOGLE_LOGIN_OPTION = true
WINDOWS_LOGIN_OPTION = true
YAHOO_LOGIN_OPTION = false

