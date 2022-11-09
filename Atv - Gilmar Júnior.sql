create table Adress(

	Adress_ID varchar(20) primary key,
	Street_number integer,
	Street_name varchar(60),
	City varchar(60),
	Province varchar(60),
	Postal_Code varchar(20),
	Is_Headquarter boolean

);

create table Person(

	Driver_License varchar(20) primary key,
	Adress_ID varchar(20),
	First_name varchar(20),
	Last_name varchar(20),
	foreign key (Adress_ID) references Adress(Adress_ID)
);

create table EmployeeType(

	Employee_type varchar(20) primary key

);

create table Employee(

	Driver_License varchar(20) primary key,
	Working_location varchar(20),
	Employee_type varchar(20),
	Is_president boolean,
	Is_Vice_presidente boolean,
	foreign key (Driver_License) references Person(Driver_License),
	foreign key (Working_location) references Adress(Adress_ID),
	foreign key (Employee_type) references EmployeeType(Employee_type)
	
);

create table Phone(
	
	PhoneNumber integer primary key,
	Driver_License varchar(20),
	foreign key (Driver_License) references Person(Driver_License)
	
);

create table Customer(

	Driver_License varchar(20) primary key,
	foreign key (Driver_License) references Person(Driver_License)

);

create table CarClass(

	ClassCode varchar(20) primary key,
	ClassDescription varchar(200)

);

create table Car(

	CarID varchar(20) primary key,
	ClassCode varchar(20),
	CarLocation varchar(20),
	Make varchar(20),
	Model varchar(20),
	YearC date,
	Colour varchar(20),
	LicensePlate varchar(10),
	foreign key (ClassCode) references CarClass(ClassCode),
	foreign key (CarLocation) references Adress(Adress_ID)
	
);

create table DropOff_Charge (

	ClassCode varchar(20), 
	FromLocation varchar(20),
	ToLocation varchar(20),
	DropOffCharge varchar(20),
	primary key(ClassCode, FromLocation, ToLocation),
	foreign key (ClassCode) references CarClass(ClassCode),
	foreign key (FromLocation) references Adress(Adress_ID),
	foreign key (ToLocation) references Adress(Adress_ID)
	
);

create table PromotionRate(

	Duration integer,
	ClassCode varchar(20),
	Amount integer,
	primary key(Duration, ClassCode),
	foreign key (ClassCode) references CarClass(ClassCode)

);

create table Promotion(

	Duration integer,
	ClassCode varchar(20),
	FromDate date,
	Percentage decimal(10,2),
	primary key(Duration, ClassCode),
	foreign key(Duration, ClassCode) references PromotionRate (Duration, ClassCode)

);

create table Rental(

	RentalID varchar(20) primary key,
	Driver_License varchar(20),
	CarID varchar(20),
	FromLocation varchar(20),
	DropOffLocation varchar(20),
	FromDate date,
	ToDate date,
	TankStatus varchar(20),
	InitialOdometer decimal(10,2),
	ReturnOdometer decimal(10,2),
	foreign key (Driver_License) references Customer(Driver_License),
	foreign key (CarID) references Car(CarID),
	foreign key (FromLocation) references Adress(Adress_ID),
	foreign key (DropOffLocation) references Adress(Adress_ID)
	
);

create table RentalRate(

	RentalID varchar(20),
	Duration integer,
	ClassCode varchar(20),
	primary key(RentalID, Duration, ClassCode),
	foreign key(Duration, ClassCode) references PromotionRate (Duration, ClassCode),
	foreign key(RentalID) references Rental(RentalID)

);

insert into Adress
values ('4', 120, 'R Cristina', 'Belo Horizonte', 'Minas Gerais', '30310-692', false),
		('3', 324, 'Av Analice Sturlini', 'Osaco', 'São Paulo', '06018-105', true),
		('2', 876, 'R Goiás', 'Uberaba', 'Minas Gerais', '35574-282', false),
		('1', 653, 'R Bromélias', 'Rio de Janeiro', 'Rio de Janeiro', '22776-040', false);
		
insert into CarClass
values('H', 'Hatch - Os automóveis dessa categoria apresentam um tamanho compacto e oferecem algumas vantagens, como boa dirigibilidade e maior facilidade para manobrar.'),
		('S', 'Sedan - Os automóveis sedan atendem principalmente aos consumidores que necessitam de um amplo porta-malas para suas atividades do dia a dia.'),
		('P', 'Picape - A picapes, ou pick-ups, em inglês, são um tipo de veículo com uma caçamba na parte traseira.'),
		('SUV', 'Essa categoria apresenta veículos robustos, com altura em relação ao solo e comodidade interna maiores.');

select * from Car;

insert into Car 
values ('A3847', 'H','4', 'Renault', 'Sandero', '2020-01-01', 'Preto' , 'HZU-3377'),
		('A9054', 'H','4', 'Renault', 'Logan', '2018-01-01', 'Azul', 'JZK-4434'),
		('A1203', 'H','2', 'VolksWaguen', 'Golf GTI', '2021-01-01', 'Branco', 'HTA5P09'),
		('A7892', 'H','3', 'Fiat', 'Argo', '2022-01-01', 'Prata', 'PJT8F23'),
		('A0349', 'S','1', 'Fiat', 'Siena', '2017-01-01', 'vermelho', 'DHF-4563');

create or replace function fn_atualiza_data()
returns trigger
as $$
begin
	
	if New.YearC >= '2020-01-01' then
	update Car
	set YearC = current_date
	where New.CarID = CarID;
	end if;
	return new;
end;
$$
language 'plpgsql';

create or replace trigger tg_atualiza_data after insert
on Car for each row
execute procedure fn_atualiza_data();

insert into Car 
values ('A5698', 'S', '2', 'Fiat', 'Siena', '2021-01-01', 'Branco' , 'HMW-5498');




