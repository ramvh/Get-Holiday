# GetHoliday
<strong>Purpose</strong>: Python application used to query Postgres database for (German) holidays.

Assignment requirements:
1. Setup a DBMS of your choice<br>
--> Created a simple Postgre database to store dates and holidays for the current year.

2. Database: Create Holiday Table <br>
  a) CREATE the holiday table (DDL) <br>
  b) Fill (INSERTs) this table with data (DML) <br>
  c) Describe how you did this, please. <br>
  --> I created a single psql script for the CREATE and INSERT to build the d_date table. <br>
  -- Before table creation, there is a check if d_date table already exists, if not, create table; otherwise, do not create. <br>
  -- The date (d_date_id) is used as primary key and actual_date as index, this is for quicker identification and searching. <br>
  -- To simplify the task, I've hardcode the holiday dates and use a boolean value (is_holiday) to flag if current date is a holiday. <br>
  -- <i>The d_date table includes more fields then necessary because I'd like to calculate movable holidays (for a later project) 
  in addition to fixed-date holidays. </i><br>
  -- Also, d_date only contains dates for the year 2019; however, this can be expanded on in the subquery at line 100.

3. Python: Get holiday <br>
  a) Write a function, which checks, if the current_date is a holiday <br>
  b) Write a second function, which return a list of (holiday) dates, which are left in this year. <br>


We expect to find in your solution: <br>
  a) The DDL <br>
  b) Keys for the DB part <br>
  c) Descriptions, which you think are important for us <br>
  d) Explanation to why you do believe that. (edited) <br>
  --> Things to note when reviewing: <br>
  -- 1. Postgres database connection credentials are stored in a separate file for readibility. Please see config.py and database.ini for database details. <br>
  -- 2. The connect.py file performs the connection to database and queries for holidays. <br>
  -- 2a. In order to connect the python application to Postgres, I had to import the psycopg2 library. <br>
  -- 2b. I import the time library to get the current date in the YYYYmmdd format and use this to query d_date.d_date_id. <br>
  -- 2c. Once queries are complete, database connection is closed immediately. <br>
  -- 3. I've included error handling in the form of a try/catch to ensure that the database is connection is closed if any errors arise. <br>
  -- 4. Generally, I kept the assignment simple and concise to answer the queries. 
  The the hardcoding of holiday for a set year is restrictive and there are many ways to expand upon the assignment. 
  If given more time I would generate more dates into the d_date table and use the additional fields I've included to calculate movable holidays in addition to fixed date holidays.
  I would also like to expand the holidays available to different countries, this would require a more complex data model to achieve.
