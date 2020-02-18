/*
Program 1: displays data of all the transactions of a given customer. For each transaction,
the data to display include vendor name, date, and amount. Write the program as a function
that accepts a customer name as a parameter, and displays transactions of the customer.
*/

create or replace function p1(name char) returns void as $$
	declare
		c1 cursor for select Account from c where name = Cname;
		acc char(3);
		c2 cursor for select Vno, T_Date, Amount from t where acc = t.Account;
		vendor CHAR(3);
		tDate DATE;
		amon REAL;
	begin
		open c1;
		loop
			fetch c1 into acc;
			exit when not found;
			open c2;
			loop
				fetch c2 into vendor, tDate, amon;
				exit when not found;
				raise notice 'Vendor: %', vendor;
				raise notice 'Date: %', tDate;
				raise notice 'Amont: %', amon;
				raise notice ' ';
			end loop;
			close c2;
		end loop;
		close c1;
	end;
$$ language plpgsql;	
