CREATE OR ALTER PROCEDURE InsertMotor
    @MotorSerialNumber VARCHAR(50),
    @Factory VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UnitCost DECIMAL(10,2);

    SELECT @UnitCost = [Unit Cost]
    FROM [Factory Costs]
    WHERE Component = 'Motor'
      AND Factory = @Factory;

    IF @UnitCost IS NULL
    BEGIN
        RAISERROR('No unit cost found for this Motor factory.', 16, 1);
        RETURN;
    END;

    INSERT INTO Motor
    (
        [Motor Serial #],
        Factory,
        [Unit Cost]
    )
    VALUES
    (
        @MotorSerialNumber,
        @Factory,
        @UnitCost
    );
END;