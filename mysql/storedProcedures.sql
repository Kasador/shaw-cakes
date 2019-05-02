USE shawcakes;

DELIMITER //

DROP PROCEDURE IF EXISTS GetProductId//

CREATE PROCEDURE GetProductId
(
	in p_Product_Id int
)

BEGIN

	SELECT
		p.Product_Id,
        p.Description as ProdDesc,
        p.Price,
        pt.Description as ProdDescType
	FROM
		product p
	JOIN
		product_type pt
	ON
		p.Product_Type_Id = pt.Prod_Type_Id
	WHERE
		p.Product_Id = p_Product_Id;

END//

DELIMITER ;



DELIMITER //

DROP PROCEDURE IF EXISTS GetProductInfo//

CREATE PROCEDURE GetProductInfo()

BEGIN

	SELECT
		p.Product_Id,
        p.Description as ProdDesc,
        p.Price,
        pt.Description as ProdDescType
	FROM
		product p
	JOIN
		product_type pt
	ON
		p.Product_Type_Id = pt.Prod_Type_Id;

END//

DELIMITER ;



DELIMITER //

DROP PROCEDURE IF EXISTS GetProductType//

CREATE PROCEDURE GetProductType()

BEGIN

	SELECT
		Prod_Type_Id,
        Description as ProdTypeDesc
	FROM
		product_type
	ORDER BY
		Description;

END//

DELIMITER ;



DELIMITER //

DROP PROCEDURE IF EXISTS InsertProduct//

CREATE PROCEDURE InsertProduct
(
	in p_Description VARCHAR(50),
    in p_Price DECIMAL(10, 2),
    in p_Product_Type_Id INT
)

BEGIN

	INSERT INTO product (Description, Price, Product_Type_Id)
		VALUES (p_Description, p_Price, p_Product_Type_Id);

END//

DELIMITER ;



DELIMITER //

DROP PROCEDURE IF EXISTS UpdateProduct//

CREATE PROCEDURE UpdateProduct
(
	in p_Product_Id INT,
	in p_Description VARCHAR(50),
    in p_Price DECIMAL(10, 2),
    in p_Product_Type_Id INT
)

BEGIN

	UPDATE shawcakes.product
		SET Description = p_Description,
			Price = p_Price,
            Product_Type_Id = p_Product_Type_Id
	WHERE
		Product_Id = p_Product_Id;

END//

DELIMITER ;



DELIMITER //

DROP PROCEDURE IF EXISTS GetProductId//

CREATE PROCEDURE GetProductId()

BEGIN

	SELECT
		Product_Id
	FROM
		product
	ORDER BY
		Product_Id;

END//

DELIMITER ;



DELIMITER //

DROP PROCEDURE IF EXISTS GetProductInfoById//

CREATE PROCEDURE GetProductInfoById
(
	in p_Product_Id INT
)

BEGIN

	SELECT
        p.Description as ProdDesc,
        p.Price,
        pt.Description as ProdDescType
	FROM
		product p
	JOIN
		product_type pt
	ON
		p.Product_Type_Id = pt.Prod_Type_Id
	WHERE
		p.Product_Id = p_Product_Id;

END//

DELIMITER ;



DELIMITER //

DROP PROCEDURE IF EXISTS DeleteProduct//

CREATE PROCEDURE DeleteProduct
(
	in p_Product_Id INT
)

BEGIN

	DELETE FROM
		product
	WHERE
		product.Product_Id = p_Product_Id;

END//

DELIMITER ;
