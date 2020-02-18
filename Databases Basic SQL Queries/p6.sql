/*
Program 6 charges each vendor a service fee that is 4% of the vendor’s balance, and
subtracts the service fee from the balance. The program then displays the name of each vendors,
the fee charged, and the new balance.
*/

create or replace function p6() returns void as $$
	declare
		c1 cursor for select Vno, Vname, Vbalance from v;
		vendor char(3);
		name char(50);
		balance real;
		charge real;
	begin
		open c1;
		loop
			fetch c1 into vendor, name, balance;
			exit when not found;
			charge = balance*0.04;
			balance = balance - charge;
			update v set Vbalance = balance
			where Vno = vendor;
			raise notice 'Name: %', name;
			raise notice 'Fee: %', charge;
			raise notice 'New Balance: %', balance;
			raise notice ' ';
		end loop;
		close c1;
	end;
$$ language plpgsql;	