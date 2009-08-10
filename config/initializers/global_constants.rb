# GLOBAL VARIABLE

NAME_RANGE_LENGTH = 3..255
DESCRIPTION_RANGE_LENGTH = 3..2000
TITLE_RANGE_LENGTH = 3..50
SUBJECT_RANGE_LENGTH = 3..75
BODY_RANGE_LENGTH = 3..2000


ONE_WEEK_FROM_TODAY = Time.now - 1.day..Time.now + 7.days
TIME_AGO_FOR_MOSTLY_ACTIVE = 1.month.ago
TRASH_TIME_AGO = 1.month.ago





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
FEED_SIZE = 15
GLOBAL_FEED_SIZE = 10

MAX_NAME = 40
MAX_DESCRIPTION = 5000
MESSAGES_PER_PAGE = 100


NUM_RECENT_MESSAGES = 4
NUM_WALL_COMMENTS = 10
NUM_RECENT = 8
POST_PER_PAGE = 15
USERS_PER_PAGE = 10
ENTRIES_PER_PAGE = 10