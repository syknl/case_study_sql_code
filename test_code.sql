
-- create expected table
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

call create_expected_table('mock_first_name', 'mock_last_name', 'expected_table');

-- create outcome table with stored procedures using mock names.
create or replace procedure create_outcome_table(mock_first_name text, mock_last_name text)
language plpgsql as $$ 
declare table_name text := 'tested_fizzbuzz_like_table'; 
begin
call create_table(table_name);
call fizzbuzz_calc(table_name, mock_first_name, mock_last_name);
	commit;
end;
$$;

call create_outcome_table('mock_first_name', 'mock_last_name');

-- confirm 
create or replace function is_table_as_expected(outcome_table text, expected_table text) 
returns boolean as $$ declare bool_v boolean;
begin
	-- todo: explain what this does
execute '
	SELECT CASE WHEN EXISTS (
		SELECT num, reslt FROM ' || outcome_table || '
		EXCEPT ALL
		SELECT num, reslt FROM ' || expected_table || '
	)
	THEN CAST(''false'' AS BOOLEAN) 
	ELSE CAST(''true'' AS BOOLEAN) end;' into
	bool_v;

return bool_v;
end;

$$ language plpgsql;

select is_table_as_expected('tested_fizzbuzz_like_table', 'expected_table');
