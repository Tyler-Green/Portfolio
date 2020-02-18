create or replace function a3data() returns void as $$
	begin
		drop table if exists t;
		drop table if exists c;
		drop table if exists v;

		create table v(Vno CHAR(3) PRIMARY KEY NOT NULL UNIQUE, 
									 Vname CHAR(50) NOT NULL, 
									 City CHAR(50) NOT NULL, 
									 Vbalance REAL NOT NULL);
		create table c(Account CHAR(3) PRIMARY KEY NOT NULL UNIQUE, 
									 Cname CHAR(20) NOT NULL, 
									 Province Char(3) NOT NULL, 
									 Cbalance REAL NOT NULL, 
									 Crlimit REAL NOT NULL);
		create table t(Tno CHAR(3) PRIMARY KEY NOT NULL UNIQUE, 
									 Vno CHAR(3) NOT NULL REFERENCES v(Vno), 
									 Account CHAR(3) NOT NULL REFERENCES c(Account), 
									 T_Date DATE NOT NULL, 
									 Amount REAL NOT NULL);

		insert into v (Vno, Vname, City, Vbalance) 
		values ('V1', 'Sears', 'Toronto', 200.00),('V2', 'WalMart', 'Waterloo', 671.05),('V3', 'Esso', 'Windsor', 0.00),('V4', 'Esso', 'Waterloo', 225.00);
		insert into c (Account, Cname, Province, Cbalance, Crlimit) 
		values ('A1', 'Smith', 'ONT', 2515.00, 2000),('A2', 'Jones', 'BC', 2014.00, 2500),('A3', 'Doc', 'ONT', 150.00, 1000);
		insert into t (Tno, Vno, Account, T_Date, Amount) 
		values ('T1', 'V2', 'A1', '2019-07-15', 1325.00),('T2', 'V2', 'A3', '2018-12-16', 1900.00),('T3', 'V3', 'A1', '2019-09-01', 2500.00),('T4', 'V4', 'A2', '2019-03-20', 1613.00),('T5', 'V4', 'A3', '2019-07-31', 3312.00);
	end;
$$ language plpgsql;
