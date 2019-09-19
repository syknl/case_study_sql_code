-- Stored Procedure to create table.
drop procedure if exists create_table();

create or replace procedure create_table(in table_name text) 
language plpgsql as $$
begin
execute 'DROP TABLE IF EXISTS ' || table_name;
execute 'CREATE TABLE ' || table_name || '(num INTEGER, reslt TEXT)';
commit;
end;
$$;

--CALL create_table('fizzbuzz_like_table');

-- Stored Procedure to calculate algorithm.
drop procedure if exists fizzbuzz_calc();

create or replace procedure fizzbuzz_calc(in table_name text, in first_name text, in last_name text) 
language plpgsql as $$ 
declare fn text := first_name;
ln text := last_name;
fln text := first_name || ' ' || last_name;
ent text := null;
begin
	for i in 1..100 loop 
		if i % 15 = 0 then ent := fln;
		elsif i % 3 = 0 then ent := fn;
		elsif i % 5 = 0 then ent := ln;
		else ent := trim(to_char(i, '999'));
		end if;
		execute 'insert into ' || table_name || ' values (' || to_char(i, '999') || ', ''' || ent || ''')';
	end loop;
	commit;
end;
$$;
--CALL fizzbuzz_calc('fizzbuzz_like_table', 'Sayaka', 'Ishihara');
