/* Kamil Sztandur 307354 */

-- Polecenie A)
SELECT 
	e.ID_OSOBY AS [ID klienta]
,	CONVERT( nvarchar(64), o.IMIE + ' ' + o.NAZWISKO ) AS [Klient]
,	e.PENSJA AS [Pensja klienta]
,	e.ID_FIRMY AS [ID Firmy klienta]
,	mO.NAZWA AS [Miejscowość klienta]
FROM dbo.ETATY e
JOIN dbo.OSOBY o 
	ON (o.ID_OSOBY = e.ID_OSOBY )
JOIN dbo.MIASTA mO
	ON (o.ID_MIASTA = mO.ID_MIASTA ) AND ( mO.NAZWA LIKE 'W%' ) 
WHERE e.PENSJA = ( SELECT MAX( MAXe.PENSJA )
				   FROM dbo.ETATY MAXe, dbo.MIASTA MAXmO, dbo.OSOBY MAXo
				   WHERE ( MAXo.ID_MIASTA = MAXmO.ID_MIASTA ) 
						AND ( MAXo.ID_OSOBY = MAXe.ID_OSOBY )
						AND ( MAXmO.NAZWA LIKE 'W%' ) 
				 )

/* Wynik zapytania:
ID klienta	Klient			Pensja klienta	ID Firmy klienta	Miejscowość klienta
5			Ala Makota      6000			OGR       			Wesoła
*/



/* Umieszczę kilka etatów na potrzeby ćwiczenia na barku pracowitego Krystiana Lewandowskiego (ID_OSOBY = 2)
INSERT INTO ETATY( ID_FIRMY, ID_OSOBY, OD, PENSJA, STANOWISKO )
	VALUES( 'KWM', 2, CONVERT( datetime, '20111230', 112 ), 11000, 'Konsultant' )
INSERT INTO ETATY( ID_FIRMY, ID_OSOBY, OD, PENSJA, STANOWISKO )
	VALUES( 'ES', 2, CONVERT( datetime, '20111130', 112 ), 15000, 'Muzykant' )
INSERT INTO ETATY( ID_FIRMY, ID_OSOBY, OD, PENSJA, STANOWISKO )
	VALUES( 'EDI', 2, CONVERT( datetime, '20071230', 112 ), 9000, 'Grafik' )
INSERT INTO ETATY( ID_FIRMY, ID_OSOBY, OD, PENSJA, STANOWISKO )
	VALUES( 'NOW', 2, CONVERT( datetime, '20041230', 112 ), 90000, 'Spawacz' )
INSERT INTO ETATY( ID_FIRMY, ID_OSOBY, OD, PENSJA, STANOWISKO )
	VALUES( 'KWM', 2, CONVERT( datetime, '20111230', 112 ), 3500, 'Lekarz' )
INSERT INTO ETATY( ID_FIRMY, ID_OSOBY, OD, PENSJA, STANOWISKO )
	VALUES( 'KWM', 2, CONVERT( datetime, '20011230', 112 ), 55000, 'Kominiarz' )
*/



-- Polecenie B)
DECLARE @id_firmy nchar(16)
DECLARE CC INSENSITIVE CURSOR FOR
	SELECT t.ID_FIRMY
	FROM (
		SELECT DISTINCT e.id_firmy  
		FROM etaty e 
		WHERE e.id_osoby = 2
	) t
OPEN CC
FETCH NEXT FROM CC INTO @id_firmy

WHILE @@FETCH_STATUS = 0 
BEGIN
	SELECT	e.ID_FIRMY		AS [ID firmy]
    ,		SUM( e.PENSJA ) AS [Suma pensji]
	,		COUNT( * )		AS [Liczba etatów]
	FROM OSOBY o
	JOIN ETATY e ON (e.ID_OSOBY = o.ID_OSOBY)
	WHERE (e.ID_OSOBY = 2) AND (e.ID_FIRMY = @id_firmy)
	GROUP BY e.ID_FIRMY

	FETCH NEXT FROM CC INTO @id_firmy
END

CLOSE CC
DEALLOCATE CC

/* Wynik zapytania dla ID_OSOBY = 2:
ID firmy	Suma pensji	Liczba etatów
EDI       	9000		1

ID firmy	Suma pensji	Liczba etatów
ES        	20000		2

ID firmy	Suma pensji	Liczba etatów
KWM       	69500		3

ID firmy	Suma pensji	Liczba etatów
NOW       	90000		1
*/


-- polecenie C)
SELECT w.KOD_WOj		AS [Kod]
,	   w.NAZWA			AS [Województwo]
,	   COUNT( o.IMIE )	AS [Liczba mieszkańców]
FROM dbo.WOJ w
JOIN dbo.MIASTA m ON ( w.KOD_WOJ = m.KOD_WOJ )
JOIN dbo.OSOBY o ON ( o.ID_MIASTA = m.ID_MIASTA )
GROUP BY w.NAZWA, w.KOD_WOJ

/* Wynik zapytania:

Kod		Województwo		Liczba mieszkańców
MAL     Małopolska		4
MAZ     Mazowieckie		3
POM     Pomorskie		1
*/