CREATE OR ALTER VIEW [Sales Running Summary] AS

WITH Transactions AS
(
    SELECT
        'Sale' AS [Transaction Type],
        1 AS [Transaction Type Order],
        CAST(s.[Sales ID] AS VARCHAR(50)) AS [Transaction ID],
        s.[Product Serial #],
        s.[Date] AS [Transaction Date],

        CAST(s.Price AS DECIMAL(10,2)) AS Price,

        CAST(
              b.[Unit Cost]
            + m.[Unit Cost]
            + f.[Unit Cost]
            + i.[Assembly Cost]
            AS DECIMAL(10,2)
        ) AS Cost,

        CAST(0 AS DECIMAL(10,2)) AS [Refund Amount]

    FROM Sales AS s
    INNER JOIN Inventory AS i
        ON s.[Product Serial #] = i.[Product Serial #]
    INNER JOIN Blades AS b
        ON i.[Blades Serial #] = b.[Blades Serial #]
    INNER JOIN Motor AS m
        ON i.[Motor Serial #] = m.[Motor Serial #]
    INNER JOIN Frame AS f
        ON i.[Frame Serial #] = f.[Frame Serial #]

    UNION ALL

    SELECT
        'Return' AS [Transaction Type],
        2 AS [Transaction Type Order],
        CAST(r.[Product Serial #] AS VARCHAR(50)) AS [Transaction ID],
        r.[Product Serial #],
        r.[Return Date] AS [Transaction Date],

        CAST(0 AS DECIMAL(10,2)) AS Price,
        CAST(0 AS DECIMAL(10,2)) AS Cost,
        CAST(r.[Refund Amount] AS DECIMAL(10,2)) AS [Refund Amount]

    FROM Returns AS r
)

SELECT
    ROW_NUMBER() OVER (
        ORDER BY [Transaction Date], [Transaction Type Order], [Transaction ID]
    ) AS [Transaction #],

    [Transaction Type],
    [Transaction ID],
    [Product Serial #],
    [Transaction Date],

    Price,
    Cost,
    [Refund Amount],

    SUM(Price) OVER (
        ORDER BY [Transaction Date], [Transaction Type Order], [Transaction ID]
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS [Running Total Sales],

    SUM(Cost) OVER (
        ORDER BY [Transaction Date], [Transaction Type Order], [Transaction ID]
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS [Running Total Costs],

    SUM([Refund Amount]) OVER (
        ORDER BY [Transaction Date], [Transaction Type Order], [Transaction ID]
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS [Running Total Refunds],

    SUM(Price - [Refund Amount]) OVER (
        ORDER BY [Transaction Date], [Transaction Type Order], [Transaction ID]
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS [Running Net Sales],

    SUM(Price - [Refund Amount] - Cost) OVER (
        ORDER BY [Transaction Date], [Transaction Type Order], [Transaction ID]
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS [Running Total Profit]

FROM Transactions;
