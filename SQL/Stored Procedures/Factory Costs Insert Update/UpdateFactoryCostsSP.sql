CREATE OR ALTER PROCEDURE UpdateFactoryCost
    @Component VARCHAR(50),
    @Factory VARCHAR(100),
    @NewUnitCost DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OldUnitCost DECIMAL(10,2);

    -- Validate Component
    IF @Component NOT IN ('Blades', 'Motor', 'Frame')
    BEGIN
        RAISERROR('Invalid component. Component must be Blades, Motor, or Frame.', 16, 1);
        RETURN;
    END;

    -- Validate New Unit Cost
    IF @NewUnitCost <= 0
    BEGIN
        RAISERROR('Unit Cost must be greater than 0.', 16, 1);
        RETURN;
    END;

    -- Get the existing unit cost
    SELECT @OldUnitCost = [Unit Cost]
    FROM [Factory Costs]
    WHERE Component = @Component
      AND Factory = @Factory;

    -- Make sure the factory/component combo exists
    IF @OldUnitCost IS NULL
    BEGIN
        RAISERROR('No matching component and factory combination was found in Factory Costs.', 16, 1);
        RETURN;
    END;

    -- Update the Factory Costs table
    UPDATE [Factory Costs]
    SET [Unit Cost] = @NewUnitCost
    WHERE Component = @Component
      AND Factory = @Factory;

    -- Return confirmation
    SELECT
        @Component AS Component,
        @Factory AS Factory,
        @OldUnitCost AS [Old Unit Cost],
        @NewUnitCost AS [New Unit Cost];
END;