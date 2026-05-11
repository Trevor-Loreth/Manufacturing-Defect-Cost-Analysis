CREATE OR ALTER PROCEDURE InsertFactoryCost
    @Component VARCHAR(50),
    @Factory VARCHAR(100),
    @UnitCost DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate component
    IF @Component NOT IN ('Blades', 'Motor', 'Frame')
    BEGIN
        RAISERROR('Invalid component. Component must be Blades, Motor, or Frame.', 16, 1);
        RETURN;
    END;

    -- Validate unit cost
    IF @UnitCost <= 0
    BEGIN
        RAISERROR('Unit Cost must be greater than 0.', 16, 1);
        RETURN;
    END;

    -- Prevent duplicate component/factory combinations
    IF EXISTS (
        SELECT 1
        FROM [Factory Costs]
        WHERE Component = @Component
          AND Factory = @Factory
    )
    BEGIN
        RAISERROR('A unit cost already exists for this component and factory combination.', 16, 1);
        RETURN;
    END;

    INSERT INTO [Factory Costs]
    (
        Component,
        Factory,
        [Unit Cost]
    )
    VALUES
    (
        @Component,
        @Factory,
        @UnitCost
    );
END;