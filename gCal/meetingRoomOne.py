from __future__ import print_function
import datetime
from datetime import date, timedelta
import dateutil.parser
import re
import pickle
import os.path
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request

# If modifying these scopes, delete the file token.pickle.
SCOPES = ['https://www.googleapis.com/auth/calendar.readonly']

def main():
    """Shows basic usage of the Google Calendar API.
    Prints the start and name of the next 10 events on the user's calendar.
    """
    creds = None
    # The file token.pickle stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    if os.path.exists('token.pickle'):
        with open('token.pickle', 'rb') as token:
            creds = pickle.load(token)
    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                'credentials.json', SCOPES)
            creds = flow.run_local_server(port=0)
        # Save the credentials for the next run
        with open('token.pickle', 'wb') as token:
            pickle.dump(creds, token)

    service = build('calendar', 'v3', credentials=creds)

    # Call the Calendar API
    calId = 'e8j7gtlg8pk4j903vvhhfruo2o@group.calendar.google.com'
    now = datetime.datetime.utcnow().isoformat() + 'Z' # 'Z' indicates UTC time
    then = datetime.datetime.utcnow()
    then = then + timedelta(seconds = 5)
    then = then.isoformat() + 'Z'
    today = date.today()
    eod = today.strftime("%Y-%m-%d") + 'T23:59:59.000000Z'
    events_result = service.events().list(calendarId=calId, timeMin=now, timeMax=then,
                                        maxResults=5, singleEvents=True,
                                        orderBy='startTime').execute()
    nowEvents = events_result.get('items', [])
    if not nowEvents:
        f = open("/vagrant/html/one/meetingRoomOneName", "w")
        f.write("None")
        f.close()
        f = open("/vagrant/html/one/meetingRoomOneTime", "w")
        f.write("VACANT")
        f.close()
        f = open("/vagrant/html/one/meetingRoomOneAgenda", "w")
        f.write("Contact Receptionist")
        f.close()
        events_result = service.events().list(calendarId=calId, timeMin=now, timeMax=eod,
                                            maxResults=5, singleEvents=True,
                                            orderBy='startTime').execute()
        nextEvents = events_result.get('items', [])
        if nextEvents:
            nextEvent = nextEvents[0]
            start = nextEvent['start'].get('dateTime', nextEvent['start'].get('date'))
            startEvent = re.split('T|\+',start)
            startDate = (startEvent[0])
            startTime = (startEvent[1])
            startTime = datetime.datetime.strptime(startTime, "%H:%M:%S")
            startTime = startTime.strftime("%I:%M %p")
            end = nextEvent['end'].get('dateTime', nextEvent['end'].get('date'))
            endEvent = re.split('T|\+',end)
            endDate = (endEvent[0])
            endTime = (endEvent[1])
            endTime = datetime.datetime.strptime(endTime, "%H:%M:%S")
            endTime = endTime.strftime("%I:%M %p")
            print('Now VACANT')
            f = open("/vagrant/html/one/meetingRoomOneNextName", "w")
            f.write(nextEvent['description'])
            f.close()
            f = open("/vagrant/html/one/meetingRoomOneNextTime", "w")
            f.write(startTime + ' ~ ' + endTime)
            f.close()
            f = open("/vagrant/html/one/meetingRoomOneNextAgenda", "w")
            f.write(nextEvent['summary'])
            f.close()
            print(startDate, startTime, endDate, endTime, nextEvent['summary'], nextEvent['description'])
        else:
            print('No Upcoming Events')
            f = open("/vagrant/html/one/meetingRoomOneNextName", "w")
            f.write("None")
            f.close()
            f = open("/vagrant/html/one/meetingRoomOneNextTime", "w")
            f.write("VACANT")
            f.close()
            f = open("/vagrant/html/one/meetingRoomOneNextAgenda", "w")
            f.write("Contact Receptionist")
            f.close()
    if nowEvents:
        nowEvent = nowEvents[0]
        start = nowEvent['start'].get('dateTime', nowEvent['start'].get('date'))
        startEvent = re.split('T|\+',start)
        startDate = (startEvent[0])
        startTime = (startEvent[1])
        startTime = datetime.datetime.strptime(startTime, "%H:%M:%S")
        startTime = startTime.strftime("%I:%M %p")
        end = nowEvent['end'].get('dateTime', nowEvent['end'].get('date'))
        endEvent = re.split('T|\+',end)
        endDate = (endEvent[0])
        endTime = (endEvent[1])
        endTime = datetime.datetime.strptime(endTime, "%H:%M:%S")
        endTime = endTime.strftime("%I:%M %p")
        print(startDate, startTime, endDate, endTime, nowEvent['summary'], nowEvent['description'])
        f = open("/vagrant/html/one/meetingRoomOneName", "w")
        f.write(nowEvent['description'])
        f.close()
        f = open("/vagrant/html/one/meetingRoomOneTime", "w")
        f.write(startTime + ' ~ ' + endTime)
        f.close()
        f = open("/vagrant/html/one/meetingRoomOneAgenda", "w")
        f.write(nowEvent['summary'])
        f.close()
        events_result = service.events().list(calendarId=calId, timeMin=now, timeMax=eod,
                                            maxResults=5, singleEvents=True,
                                            orderBy='startTime').execute()
        nextEvents = events_result.get('items', [])
        if len(nextEvents) > 1:
            nextEvent = nextEvents[1]
            start = nextEvent['start'].get('dateTime', nextEvent['start'].get('date'))
            startEvent = re.split('T|\+',start)
            startDate = (startEvent[0])
            startTime = (startEvent[1])
            startTime = datetime.datetime.strptime(startTime, "%H:%M:%S")
            startTime = startTime.strftime("%I:%M %p")
            end = nextEvent['end'].get('dateTime', nextEvent['end'].get('date'))
            endEvent = re.split('T|\+',end)
            endDate = (endEvent[0])
            endTime = (endEvent[1])
            endTime = datetime.datetime.strptime(endTime, "%H:%M:%S")
            endTime = endTime.strftime("%I:%M %p")
            print(startDate, startTime, endDate, endTime, nextEvent['summary'], nextEvent['description'])
            f = open("/vagrant/html/one/meetingRoomOneNextName", "w")
            f.write(nextEvent['description'])
            f.close()
            f = open("/vagrant/html/one/meetingRoomOneNextTime", "w")
            f.write(startTime + ' ~ ' + endTime)
            f.close()
            f = open("/vagrant/html/one/meetingRoomOneNextAgenda", "w")
            f.write(nextEvent['summary'])
            f.close()
        else:
            print('No Upcoming Event')
            f = open("/vagrant/html/one/meetingRoomOneNextName", "w")
            f.write("None")
            f.close()
            f = open("/vagrant/html/one/meetingRoomOneNextTime", "w")
            f.write("VACANT")
            f.close()
            f = open("/vagrant/html/one/meetingRoomOneNextAgenda", "w")
            f.write("Contact Receptionist")
            f.close()

if __name__ == '__main__':
    main()
