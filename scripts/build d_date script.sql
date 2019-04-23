CREATE TABLE IF NOT EXISTS d_date 
(
	d_date_id					int not null,
	date_actual					date not null,
	epoch						bigint not null,
	day_suffix					varchar(4) not null,
	day_name					varchar(9) not null,
	day_of_week					int not null,
	day_of_month				int not null,
	day_of_year					int not null,
	day_of_quarter				int not null,
	week_of_month				int not null,
	week_of_year				int not null,
	week_of_year_iso			char(10) not null,
	month_actual             	int not null,
  	month_name               	varchar(9) not null,
  	month_name_abbreviated   	char(3) not null,
  	quarter_actual           	int not null,
  	quarter_name             	varchar(9) not null,
  	year_actual              	int not null,
  	first_day_of_week        	date not null,
  	last_day_of_week         	date not null,
  	first_day_of_month       	date not null,
  	last_day_of_month        	date not null,
  	first_day_of_quarter     	date not null,
  	last_day_of_quarter      	date not null,
  	first_day_of_year        	date not null,
  	last_day_of_year         	date not null,
  	mmyyyy                   	char(6) not null,
  	mmddyyyy                 	char(10) not null,
  	weekend_indr             	boolean not null,
	is_holiday					boolean not null
);

ALTER TABLE public.d_date ADD CONSTRAINT d_date_id_pk PRIMARY KEY (d_date_id);
CREATE INDEX d_date_actual_date_idx ON d_date(date_actual);
COMMIT;

INSERT INTO d_date
SELECT TO_CHAR(datum,'yyyymmdd')::INT AS d_date_id,
	datum AS date_actual,
	EXTRACT(epoch FROM datum) AS epoch,
	TO_CHAR(datum,'fmDDth') AS day_suffix,
	TO_CHAR(datum,'Day') AS day_name,
	EXTRACT(isodow FROM datum) AS day_of_week,
	EXTRACT(DAY FROM datum) AS day_of_month,
	datum - DATE_TRUNC('quarter',datum)::DATE +1 AS day_of_quarter,
	EXTRACT(doy FROM datum) AS day_of_year,
	TO_CHAR(datum,'W')::INT AS week_of_month,
	EXTRACT(week FROM datum) AS week_of_year,
	TO_CHAR(datum,'YYYY"-W"IW-') || EXTRACT(isodow FROM datum) AS week_of_year_iso,
	EXTRACT(MONTH FROM datum) AS month_actual,
	TO_CHAR(datum,'Month') AS month_name,
	TO_CHAR(datum,'Mon') AS month_name_abbreviated,
	EXTRACT(quarter FROM datum) AS quarter_actual,
	CASE
		WHEN EXTRACT(quarter FROM datum) = 1 THEN 'First'
		WHEN EXTRACT(quarter FROM datum) = 2 THEN 'Second'
		WHEN EXTRACT(quarter FROM datum) = 3 THEN 'Third'
		WHEN EXTRACT(quarter FROM datum) = 4 THEN 'Fourth'
	END AS quarter_name,
	EXTRACT(isoyear FROM datum) AS year_actual,
	datum +(1 -EXTRACT(isodow FROM datum))::INT AS first_day_of_week,
	datum +(7 -EXTRACT(isodow FROM datum))::INT AS last_day_of_week,
	datum +(1 -EXTRACT(DAY FROM datum))::INT AS first_day_of_month,
	(DATE_TRUNC('MONTH',datum) +INTERVAL '1 MONTH - 1 day')::DATE AS last_day_of_month,
	DATE_TRUNC('quarter',datum)::DATE AS first_day_of_quarter,
	(DATE_TRUNC('quarter',datum) +INTERVAL '3 MONTH - 1 day')::DATE AS last_day_of_quarter,
	TO_DATE(EXTRACT(isoyear FROM datum) || '-01-01','YYYY-MM-DD') AS first_day_of_year,
	TO_DATE(EXTRACT(isoyear FROM datum) || '-12-31','YYYY-MM-DD') AS last_day_of_year,
	TO_CHAR(datum,'mmyyyy') AS mmyyyy,
	TO_CHAR(datum,'mmddyyyy') AS mmddyyyy,
	CASE
		WHEN EXTRACT(isodow FROM datum) IN (6,7) THEN TRUE
	ELSE FALSE
	END AS weekend_indr,
	CASE
		WHEN TO_CHAR(datum,'yyyymmdd')::INT = 20190101 THEN TRUE
		WHEN TO_CHAR(datum,'yyyymmdd')::INT = 20190106 THEN TRUE
		WHEN TO_CHAR(datum,'yyyymmdd')::INT = 20190304 THEN TRUE
		WHEN TO_CHAR(datum,'yyyymmdd')::INT = 20190419 THEN TRUE
		WHEN TO_CHAR(datum,'yyyymmdd')::INT = 20190422 THEN TRUE
		WHEN TO_CHAR(datum,'yyyymmdd')::INT = 20190501 THEN TRUE
		WHEN TO_CHAR(datum,'yyyymmdd')::INT = 20190512 THEN TRUE
		WHEN TO_CHAR(datum,'yyyymmdd')::INT = 20190530 THEN TRUE
		WHEN TO_CHAR(datum,'yyyymmdd')::INT = 20190610 THEN TRUE
		WHEN TO_CHAR(datum,'yyyymmdd')::INT = 20190620 THEN TRUE
		WHEN TO_CHAR(datum,'yyyymmdd')::INT = 20190815 THEN TRUE
		WHEN TO_CHAR(datum,'yyyymmdd')::INT = 20190921 THEN TRUE
		WHEN TO_CHAR(datum,'yyyymmdd')::INT = 20191003 THEN TRUE
		WHEN TO_CHAR(datum,'yyyymmdd')::INT = 20191031 THEN TRUE
		WHEN TO_CHAR(datum,'yyyymmdd')::INT = 20191101 THEN TRUE
		WHEN TO_CHAR(datum,'yyyymmdd')::INT = 20191120 THEN TRUE
		WHEN TO_CHAR(datum,'yyyymmdd')::INT = 20191225 THEN TRUE
		WHEN TO_CHAR(datum,'yyyymmdd')::INT = 20191226 THEN TRUE
		ELSE FALSE
	END AS is_holiday
FROM (
	-- 	  2019 is not a leap year
	SELECT '2019-01-01'::DATE+ SEQUENCE.DAY AS datum
    FROM GENERATE_SERIES (0,365) AS SEQUENCE (DAY)
    GROUP BY SEQUENCE.DAY) DQ
ORDER BY 1;

COMMIT;