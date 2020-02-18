/*
Program 4 displays the most recent transaction of every customer. The program displays
account number, customer name, amount, and vendor name. If a customer has no transaction
(e.g. the new one), the program should display “no transaction”.
*/

create or replace function p4() returns void as $$
	declare
		c1 cursor for select Account, Cname from c;
		acc char(3);
		name char(50);
		c2 cursor for select t.Amount, Vname from v, t where v.Vno = t.Vno and acc = t.Account and t.amount = (select MAX(t.Amount) from t where t.Account = acc);
		vendName char(50);
		amount real;
	begin
		open c1;
		loop
			fetch c1 into acc, name;
			exit when not found;
			raise notice 'Account: %', acc;
			raise notice 'Name: %', name;
			open c2;
			if (select exists (select t.Amount, Vname from v, t where v.Vno = t.Vno and acc = t.Account and t.amount = (select MAX(t.Amount) from t where t.Account = acc))) then
				fetch c2 into amount, vendName;
				raise notice 'Amount: %', amount;
				raise notice 'Vendor Name: %', vendName;
			else 
				raise notice 'No Transaction';
			end if;
			raise notice ' ';
			close c2;
		end loop;
		close c1;
	end;
$$ language plpgsql;	
