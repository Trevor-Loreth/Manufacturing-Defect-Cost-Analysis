UPDATE s
SET s.Cost =
      b.[Unit Cost]
    + m.[Unit Cost]
    + f.[Unit Cost]
    + 20
FROM Sales AS s
INNER JOIN Inventory AS i
    ON s.[Product Serial #] = i.[Product Serial #]
INNER JOIN Blades AS b
    ON i.[Blades Serial #] = b.[Blades Serial #]
INNER JOIN Motor AS m
    ON i.[Motor Serial #] = m.[Motor Serial #]
INNER JOIN Frame AS f
    ON i.[Frame Serial #] = f.[Frame Serial #];