DROP procedure IF EXISTS create_table();
CREATE OR REPLACE PROCEDURE create_table(IN table_name TEXT) LANGUAGE plpgsql AS $$
  BEGIN
	EXECUTE 'DROP TABLE IF EXISTS ' || table_name;
	EXECUTE 'CREATE TABLE ' || table_name || '(num INTEGER, reslt TEXT)';
	COMMIT;
  END;
$$;
CALL create_table('fizzbuzz_like_table');

DROP procedure IF EXISTS fizzbuzz_calc();
CREATE OR REPLACE PROCEDURE fizzbuzz_calc(IN table_name text, in first_name text, in last_name text) LANGUAGE plpgsql AS $$
DECLARE
  fn text := first_name;
  ln text := last_name;
 fln text := first_name||' '||last_name;
 ent text := null;
  begin
	FOR i IN 1..100 loop
		if i % 15 = 0 then
		ent := fln;
		ELSIF  i % 3 = 0 then 
		ent := fn;
		ELSIF  i % 5 = 0 then
		ent := ln;
		else 
		ent := to_char(i, '999');
		end if;
	 execute 'insert into ' || table_name || ' values (' || to_char(i, '999') || ', ''' || ent || ''')';
	END loop;

--execute 'select case when ' || num || '%15 = 0 then ''' || first_name || ' ' ||  last_name || '''' else '' end as reslt from fizzbuzz_like_table;
--	SELECT a,
--       CASE WHEN a % 15 = 0  THEN 'FizzBuzz' when a % 3 = 0 then 'Fizzz'
--            WHEN a % 5 = 0  THEN 'Buzz'
--            ELSE '' || a
--       end
--       
--	FOR i IN 1..100 loop
--	if  i%3 = 0 then
--	 execute 'insert into fizzbuzz_like_table values (' || str(i) || ', ' || first_name || ''')';
--	END IF;
--   INSERT INTO playtime.meta_random_sample (col_i, col_id) -- use col names
--   SELECT i, id
--   FROM   tbl
--   ORDER  BY random()
--   LIMIT  15000;
--	IF a < b THEN
--   execute 'insert into fizzbuzz_like_table (reslt) values (''a'')';
--END IF;
--	execute 'DROP TABLE IF EXISTS ' || table_name;
--	EXECUTE 'DROP TABLE IF EXISTS ' || table_name;
--	EXECUTE 'CREATE TABLE ' || table_name || '(id SERIAL, reslt INTEGER)';
	COMMIT;
  END;
$$;
CALL fizzbuzz_calc('fizzbuzz_like_table', 'Sayaka', 'Ishihara');




--
--DROP function IF EXISTS fizzbuzz_calc_each();
--CREATE OR REPLACE function fizzbuzz_calc_each(table_name text, first_name text, last_name text, num integer) RETURNS text
--AS $$
--  BEGIN
--	EXECUTE 'INSERT INTO ' || table_name || ' values (1, ''S'')';
----	EXECUTE 'CREATE TABLE ' || table_name || '(id SERIAL NOT NULL, reslt INTEGER)';
--  RETURN "OK";
--  END;
--$$
--LANGUAGE plpgsql ;
--
--select fizzbuzz_calc_each('fizzbuzz_like_table', name, 'I', 1) from ;
--CALL fizzbuzz_calc_each('fizzbuzz_like_table', 'S', 'I');
