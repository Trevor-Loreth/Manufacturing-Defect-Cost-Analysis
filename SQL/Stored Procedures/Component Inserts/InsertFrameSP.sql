CREATE OR ALTER PROCEDURE InsertFrame
    @FrameSerialNumber VARCHAR(50),
    @Factory VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UnitCost DECIMAL(10,2);

    SELECT @UnitCost = [Unit Cost]
    FROM [Factory Costs]
    WHERE Component = 'Frame'
      AND Factory = @Factory;

    IF @UnitCost IS NULL
    BEGIN
        RAISERROR('No unit cost found for this Frame factory.', 16, 1);
        RETURN;
    END;

    INSERT INTO Frame
    (
        [Frame Serial #],
        Factory,
        [Unit Cost]
    )
    VALUES
    (
        @FrameSerialNumber,
        @Factory,
        @UnitCost
    );
END;