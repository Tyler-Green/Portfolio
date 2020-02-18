/*
Program 3: inserts a new customer record (tuple). Write this program as a function,
which takes data of the custmer as parameters and stores the data into the customer table.
It then displays all the customer records. The new customer’s balance should be zero
*/
create or replace function p3(addAcc char, addName char, addProv char, addLimit real) returns void as $$
	declare
		c1 cursor for select * from c;
		acc char(3);
		name char(50);
		prov char(3);
		cLimit real;
		bal real;
	begin
		insert into c (Account, Cname, Province, Cbalance, Crlimit) values (addAcc, addName, addProv, 0, addLimit);
		open c1;
		loop
			fetch c1 into  acc, name, prov, bal, cLimit;
			exit when not found;
			raise notice 'Account: %', acc;
			raise notice 'Customer name: %', name;
			raise notice 'Province: %', prov;
			raise notice 'Balance: %', bal;
			raise notice 'Credit Limit: %', cLimit;
			raise notice ' ';
		end loop;
		close c1;
	end;
$$ language plpgsql;	