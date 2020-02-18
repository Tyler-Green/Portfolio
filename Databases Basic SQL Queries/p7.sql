/*
Program 7 charges a service fee for each customer whose current balance is greater than
the credit limit and add the charge to the balance. The service fee is 10% of the portion over
the credit limit. The program then displays the name of each of such customers and the new
balance.
*/

create or replace function p7() returns void as $$
	declare
		c1 cursor for select Account, Cname, Cbalance, Crlimit from c where Cbalance > Crlimit;
		acc char(3);
		name char(50);
		balance real;
		cLimit real;
	begin
		open c1;
		loop
			fetch c1 into acc, name, balance, cLimit;
			exit when not found;
			balance = (balance - cLimit)*0.1;
			update c set Cbalance = balance
			where Account = acc;
			raise notice 'Name: %', name;
			raise notice 'New Balance: %', balance;
			raise notice ' ';
		end loop;
		close c1;
	end;
$$ language plpgsql;	