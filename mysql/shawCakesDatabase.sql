

-- create the database
DROP DATABASE IF EXISTS ShawCakes;
CREATE DATABASE ShawCakes;

-- select the database
USE ShawCakes;


-- ** Create proper case function ** --
DROP FUNCTION IF EXISTS proper;
SET GLOBAL  log_bin_trust_function_creators=TRUE;
DELIMITER |
CREATE FUNCTION proper( str VARCHAR(128) )
	RETURNS VARCHAR(128)
	BEGIN

		DECLARE c CHAR(1);
		DECLARE s VARCHAR(128);
		DECLARE i INT DEFAULT 1;
		DECLARE bool INT DEFAULT 1;
		DECLARE punct CHAR(17) DEFAULT ' ()[]{},.-_!@;:?/';

		SET s = LCASE( str );

		WHILE i <= LENGTH( str ) DO
		BEGIN

			SET c = SUBSTRING( s, i, 1 );

			IF LOCATE( c, punct ) > 0 THEN
				SET bool = 1;
			ELSEIF bool=1 THEN
			BEGIN
				IF c >= 'a' AND c <= 'z' THEN
				BEGIN
					SET s = CONCAT(LEFT(s,i-1),UCASE(c),SUBSTRING(s,i+1));
					SET bool = 0;
				END;
			ELSEIF c >= '0' AND c <= '9' THEN
				SET bool = 0;
			END IF;
			END;
			END IF;
			SET i = i+1;
			END;
		END WHILE;

		RETURN s;

	END;
|

DELIMITER ;


-- ** Customer Module ** --
-- create the Customer table
CREATE TABLE Customer
(
	Customer_Id        	INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
	Last_Name  			VARCHAR(50),
	First_Name  		VARCHAR(50),
	Middle_Name  		VARCHAR(20),
	Phone  				VARCHAR(50),
    Email varchar(100)
);
-- create the Address table
CREATE TABLE Address
(
	Address_Id        	INT	          NOT NULL AUTO_INCREMENT PRIMARY KEY,
	Customer_Id       	INT				REFERENCES Customer (Customer_Id),
	Address_Type_Id   	INT    			REFERENCES Address_Type (Address_Type_Id),
	Address_1   		VARCHAR(50),
	Address_2  			VARCHAR(50),
	City  				VARCHAR(50),
	State  				VARCHAR(2),
	Zip  				VARCHAR(10),
	Country  			VARCHAR(50)
);


-- create the Address_Type table
CREATE TABLE Address_Type
(
	Address_Type_Id		INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
	Description 		VARCHAR(50)
);


-- create the Shipping table
CREATE TABLE Shipping
(
	Shipping_Id			INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
	Description 		VARCHAR(50),
	Shipping_Cost		DECIMAL(6,2)
);


-- ** Invoice Module ** --
-- create the Invoice table
CREATE TABLE Invoice
(
Invoice_Id				INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
Customer_Id				INT				REFERENCES Customer (Customer_Id),
Shipping_Id				INT				REFERENCES Shipping (Shipping_Id),
Create_Date				DATE,
Invoice_Line_Total		DECIMAL(10,2),
Shipping_Charge			DECIMAL(10,2),
Invoice_Total			DECIMAL(10,2),
Payment_Due_Date		DATE,
Payment_Date			DATE
);

-- create the Invoice_Detail table
CREATE TABLE Invoice_Detail
(
Invoice_Detail_Id		INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
Invoice_Id				INT				REFERENCES Invoice (Invoice_Id),
Product_Id				INT				REFERENCES Product (Product_Id),
Qty						INT
);


-- create the Temporary Dates table
CREATE TABLE Temp_Dates
(
Temp_Dates_Id			INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
Create_Date				DATE,
Payment_Due_Date		DATE,
Payment_Date			DATE
);

-- ** Product Module ** --
-- create the Product table
CREATE TABLE Product
(
Product_Id				INT	          NOT NULL AUTO_INCREMENT PRIMARY KEY,
Description				VARCHAR(200),
Price					DECIMAL(10,2),
Product_Type_Id			INT				REFERENCES Address_Type (Address_Type_Id)
);

-- create the Product_Type table
CREATE TABLE Product_Type
(
Prod_Type_Id			INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
Description				VARCHAR(50)
);


-- create the State table
CREATE TABLE State
(
State_Id			INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
State				VARCHAR(50),
StateAbbr			VARCHAR(2)
);

-- Build address_type table
insert into address_type (Description)
values('Physical'), ('Mailing'), ('Both');


insert into Shipping (Description, Shipping_Cost)
values ('USPS Priority',0.05),
	   ('UPS ground',0.04),
	   ('UPS second day',0.07),
	   ('UPS next day',0.09),
	   ('FedEx',0.10);

-- Build State table
insert into State (State, StateAbbr)
values ('Alabama','AL'),
	   ('Alaska','AK'),
	   ('Arizona','AZ'),
	   ('Arkansas','AR'),
	   ('California','CA'),
	   ('Colorado','CO'),
	   ('Connecticut','CT'),
	   ('Delaware','DE'),
	   ('Florida','FL'),
	   ('Georgia','GA'),
	   ('Hawaii','HI'),
	   ('Idaho','ID'),
	   ('Illinois','IL'),
	   ('Indiana','IN'),
	   ('Iowa','IA'),
	   ('Kansas','KS'),
	   ('Kentucky','KY'),
	   ('Louisiana','LA'),
	   ('Maine','ME'),
	   ('Maryland','MD'),
	   ('Massachusetts','MA'),
	   ('Michigan','MI'),
	   ('Minnesota','MN'),
	   ('Mississippi','MS'),
	   ('Missouri','MO'),
	   ('Montana','MT'),
	   ('Nebraska','NE'),
	   ('Nevada','NV'),
	   ('New Hampshire','NH'),
	   ('New Jersey','NJ'),
	   ('New Mexico','NM'),
	   ('New York','NY'),
	   ('North Carolina','NC'),
	   ('North Dakota','ND'),
	   ('Ohio','OH'),
	   ('Oklahoma','OK'),
	   ('Oregon','OR'),
	   ('Pennsylvania','PA'),
	   ('Rhode Island','RI'),
	   ('South Carolina','SC'),
	   ('South Dakota','SD'),
	   ('Tennessee','TN'),
	   ('Texas','TX'),
	   ('Utah','UT'),
	   ('Vermont','VT'),
	   ('Virginia','VA'),
	   ('Washington','WA'),
	   ('West Virginia','WV'),
	   ('Wisconsin','WI'),
	   ('Wyoming','WY'),
	   ('American Samoa','AS'),
	   ('District of Columbia','DC'),
	   ('Federated States of Micronesia','FM'),
	   ('Guam','GU'),
	   ('Marshall Islands','MH'),
	   ('Northern Mariana Islands','MP'),
	   ('Palau','PW'),
	   ('Puerto Rico','PR'),
	   ('Virgin Islands','VI'),
	   ('Armed Forces Africa','AE'),
	   ('Armed Forces Americas','AA'),
	   ('Armed Forces Canada','AE'),
	   ('Armed Forces Europe','AE'),
	   ('Armed Forces Middle East','AE'),
	   ('Armed Forces Pacific','AP');


-- Change statement delimiter from semicolon to double front slash
DELIMITER //

-- Pull over addresses from Sakila

CREATE PROCEDURE CustomerAddressBuild()
BEGIN

declare _first_name varchar(50);
declare _last_name varchar(50);
declare _address varchar(100);
declare _address2 varchar(100);
declare _city varchar(50);
declare _state varchar(2);
declare _postal_code varchar(50);
declare _phone varchar(50);
declare _email varchar(100);
DECLARE _done BOOLEAN;


declare getCustomer cursor for
	SELECT first_name, last_name, email, address, address2, city, StateAbbr as state, postal_code, phone
	FROM sakila.customer cust
	join sakila.address a on cust.address_id = a.address_id
	join sakila.city c on a.city_id = c.city_id
    join ShawCakes.state s on s.State = a.district
	where c.country_id = 103;

declare continue handler for not found set _done=true;

    set _done = false;
    open getCustomer;
    custLoop: loop
        fetch getCustomer into  _first_name, _last_name, _email, _address, _address2, _city, _state, _postal_code, _phone;
        if _done = true then leave custLoop; end if;

		insert into ShawCakes.customer(Last_Name, First_Name, Phone, Email)
        values(proper(_last_name), proper(_first_name), _phone, _email);

		insert into ShawCakes.address(Customer_Id, Address_Type_Id, Address_1, Address_2, City, State, Zip, Country)
        values(LAST_INSERT_ID(), 3, proper(_address), proper(_address2), _city, _state, _postal_code, 'USA');

    end loop custLoop;
    close getCustomer;

END//

-- Change statement delimiter from semicolon to double front slash
DELIMITER ;

CALL CustomerAddressBuild();

DROP PROCEDURE IF EXISTS CustomerAddressBuild;



SET SQL_SAFE_UPDATES = 0;

-- Update email
update ShawCakes.customer
set email = concat(First_Name, Last_Name, '@ShawCakes.com');

-- Fix Addresses

update ShawCakes.address
set Address_1 = REPLACE(Address_1, '.',''),
    Address_2 = REPLACE(Address_2, '.','');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, ',',''),
    Address_2 = REPLACE(Address_2, ',','');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, '#',''),
    Address_2 = REPLACE(Address_2, '#','');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, 'North ','N '),
    Address_2 = REPLACE(Address_2, 'North ','N ');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, 'East ','E '),
    Address_2 = REPLACE(Address_2, 'East ','E ');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, 'South ','S '),
    Address_2 = REPLACE(Address_2, 'South ','S ');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, 'West ','W '),
    Address_2 = REPLACE(Address_2, 'West ','W ');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, 'Ne ','NE '),
    Address_2 = REPLACE(Address_2, 'Ne ','NE ');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, 'Nw ','NW '),
    Address_2 = REPLACE(Address_2, 'Nw ','NW ');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, 'Se ','SE '),
    Address_2 = REPLACE(Address_2, 'Se ','SE ');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, 'Sw ','SW '),
    Address_2 = REPLACE(Address_2, 'Sw ','SW ');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, 'Po Box','PO Box'),
    Address_2 = REPLACE(Address_2, 'Po Box','PO Box');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, 'P O Box','PO Box'),
    Address_2 = REPLACE(Address_2, 'P O Box','PO Box');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, 'POBox','PO Box'),
    Address_2 = REPLACE(Address_2, 'POBox','PO Box');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, 'Po ','PO Box'),
    Address_2 = REPLACE(Address_2, 'Po ','PO Box');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, 'Rr ','RR '),
    Address_2 = REPLACE(Address_2, 'Rr ','RR ');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, '1St ','1st '),
    Address_2 = REPLACE(Address_2, '1St ','1st ');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, '2Nd ','2nd '),
    Address_2 = REPLACE(Address_2, '2Nd ','2nd ');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, '3Rd ','3rd '),
    Address_2 = REPLACE(Address_2, '3Rd ','3rd ');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, '4Th ','4th '),
    Address_2 = REPLACE(Address_2, '4Th ','4th ');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, '5Th ','5th '),
    Address_2 = REPLACE(Address_2, '5Th ','5th ');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, '6Th ','6th '),
    Address_2 = REPLACE(Address_2, '6Th ','6th ');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, '7Th ','7th '),
    Address_2 = REPLACE(Address_2, '7Th ','7th ');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, '8Th ','8th '),
    Address_2 = REPLACE(Address_2, '8Th ','8th ');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, '9Th ','9th '),
    Address_2 = REPLACE(Address_2, '9Th ','9th ');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, '0Th ','0th '),
    Address_2 = REPLACE(Address_2, '0Th ','0th ');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, '1Th ','1th '),
    Address_2 = REPLACE(Address_2, '1Th ','1th ');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, '2Th ','2th '),
    Address_2 = REPLACE(Address_2, '2Th ','2th ');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, '3Th ','3th '),
    Address_2 = REPLACE(Address_2, '3Th ','3th ');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, 'Apartment','Apt'),
    Address_2 = REPLACE(Address_2, 'Apartment','Apt');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, 'Avenue','Ave'),
    Address_2 = REPLACE(Address_2, 'Avenue','Ave');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, ' Boulevard',' Blvd'),
    Address_2 = REPLACE(Address_2, ' Boulevard',' Blvd');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, ' Building',' Bldg'),
    Address_2 = REPLACE(Address_2, ' Building',' Bldg');


update ShawCakes.address
set Address_1 = REPLACE(Address_1, ' Circle',' Cr'),
    Address_2 = REPLACE(Address_2, ' Circle',' Cr');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, ' Court',' Ct'),
    Address_2 = REPLACE(Address_2, ' Court',' Ct');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, ' Loop',' Lp'),
    Address_2 = REPLACE(Address_2, ' Loop',' Lp');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, ' Manor',' Mn'),
    Address_2 = REPLACE(Address_2, ' Manor',' Mn');


update ShawCakes.address
set Address_1 = REPLACE(Address_1, ' Cove',' Cv'),
    Address_2 = REPLACE(Address_2, ' Cove',' Cv');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, 'Drive','Dr'),
    Address_2 = REPLACE(Address_2, 'Drive','Dr');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, 'Highway','Hwy'),
    Address_2 = REPLACE(Address_2, 'Highway','Hwy');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, ' Id-',' ID-'),
    Address_2 = REPLACE(Address_2, ' Id-',' ID-');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, ' Lane',' Ln'),
    Address_2 = REPLACE(Address_2, ' Lane',' Ln');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, 'Parkway','Pkwy'),
    Address_2 = REPLACE(Address_2, 'Parkway','Pkwy');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, ' Place',' Pl'),
    Address_2 = REPLACE(Address_2, ' Place',' Pl');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, 'Road','Rd'),
    Address_2 = REPLACE(Address_2, 'Road','Rd');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, 'Street','St'),
    Address_2 = REPLACE(Address_2, 'Street','St');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, 'Suite','Ste'),
    Address_2 = REPLACE(Address_2, 'Suite','Ste');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, ' Us-',' US-'),
    Address_2 = REPLACE(Address_2, ' Us-',' US-');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, ' Us ',' US '),
    Address_2 = REPLACE(Address_2, ' Us ',' US ');

update ShawCakes.address
set Address_1 = REPLACE(Address_1, ' Way',' Wy'),
    Address_2 = REPLACE(Address_2, ' Way',' Wy');

-- Insert Products

insert into Product_Type (Description)
values('Equipment/tools') 		-- 1
	, ('Vintage/Antique')		-- 2
	, ('Electronics')			-- 3
	, ('Housewares')			-- 4
	, ('Appliances')			-- 5
	, ('Entertainment')			-- 6
	, ('Clothing/Shoes')		-- 7
	, ('Jewelry')				-- 8
	, ('Decor')					-- 9
	, ('Sporting Goods')		-- 10
    ;

insert into Product (Description, Price, Product_Type_Id)
values ('Struck Magnatrac Crawler/ Loader Briggs & Stratton 18 Twin Motor, Rear Box w/ Weight, 48" Front Loader, 54" Blade, 50" Ripper, Extra Tracks, New Battery',1510.96, 1),
	   ('Tractor 3 Point Hitch Receiver Hitch w/ Pin',25.00, 1),
	   ('Lawn/Garden/Gravel Rake on Wheels Pulls Behind Lawn Tractor/ATV 40" Wide (1 7/8" Hitch)',9.00, 1),
	   ('Leinbach 3 Point Post Auger w/ 6" Auger',86.00, 1),
	   ('Werner 12 Ft Fiberglass Ladder',53.50, 1),
	   ('Manual Hoist Cable Style Forks Adjust 20" wide to 28 1/2" wide 44" High Lift',27.00, 1),
	   ('Metal Shelf/Rack on Wheels Approx 50" Wide x 45" Tall',6.00, 1),
	   ('Emerald Parts Washer Model E230 Approx 34" x 27" x 38" tall ',31.00, 1),
	   ('New Wonder Hitch For Gooseneck/5th Wheel Trailers 26,000 lb Max Capacity',16.00, 1),
	   ('New RV Gooseneck 5th Wheel Hitch Adapter 24,000lbs Max Capacity',58.50, 1),
	   ('New Reese Receiver Hitch Titan Series Fits Ford 250, 1999 Class V',7.00, 1),
	   ('New Reese Receiver Hitch Titan Series Fits Chevy 1999-2004',6.00, 1),
	   ('Vintage Tins: Coffee, Tobacco, Spice, Syrup 7 pc lot *1 Tin has Grease Contents',6.00, 2),
	   ('Vintage Washboard Made Rite No. 2062 Approx 12 1/2" wide x 24" tall',17.00, 2),
	   ('Tiffany Style Lamp Approx 11 1/2" Diameter 19" Tall',23.00, 2),
	   ('Lamp w/ Crackle Glass Shade Approx 12" diameter x 27" tall',11.00, 2),
	   ('Panasonic CD Stereo System Model SA-EN17 Am/Fm, MP3, CD',9.00, 3),
	   ('Candle Warmers, Lavender & Vanilla Burner Candles, Bath Salts, Shower Gels, Bath Creams and More',7.00, 4),
	   ('Crock Pot Slow Cooker Rival 3760',11.00, 5),
	   ('Poker Chips w/ Revolving Rack & Cards',5.00, 6),
	   ('Winchester Belt Buckle', 6.00, 7),
	   ('3/4 Grooved Axe from Nebraska', 51.00, 1),
	   ('Arrowhead from Klamath Falls Oregon 1 3/4" long', 15.00, 2),
	   ('Bracelet Malachite Sterling Silver Taxco', 11.00, 8),
	   ('Vintage Magic Pocket Lamp, Koopmans', 9.69, 2),
	   ('Native American Ring Size 9.5 Turquoise, Sterling', 5.00, 8),
	   ('Custom Navajo Ring Size 5.75 Red Coral, Kingman', 6.00, 8),
	   ('Native American Ring Size 8.75 Multi Stone Inlay', 5.00, 8),
	   ('Vintage Ring, Size Adjustable: Red Coral', 5.00, 8),
	   ('Vintage Navajo Ring Size 5 Turquoise, Sterling', 6.00, 8),
	   ('Hotpoint Side/Side Refrigerator 19.7 cu ft White Approx. 30 1/2" wide x 29" deep x 68" tall',26.00, 5),
	   ('Stainless Steel Measuring Cups, Vintage Chopper. Silver Plate Serving Spoons, Old Bottles.',5.00, 4),
	   ('Salad Spinner, Waffle Iron, B&D Steam Iron',5.00, 5),
	   ('Blankets, Throws, Twin Mattress Pad, Pillows',6.00, 4),
	   ('Scarff & Gloves',5.00, 7),
	   ('Pier-1 Decorative Plate, Metal 24" Decorative Wall',6.00, 9),
	   ('Vintage Golf Clubs: 5 Irons, 4 Woods, Bag',5.00, 10),
	   ('Art Deco Diamond Pendant 14K White Gold Approx. 1.75 CT Diamonds C. 1920s. Approx. 7.4 grams',147.19, 8),
	   ('Pendant 14K Gold Diamonds & Rubies',15.00, 8),
	   ('Assorted Cabochon Natural Gemstones Approx. 51.32',23.69, 8);


DELIMITER //

-- Build invoices

CREATE PROCEDURE ShawCakes.InvoiceBuild()
BEGIN

declare _number_cust int;
declare _number_prod int;
declare _number_ship int;
declare _rand_cust_id int;
declare _rand_prod_id int;
declare _rand_ship_id int;
declare _rand_day int;
declare _rand_pay_day int;
declare _rand_qty int;
declare _invoice_date date;
declare _invoice_pay_date date;
declare _count_tries int default 0;
declare _current_invoice_id int;
declare _number_invoice_lines int default 1;
declare _count_invoice_lines int;
declare _item_price decimal(10,2);
declare _line_price decimal(10,2);
declare _invoice_line_total DECIMAL(10,2) default 0.0;
declare _shipping_charge DECIMAL(10,2) default 0.0;
declare _invoice_total DECIMAL(10,2) default 0.0;
declare _check_exists int;


 select count(*) into _number_cust
 from ShawCakes.customer;

 select count(*) into _number_prod
 from ShawCakes.Product;

 select count(*) into _number_ship
 from ShawCakes.Shipping;


 -- start invoice build loops


   invoice_header: REPEAT
     SET _count_tries = _count_tries + 1;
	 SET _rand_cust_id = FLOOR(RAND()*(_number_cust-1+1))+1;
	 SET _rand_ship_id = FLOOR(RAND()*(_number_ship-1+1))+1;
     SET _rand_day = -1 * (FLOOR(RAND()*(90-1+1))+1);
     SET _rand_pay_day = FLOOR(RAND()*(60-1+1))+1;
     SET _invoice_date = cast(DATE_ADD(now(), INTERVAL _rand_day DAY) as date);
     SET _invoice_pay_date = cast(DATE_ADD(_invoice_date, INTERVAL _rand_pay_day DAY) as date);
     insert into Invoice (Customer_Id, Create_Date,	Invoice_Total,Payment_Due_Date,Payment_Date,Shipping_Id)
				values (_rand_cust_id, _invoice_date, 0.0, cast(DATE_ADD(_invoice_date, INTERVAL 30 DAY) as date),_invoice_pay_date, _rand_ship_id);

	 SET _current_invoice_id = LAST_INSERT_ID();
     SET _count_invoice_lines = 0;
     SET _number_invoice_lines = FLOOR(RAND()*(5-1+1))+1;
	 SET _invoice_line_total = 0;

	 invoice_line: REPEAT
		SET _count_invoice_lines = _count_invoice_lines + 1;
		SET _rand_prod_id = FLOOR(RAND()*(_number_prod-1+1))+1;
		SET _rand_qty = FLOOR(RAND()*(3-1+1))+1;

        SELECT count(*) INTO _check_exists
        FROM Invoice_Detail
		WHERE Invoice_Id = _current_invoice_id
		AND Product_Id = _rand_prod_id;

        IF (_check_exists  = 0) THEN

			SELECT Price into _item_price
			FROM Product
			WHERE Product_Id = _rand_prod_id;

			SET _line_price = _item_price * _rand_qty;
			SET _invoice_line_total = _invoice_line_total + _line_price;

			insert into Invoice_Detail (Invoice_Id, Product_Id,Qty)
								values (_current_invoice_id, _rand_prod_id, _rand_qty);
		END IF;
	 UNTIL _count_invoice_lines >= _number_invoice_lines
	 END REPEAT invoice_line;


    select (_invoice_line_total * s.Shipping_Cost) into _shipping_charge
	from Invoice as inv
	join Shipping as s on inv.Shipping_Id = s.Shipping_Id
	where inv.Invoice_Id = _current_invoice_id;

	set _invoice_total = _invoice_line_total + _shipping_charge;

	update Invoice
		set Invoice_Line_Total = _invoice_line_total,
			Shipping_Charge = _shipping_charge,
			Invoice_Total = _invoice_total
	where Invoice_Id = _current_invoice_id;

   UNTIL _count_tries >= 100
   END REPEAT invoice_header;


END//

DELIMITER ;


CALL ShawCakes.InvoiceBuild();

DROP PROCEDURE IF EXISTS ShawCakes.InvoiceBuild;

UPDATE ShawCakes.invoice
SET Payment_Date = null
where Payment_Date > now();

insert into Temp_Dates (Create_Date,
	Payment_Due_Date,
	Payment_Date)
select Create_Date,
	Payment_Due_Date,
	Payment_Date
from invoice
Order by Create_Date;

UPDATE ShawCakes.Invoice inv JOIN ShawCakes.Temp_Dates td ON inv.Invoice_Id = td.Temp_Dates_Id
 SET inv.Create_Date = td.Create_Date,
	 inv.Payment_Due_Date = td.Payment_Due_Date,
     inv.Payment_Date = td.Payment_Date;


Drop Table ShawCakes.Temp_Dates
