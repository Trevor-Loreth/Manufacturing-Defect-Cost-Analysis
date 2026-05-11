CREATE OR ALTER PROCEDURE InsertReturn
    @ProductSerialNumber NVARCHAR(255),
    @DefectYN NVARCHAR(255),
    @DefectPart NVARCHAR(255) = NULL,
    @RefundAmount MONEY = 0.00,
    @ReturnDate DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Default return date to today if no date is provided
    IF @ReturnDate IS NULL
    BEGIN
        SET @ReturnDate = GETDATE();
    END;

    -- Validate Product Serial Number
    IF @ProductSerialNumber IS NULL OR LTRIM(RTRIM(@ProductSerialNumber)) = ''
    BEGIN
        RAISERROR('Product Serial Number cannot be blank.', 16, 1);
        RETURN;
    END;

    -- Validate Defect y/n
    IF LOWER(LTRIM(RTRIM(@DefectYN))) NOT IN ('y', 'n')
    BEGIN
        RAISERROR('Defect y/n must be either y or n.', 16, 1);
        RETURN;
    END;

    -- Normalize Defect y/n to lowercase
    SET @DefectYN = LOWER(LTRIM(RTRIM(@DefectYN)));

    -- Validate refund amount
    IF @RefundAmount < 0
    BEGIN
        RAISERROR('Refund Amount cannot be negative.', 16, 1);
        RETURN;
    END;

    -- Make sure product exists in Inventory
    IF NOT EXISTS (
        SELECT 1
        FROM Inventory
        WHERE [Product Serial #] = @ProductSerialNumber
    )
    BEGIN
        RAISERROR('This Product Serial Number does not exist in Inventory.', 16, 1);
        RETURN;
    END;

    -- Make sure product was sold before it can be returned
    IF NOT EXISTS (
        SELECT 1
        FROM Sales
        WHERE [Product Serial #] = @ProductSerialNumber
    )
    BEGIN
        RAISERROR('This Product Serial Number has not been sold, so it cannot be returned.', 16, 1);
        RETURN;
    END;

    -- Prevent duplicate returns for the same product
    IF EXISTS (
        SELECT 1
        FROM Returns
        WHERE [Product Serial #] = @ProductSerialNumber
    )
    BEGIN
        RAISERROR('This Product Serial Number already has a return record.', 16, 1);
        RETURN;
    END;

    -- If defect = y, require a valid defect part
    IF @DefectYN = 'y'
    BEGIN
        IF @DefectPart IS NULL OR LTRIM(RTRIM(@DefectPart)) = ''
        BEGIN
            RAISERROR('Defect Part is required when Defect y/n = y.', 16, 1);
            RETURN;
        END;

        IF @DefectPart NOT IN ('Blades', 'Motor', 'Frame', 'Assembly', 'Other')
        BEGIN
            RAISERROR('Invalid Defect Part. Use Blades, Motor, Frame, Assembly, or Other.', 16, 1);
            RETURN;
        END;
    END;

    -- If defect = n, set Defect Part to NULL
    IF @DefectYN = 'n'
    BEGIN
        SET @DefectPart = NULL;
    END;

    -- Insert return record
    INSERT INTO Returns
    (
        [Product Serial #],
        [Defect: y/n],
        [Defect Part],
        [Refund Amount],
        [Return Date]
    )
    VALUES
    (
        @ProductSerialNumber,
        @DefectYN,
        @DefectPart,
        @RefundAmount,
        @ReturnDate
    );

    -- Confirmation output
    SELECT
        @ProductSerialNumber AS [Product Serial #],
        @DefectYN AS [Defect y/n],
        @DefectPart AS [Defect Part],
        @RefundAmount AS [Refund Amount],
        @ReturnDate AS [Return Date];
END;