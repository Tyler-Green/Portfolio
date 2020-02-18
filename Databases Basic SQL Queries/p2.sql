/*
Program 2: displays data of the customers who have transactions with a given vendor.
The data include customer numbers, customer names, and provinces. Write the program as a
function that accepts a vendor name as a parameter and displays data of customers.
*/

create or replace function p2(vendor char) returns void as $$
	declare
		c1 cursor for select Vno from v where vendor = Vname;
		vendorNo char(3);
		c2 cursor for select Cname, t.Account, Province from c, t where c.Account = t.Account and t.Vno = vendorNo;
		acc char(3);
		name char(50);
		prov char(3);
	begin
		open c1;
		loop
			fetch c1 into vendorNo;
			exit when not found;
			open c2;
			loop
				fetch c2 into name, acc, prov;
				exit when not found;
				raise notice 'Customer Number: %', acc;
				raise notice 'Customer Name: %', name;
				raise notice 'Province: %', prov;
				raise notice ' ';
			end loop;
			close c2;
		end loop;
		close c1;
	end;
$$ language plpgsql;	