/*Query 1*/

SELECT
  e.LastName,
  e.FirstName,
  e.Title,
  COUNT(*) Number_of_Supports
FROM Employee e
JOIN Customer c
  ON e.EmployeeId = c.SupportRepId
GROUP BY 1,
         2,
         3
ORDER BY Number_of_Supports DESC;

/*Query 2*/

SELECT
  M.Name Media_Type,
  COUNT(*) Media_Number
FROM Track T
JOIN MediaType M
  ON T.MediaTypeId = M.MediaTypeId
GROUP BY Media_Type
ORDER BY Media_Number DESC;

/*Query 3*/

WITH t1
AS (SELECT
  Ar.Name Artist_name,
  strftime('%Y', I.InvoiceDate) Year,
  COUNT(*) * T.UnitPrice Total_Spent
FROM Track T
JOIN Album Al
  ON T.AlbumId = Al.AlbumId
JOIN Artist Ar
  ON Ar.ArtistId = Al.ArtistId
JOIN InvoiceLine IL
  ON IL.TrackId = T.TrackId
JOIN invoice I
  ON I.InvoiceId = IL.InvoiceId
GROUP BY Artist_name,
         Year
ORDER BY Artist_name DESC),
t2
AS (SELECT
  Year,
  MAX(Total_Spent) Max_Spent
FROM t1
GROUP BY Year
ORDER BY Year)

SELECT
  t1.Artist_name,
  t1.Year,
  t1.Total_Spent
FROM t1
JOIN t2
  ON t1.Total_Spent = t2.Max_Spent
  AND t1.Year = t2.Year
ORDER BY t1.Year


/*Query 4*/

WITH t1
AS (SELECT
  strftime('%Y', I.InvoiceDate) Year,
  G.Name Gen,
  COUNT(*) count_S
FROM Invoice I
JOIN InvoiceLine IL
  ON IL.InvoiceId = I.InvoiceId
JOIN Track T
  ON T.TrackId = IL.TrackId
JOIN Genre G
  ON G.GenreId = T.GenreId
GROUP BY 1,
         2
ORDER BY 1, 3 DESC),
t2
AS (SELECT
  Year,
  MAX(count_S) Tot_amount
FROM t1
GROUP BY Year)

SELECT
  t1.Year,
  t1.Gen,
  t2.Tot_amount
FROM t1
JOIN t2
  ON t1.Year = t2.Year
  AND t1.count_S = t2.Tot_amount

/*Query5*/

WITH t1
AS (SELECT
  CASE
    WHEN c.Country IN ('Brazil', 'Argentina', 'Chile') THEN 'South_America'
    WHEN c.Country IN ('Canada', 'USA') THEN 'North_America'
    WHEN c.Country = 'Australia' THEN 'Australia'
    WHEN c.Country = 'India' THEN 'Asia'
    ELSE 'Europe'
  END Continent,
  g.Name Genre,
  COUNT(*) AS Count
FROM Customer c
JOIN Invoice I
  ON c.CustomerId = I.CustomerId
JOIN InvoiceLine IL
  ON I.InvoiceId = IL.InvoiceId
JOIN Track T
  ON T.TrackId = IL.TrackId
JOIN Genre G
  ON T.GenreId = G.GenreId
GROUP BY Continent,
         Genre
ORDER BY 1, Count DESC),
t2
AS (SELECT
  Continent,
  AVG(Count) Average
FROM t1
GROUP BY 1)

SELECT
  t1.Continent,
  t1.Genre,
  t1.Count
FROM t1
JOIN t2
  ON t1.Count > t2.Average
  AND t1.Continent = t2.Continent