CREATE OR ALTER PROCEDURE InsertBlade
    @BladesSerialNumber VARCHAR(50),
    @Factory VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UnitCost DECIMAL(10,2);

    SELECT @UnitCost = [Unit Cost]
    FROM [Factory Costs]
    WHERE Component = 'Blades'
      AND Factory = @Factory;

    IF @UnitCost IS NULL
    BEGIN
        RAISERROR('No unit cost found for this Blades factory.', 16, 1);
        RETURN;
    END;

    INSERT INTO Blades
    (
        [Blades Serial #],
        Factory,
        [Unit Cost]
    )
    VALUES
    (
        @BladesSerialNumber,
        @Factory,
        @UnitCost
    );
END;