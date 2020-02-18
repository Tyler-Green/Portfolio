/*
Program 8 adds a new transaction. Each time the program is executed, it takes a trans-
action number, a vendor number, an account number, and an amount from the user. The
date of the transaction should be the date on which the program is executed and assigned
by the computer automaticaly. The program stores the new transaction into the transaction
table, it then updates the balances of the related customer and vendor with the amount of the
new transaction. It then displays the new transaction, and the updated customer and vendor
records.
*/

create or replace function p8(transno char, vendno char, acc char, amount real) returns void as $$
	declare
		c1 cursor for select * from t where Tno = transno;
		c2 cursor for select * from c where Account = acc;
		c3 cursor for select * from v where Vno = vendno;
		acco char(3);
		vendor char(3);
		trans char(3);
		balance real;
		cLimit real;
		name char(50);
		city char(50);
		prov char(3);
		tranDate Date;
	begin
		insert into t (Tno, Vno, Account, T_Date, Amount) 
		values (transno, vendno, acc, CURRENT_DATE, amount);
		update c set Cbalance = Cbalance + amount
		where acc = Account;
		update v set Vbalance = Vbalance + amount
		where Vno = vendno;
		open c1;
		loop
			fetch c1 into trans, vendor, acco, tranDate, balance;
			exit when not found;
			raise notice 'Transaction Number: %', trans;
			raise notice 'Vendor Number: %', vendor;
			raise notice 'Account: %', acco;
			raise notice 'Transaction Date: %', tranDate;
			raise notice 'Transaction Amount: %', balance;
			raise notice ' ';
		end loop;
		close c1;
		open c2;
		loop
			fetch c2 into acco, name, prov, balance, cLimit;
			exit when not found;
			raise notice 'Account: %', acco;
			raise notice 'Name: %', name;
			raise notice 'Provice: %', prov;
			raise notice 'New Balance: %', balance;
			raise notice 'Credit Limit: %', cLimit;
			raise notice ' ';
		end loop;
		close c2;
		open c3;
		loop
			fetch c3 into vendor, name, city, balance;
			exit when not found;
			raise notice 'Vendor Number: %', vendor;
			raise notice 'Vendor Name: %', name;
			raise notice 'City: %', city;
			raise notice 'New Balance: %', balance;
			raise notice ' ';
		end loop;
		close c3;
	end;
$$ language plpgsql;	