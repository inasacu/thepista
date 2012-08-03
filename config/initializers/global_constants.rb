# GLOBAL VARIABLE

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
LAST_24_HOURS = Time.zone.now - 1.day
NEXT_24_HOURS = Time.zone.now + 1.day
TWO_DAYS_AFTER = Time.zone.now + 2.days
HOURS_BEFORE_GAME = Time.zone.now + 4.hours

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

# gmap variables
NUMBER_LOCAL_METER = 0.5
NUMBER_LOCAL_KM = 15
NUMBER_NATIONAL_KM = 1000
NUMBER_LATITUDE = 40.416698
NUMBER_LONGITUDE = -3.700354

DISPLAY_MAP_POINTS = 1000
DISPLAY_SOCIAL_MEDIA = true
DISPLAY_DISQUS = true
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
DISPLAY_LAST_MINUTE_CANCEL = false
DISPLAY_PLAYER_POSITION = false
DISPLAY_FUTBOL_ASSIST = false
DISPLAY_SEARCH_OPTION = false
DISPLAY_HAYPISTA_TEMPLATE = false
DISPLAY_HAYPISTA_SIGNUP = false
DISPLAY_SEND_REMINDERS = true
DISPLAY_RECAPTCHA = false

DISPLAY_HEADER_0PTIONS = false

DISPLAY_CORE_SERVICES = true
DISPLAY_FREMIUM_SERVICES = false
DISPLAY_PROFESSIONAL_SERVICES = false
DISPLAY_HAYPISTA_SERVICES = false


MINUTES_TO_RESERVATION  = 15.minutes

ALLOW_REMOVE_GROUP = false

# cup default values
POINTS_FOR_SINGLE = 0
POINTS_FOR_DOUBLE = 15
POINTS_FOR_WINNER = 5
POINTS_FOR_DRAW = 3
POINTS_FOR_GOAL_DIFFERENCE = 2
POINTS_FOR_GOAL_TOTAL = 1

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


COMMON_YEAR_DAYS_IN_MONTH = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
MOBILE_BROWSERS = ["smartphone", "iphone",  "blackberry", "playbook", "windows phone", "android", "ipod", 
									 "opera mini", "palm", "hiptop", "avantgo","plucker", "xiino","blazer","elaine", 
									"windows ce; ppc;", "windows ce; smartphone;","windows ce; iemobile", "up.browser","up.link",
									"mmp","symbian","midp","wap","vodafone","o2","pocket","kindle", "mobile","pda","psp","treo"]


CONTACT_RECIPIENT = 'support@haypista.com'
LANGUAGES = ['es', 'en']