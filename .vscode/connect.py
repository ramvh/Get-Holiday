# Purpose: To connect to the PostgreSQL databse server

import psycopg2             # the psycopg2 library is used to connect to the Postgres database
import time                 # time library is used to get current date
from config import config   # for readibility a config file was created to read/store database connection credentials

def connect() :
    conn = None
    try:
        # get connection parameters from config function
        params = config()

        # connect to the PostgreSQL server
        print('Connecting to the PostgreSQL database...')
        conn = psycopg2.connect(**params)

        # create a cursor from established connection
        cur = conn.cursor()

        # execute our queries       
        # 1) Is the current date a holiday?
        curr_date = time.strftime('%Y%m%d')
        sql = "SELECT is_holiday FROM d_date WHERE d_date_id = %s" % (curr_date)
        cur.execute(sql)
        is_holiday = cur.fetchone()
        print('-------------------------------------------------------------------------------------')
        print('Query 1: Is the current date [' + curr_date + '] a holiday? ' + str(is_holiday[0]))
        print('-------------------------------------------------------------------------------------')
        print('')
        # 2) Return a list of (holiday) dates, which are left in the year
        print('-------------------------------------------------------------------------------------')
        print('Query 2: Return a list of holidays that remain in the year.')
        sql = "SELECT d_date_id FROM d_date WHERE is_holiday = TRUE AND d_date_id >= %s" % (curr_date)
        cur.execute(sql)
        remaining_holidays = [row[0] for row in cur.fetchall()]
        print(remaining_holidays)
        print('-------------------------------------------------------------------------------------')
        # close the communication w/ the Postgre server
        cur.close()
    except(Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
            print('Database connection is closed.')

if __name__ == '__main__' : connect()