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
LAST_WEEK = Time.zone.now - 7.days
TWO_WEEKS_AGO = Time.zone.now - 14.days
THREE_WEEKS_AGO = Time.zone.now - 21.days
TWO_MONTHS_AGO = Time.zone.now - 60.days
SIX_MONTHS_AGO = Time.zone.now - 180.days
NINE_MONTHS_AGO = Time.zone.now - 270.days
TWELVE_MONTHS_AGO = Time.zone.now - 365.days
PAST_THREE_DAYS = Time.zone.now - 3.days
LAST_THREE_DAYS = Time.zone.now - 3.days..Time.zone.now + 1.day
LAST_24_HOURS = Time.zone.now - 1.day
NEXT_24_HOURS = Time.zone.now + 1.day
TWO_DAYS_AFTER = Time.zone.now + 2.days
HOURS_BEFORE_GAME = Time.zone.now - 3.hours

TIME_AGO_FOR_MOSTLY_ACTIVE = 1.month.ago
TRASH_TIME_AGO = 1.month.ago
ACTIVITY_TIME_AGO = 6.months.ago

# variable for pagination
BLOGS_PER_PAGE = 8
COMMENTS_PER_PAGE = 8
ENTRIES_PER_PAGE = 8
FEES_PER_PAGE = 8
FORUMS_PER_PAGE = 8
GROUPS_PER_PAGE = 8
MARKERS_PER_PAGE = 8
MESSAGES_PER_PAGE = 25
POSTS_PER_PAGE = 8
PRACTICES_PER_PAGE = 8
ROLES_PER_PAGE = 8
SCHEDULES_PER_PAGE = 8
SCORECARDS_PER_PAGE = 1
SPORTS_PER_PAGE = 8
TOPICS_PER_PAGE = 8
TYPES_PER_PAGE = 8
USERS_PER_PAGE = 10
ROSTERS_PER_PAGE = 16
INVITATIONS_PER_PAGE = 15
PAYMENTS_PER_PAGE = 15
CLASSIFIEDS_PER_PAGE = 25
CUPS_PER_PAGE = 48

#variables for login
SHOW_OPENID_LOGIN = false
SHOW_LOGIN = true
SHOW_RPX_NOW = true

# tag variable
TAG_LIMIT = 30
TAG_LEAST = 8


# Column sizes
# FULL = 20
# LEFT = LARGER_COLUMN = 14
# RIGHT = SMALLER_COLUMN = 6

# Database strings typically can't be longer than 255.
MAX_STRING_LENGTH = 255
MEDIUM_STRING_LENGTH = 100
SMALL_STRING_LENGTH = 40

MAX_TEXT_LENGTH = 5000
MEDIUM_TEXT_LENGTH = 500
SMALL_TEXT_LENGTH = 300

# The number of raster colums.
N_COLUMNS = 4
# The number of raster results per page.
RASTER_PER_PAGE = 3 * N_COLUMNS


#RICH TEXT EDITOR SIZE (pixels)
RICH_TEXT_HEIGHT = '350px'


EMAIL_REGEX = /\A[A-Z0-9\._%+-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}\z/i
FEED_SIZE = 1
GLOBAL_FEED_SIZE = 8

LOOKING_USERS = 24
LOOKING_GROUPS = 24

MAX_NAME = 40
MAX_DESCRIPTION = 5000

NUM_RECENT_MESSAGES = 4
NUM_WALL_COMMENTS = 10
NUM_RECENT = 8
