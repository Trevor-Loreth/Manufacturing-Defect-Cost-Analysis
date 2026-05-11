CREATE OR ALTER PROCEDURE InsertSale
    @SalesID NVARCHAR(255),
    @ProductSerialNumber NVARCHAR(255),
    @Price MONEY = 200.00,
    @SaleDate DATETIME = NULL,
    @CountryShippedTo NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Cost MONEY;

    -- Default sale date to today if no date is provided
    IF @SaleDate IS NULL
    BEGIN
        SET @SaleDate = GETDATE();
    END;

    -- Validate Sales ID
    IF @SalesID IS NULL OR LTRIM(RTRIM(@SalesID)) = ''
    BEGIN
        RAISERROR('Sales ID cannot be blank.', 16, 1);
        RETURN;
    END;

    -- Validate Product Serial Number
    IF @ProductSerialNumber IS NULL OR LTRIM(RTRIM(@ProductSerialNumber)) = ''
    BEGIN
        RAISERROR('Product Serial Number cannot be blank.', 16, 1);
        RETURN;
    END;

    -- Validate price
    IF @Price <= 0
    BEGIN
        RAISERROR('Price must be greater than 0.', 16, 1);
        RETURN;
    END;

    -- Check that Sales ID does not already exist
    IF EXISTS (
        SELECT 1
        FROM Sales
        WHERE [Sales ID] = @SalesID
    )
    BEGIN
        RAISERROR('This Sales ID already exists.', 16, 1);
        RETURN;
    END;

    -- Check that product exists in Inventory
    IF NOT EXISTS (
        SELECT 1
        FROM Inventory
        WHERE [Product Serial #] = @ProductSerialNumber
    )
    BEGIN
        RAISERROR('This Product Serial Number does not exist in Inventory.', 16, 1);
        RETURN;
    END;

    -- Prevent same product from being sold twice
    IF EXISTS (
        SELECT 1
        FROM Sales
        WHERE [Product Serial #] = @ProductSerialNumber
    )
    BEGIN
        RAISERROR('This Product Serial Number has already been sold.', 16, 1);
        RETURN;
    END;

    -- Calculate cost from component unit costs + assembly cost
    SELECT
        @Cost =
              CAST(b.[Unit Cost] AS MONEY)
            + CAST(m.[Unit Cost] AS MONEY)
            + CAST(f.[Unit Cost] AS MONEY)
            + CAST(i.[Assembly Cost] AS MONEY)
    FROM Inventory AS i
    INNER JOIN Blades AS b
        ON i.[Blades Serial #] = b.[Blades Serial #]
    INNER JOIN Motor AS m
        ON i.[Motor Serial #] = m.[Motor Serial #]
    INNER JOIN Frame AS f
        ON i.[Frame Serial #] = f.[Frame Serial #]
    WHERE i.[Product Serial #] = @ProductSerialNumber;

    -- Safety check
    IF @Cost IS NULL
    BEGIN
        RAISERROR('Cost could not be calculated. Check Inventory and component relationships.', 16, 1);
        RETURN;
    END;

    -- Insert sale
    INSERT INTO Sales
    (
        [Sales ID],
        [Product Serial #],
        Price,
        Cost,
        [Date],
        [Location: Country shipped to]
    )
    VALUES
    (
        @SalesID,
        @ProductSerialNumber,
        @Price,
        @Cost,
        @SaleDate,
        @CountryShippedTo
    );

    -- Confirmation output
    SELECT
        @SalesID AS [Sales ID],
        @ProductSerialNumber AS [Product Serial #],
        @Price AS Price,
        @Cost AS Cost,
        @SaleDate AS [Date],
        @CountryShippedTo AS [Location: Country shipped to],
        @Price - @Cost AS [Profit Before Returns];
END;