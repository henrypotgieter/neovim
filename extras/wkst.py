import datetime
import sys


def weekstat(date_look):
    week_day = datetime.datetime.now().isocalendar()[2]
    start_date = datetime.datetime.now() - datetime.timedelta(days=week_day)
    dates = [str((start_date + datetime.timedelta(days=i)).date()) for i in range(7)]
    returnstr = dates[int(date_look)]
    return returnstr


print(weekstat(sys.argv[1]))
