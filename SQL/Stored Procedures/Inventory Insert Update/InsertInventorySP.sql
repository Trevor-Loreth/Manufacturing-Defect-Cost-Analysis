CREATE OR ALTER PROCEDURE InsertInventory
    @ProductSerialNumber VARCHAR(50),
    @BladesSerialNumber VARCHAR(50),
    @MotorSerialNumber VARCHAR(50),
    @FrameSerialNumber VARCHAR(50),
    @AssemblyCost DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;

    -- Check that the product serial number does not already exist
    IF EXISTS (
        SELECT 1
        FROM Inventory
        WHERE [Product Serial #] = @ProductSerialNumber
    )
    BEGIN
        RAISERROR('This Product Serial Number already exists in Inventory.', 16, 1);
        RETURN;
    END;

    -- Check that the blade exists
    IF NOT EXISTS (
        SELECT 1
        FROM Blades
        WHERE [Blades Serial #] = @BladesSerialNumber
    )
    BEGIN
        RAISERROR('The Blades Serial Number does not exist in the Blades table.', 16, 1);
        RETURN;
    END;

    -- Check that the motor exists
    IF NOT EXISTS (
        SELECT 1
        FROM Motor
        WHERE [Motor Serial #] = @MotorSerialNumber
    )
    BEGIN
        RAISERROR('The Motor Serial Number does not exist in the Motor table.', 16, 1);
        RETURN;
    END;

    -- Check that the frame exists
    IF NOT EXISTS (
        SELECT 1
        FROM Frame
        WHERE [Frame Serial #] = @FrameSerialNumber
    )
    BEGIN
        RAISERROR('The Frame Serial Number does not exist in the Frame table.', 16, 1);
        RETURN;
    END;

    -- Insert into Inventory
    INSERT INTO Inventory
    (
        [Product Serial #],
        [Blades Serial #],
        [Motor Serial #],
        [Frame Serial #],
        [Assembly Cost]
    )
    VALUES
    (
        @ProductSerialNumber,
        @BladesSerialNumber,
        @MotorSerialNumber,
        @FrameSerialNumber,
        @AssemblyCost
    );
END;