/*
Program 5 calculates the total amount of transactions of every vendor in the transaction
table, and add the total amount to the vendor’s current balance. The program then displays
vendor numbers, vendor names and the new balances.
*/

create or replace function p5() returns void as $$
	declare
		c1 cursor for select Vno, sum(Amount) from t group by Vno;
		c2 cursor for select Vno, Vname, Vbalance from v;
		vendor char(3);
		bal real;
		name char(50);
	begin
		open c1;
		loop
			fetch c1 into vendor, bal;
			exit when not found;
			update v set Vbalance = Vbalance + bal
			where Vno = vendor;
		end loop;
		close c1;
		open c2;
		loop
			fetch c2 into vendor, name, bal;
			exit when not found;
			raise notice 'Vendor: %', vendor;
			raise notice 'Vendor Name: %', name;
			raise notice 'New Balance: %', bal;
		end loop;
		close c2;
	end;
$$ language plpgsql;	