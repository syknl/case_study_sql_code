-- This is a script for testing stored procedures written in "stored_procedures.sql".
-- To do the test, execute the scripts in "stored_procedures.sql" and execute all the scripts in this file.

-- 1. Create expected table using mock names.
create or replace procedure create_expected_table(in mock_first_name text, in mock_last_name text, in table_name text) 
language plpgsql as $$
begin
	execute 'drop table if exists ' || table_name || ';';
	execute 'create table ' || table_name || ' as (select *  , '''' as reslt from generate_series(1,100) num)';
	execute 'update ' || table_name || ' set reslt = case when num % 15 = 0 then ''' || mock_first_name ||  ''' || '' '' || ''' || mock_last_name || 
												''' when  num % 3 = 0 then ''' || mock_first_name ||
												''' when  num % 5 = 0 then ''' || mock_last_name ||
												''' else trim(to_char(num, '' 999 '')) end ;';
end;
$$;

call create_expected_table('First', 'Last', 'expected_table');
call create_expected_table('First', 'Lastt', 'not_expected_table');

-- 2. Create outcome table with the stored procedures which need to be tested using mock names.
create or replace procedure create_outcome_table(in mock_first_name text, in mock_last_name text, in table_name text)
language plpgsql as $$ 
declare 
mock_first_name text := mock_first_name;
mock_last_name text := mock_last_name;
table_name text := table_name;
begin
call create_table(table_name);
call fizzbuzz_calc(table_name, mock_first_name, mock_last_name);
end;
$$;

call create_outcome_table('First', 'Last', 'outcome_table');

-- 3. Checking if the table contents are exactly the same.
create or replace function is_table_as_expected(outcome_table text, expected_table text) 
returns boolean as $$ declare bool_v boolean;
begin
execute 
	-- Selecting the difference between outcome_table and expected_table,
	-- and returning true if there is no difference, otherwise false.
	'select case when exists (
		select num, reslt from ' || outcome_table || '
		except all
		select num, reslt from ' || expected_table || '
	)
	then cast(''false'' as boolean) 
	else cast(''true'' as boolean) end;' into
	bool_v;

return bool_v;
end
$$ language plpgsql;

-- 4. Returns true if the outcome table is the same as the expected table. 

-- Case when the outcome is the same as expected.
select is_table_as_expected('outcome_table', 'expected_table');
	-- Returns true.
-- Case when the outcome is different from expected.
select is_table_as_expected('outcome_table', 'not_expected_table');
	-- Returns false.
	
