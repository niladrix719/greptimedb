-- Test `time()` and related functions.
-- Some cases are part of promql/testdata/functions.test, "Test time-related functions" section
-- And others are from compliance test

-- time() with itself or scalar

tql eval (3000, 3000, '1s') time();

tql eval (0, 0, '1s') time();

tql eval (0.001, 1, '1s') time();

tql eval (0, 0, '1s') time() + 1;

tql eval (0, 0, '1s') 1 + time();

tql eval (10000, 10000, '1s') time() * time();

tql eval (10000, 10000, '1s') time() / time();

-- expect error: parse error: comparisons between scalars must use BOOL modifier
tql eval (0, 0, '1s') time() < 1;

tql eval (0, 0, '1s') time() < bool 1;

tql eval (0, 0, '1s') time() > bool 1;

tql eval (1000, 1000, '1s') time() + time();

-- expect error: parse error: comparisons between scalars must use BOOL modifier
tql eval (1000, 1000, '1s') time() == time();

tql eval (1000, 1000, '1s') time() == bool time();

tql eval (1000, 1000, '1s') time() != bool time();

-- time() with table

create table metrics (ts timestamp time index, val double);

insert into metrics values (0, 0), (1000, 1), (2000, 2), (3000, 3);

tql eval (1, 2, '1s') time() + metrics;

-- SQLNESS SORT_RESULT 3 1
tql eval (1, 2, '1s') time() == metrics;

-- SQLNESS SORT_RESULT 3 1
tql eval (1, 2, '1s') time() == bool metrics;

-- SQLNESS SORT_RESULT 3 1
tql eval (1, 2, '1s') metrics + time();

-- SQLNESS SORT_RESULT 3 1
tql eval (1, 2, '1s') metrics == time();

-- SQLNESS SORT_RESULT 3 1
tql eval (1, 2, '1s') metrics == bool time();

-- other time-related functions

tql eval (1, 2, '1s') hour();

tql eval (1, 2, '1s') hour(metrics);

-- 2023-12-01T06:43:43Z
tql eval (1701413023, 1701413023, '1s') hour();

tql eval (1701413023, 1701413023, '1s') hour(metrics);

tql eval (1701413023, 1701413023, '1s') minute();

tql eval (1701413023, 1701413023, '1s') month();

tql eval (1701413023, 1701413023, '1s') year();

tql eval (1701413023, 1701413023, '1s') day_of_month();

tql eval (1701413023, 1701413023, '1s') day_of_week();

tql eval (1701413023, 1701413023, '1s') day_of_year();

-- 2024-01-01T06:43:43Z leap year
tql eval (1704091423, 1704091423, '1s') day_of_year();

-- 2023-01-01T06:43:43Z
tql eval (1672555423, 1672555423, '1s') days_in_month();

-- 2023-02-01T06:43:43Z
tql eval (1675233823, 1675233823, '1s') days_in_month();

-- 2024-02-01T06:43:43Z leap year
tql eval (1706769823, 1706769823, '1s') days_in_month();

-- 2023-03-01T06:43:43Z
tql eval (1677653023, 1677653023, '1s') days_in_month();

-- 2023-04-01T06:43:43Z
tql eval (1680331423, 1680331423, '1s') days_in_month();

-- 2023-05-01T06:43:43Z
tql eval (1682923423, 1682923423, '1s') days_in_month();

-- 2023-06-01T06:43:43Z
tql eval (1685601823, 1685601823, '1s') days_in_month();

-- 2023-07-01T06:43:43Z
tql eval (1688193823, 1688193823, '1s') days_in_month();

-- 2023-08-01T06:43:43Z
tql eval (1690872223, 1690872223, '1s') days_in_month();

-- 2023-09-01T06:43:43Z
tql eval (1693550623, 1693550623, '1s') days_in_month();

-- 2023-10-01T06:43:43Z
tql eval (1696142623, 1696142623, '1s') days_in_month();

-- 2023-11-01T06:43:43Z
tql eval (1698821023, 1698821023, '1s') days_in_month();

-- 2023-12-01T06:43:43Z
tql eval (1701413023, 1701413023, '1s') days_in_month();

drop table metrics;

-- date functions read sample values as Unix seconds, not the evaluation time
create table date_samples (ts timestamp time index, host string primary key, val double);

-- 1970-01-01T00:02:00Z, 2024-02-29T13:45:30Z, 2023-12-31T23:59:59.9Z, NaN
insert into date_samples values (0, 'a', 120), (5000, 'a', 1709214330), (0, 'b', 1704067199.9), (5000, 'b', 'NaN'::DOUBLE);

-- SQLNESS SORT_RESULT 3 1
tql eval (0, 5, '5s') minute(date_samples);

-- SQLNESS SORT_RESULT 3 1
tql eval (0, 5, '5s') hour(date_samples);

-- SQLNESS SORT_RESULT 3 1
tql eval (0, 5, '5s') month(date_samples);

-- SQLNESS SORT_RESULT 3 1
tql eval (0, 5, '5s') year(date_samples);

-- SQLNESS SORT_RESULT 3 1
tql eval (0, 5, '5s') day_of_month(date_samples);

-- SQLNESS SORT_RESULT 3 1
tql eval (0, 5, '5s') day_of_week(date_samples);

-- SQLNESS SORT_RESULT 3 1
tql eval (0, 5, '5s') day_of_year(date_samples);

-- SQLNESS SORT_RESULT 3 1
tql eval (0, 5, '5s') days_in_month(date_samples);

drop table date_samples;
