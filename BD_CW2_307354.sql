-- Polecenie 3)
IF EXISTS (SELECT 1
               FROM   INFORMATION_SCHEMA.COLUMNS
               WHERE  TABLE_NAME = 'OSOBY'
                      AND COLUMN_NAME = 'date_ur'
                      AND TABLE_SCHEMA='dbo')
BEGIN
      ALTER TABLE OSOBY DROP COLUMN date_ur
END
GO

ALTER TABLE OSOBY ADD date_ur datetime NULL
GO
/* 
Jako że odłączyłem skrypt z pierwszego laboratorium od tego, a chciałem żeby 
skrypt uruchamiał się za każdym razem bez wykazywania błedów, to dodałem 
warunek na kasowanie kolumny date_ur, jeżeli ta już istnieje.
*/



-- Polecenie 3a)
DECLARE @i INT = 1;
WHILE @i < 8 + 1
BEGIN
	UPDATE OSOBY SET date_ur = DateAdd(d, ROUND(DateDiff(d, '1960-01-01', '2002-12-31') * RAND(CHECKSUM(NEWID())), 0),
			DATEADD(second,CHECKSUM(NEWID())%48000, '1960-01-01'))
	WHERE OSOBY.ID_OSOBY = @i
	
	SET @i = @i + 1;
END;
/* 
Losowe uzupełnienie dat urodzenia w zakresie od 1 stycznia 1960 do 31 grudnia 2002 roku.
Ze względu na losowonie dane zawarte w komentarzach mogę się w od tych po ponownym uruchomiemiu 
*/



-- Polecenie 3b)
SELECT
	CONVERT( nvarchar(64), o.IMIE + ' ' + o.NAZWISKO ) AS [Imie i nazwisko]
,	CONVERT( nvarchar(12), o.date_ur, 120 ) AS [Data urodzin]
,	DATEDIFF( YY, o.date_ur, getdate() ) AS [Wiek]
FROM OSOBY o
	WHERE o.date_ur IS NOT NULL
ORDER BY [Wiek] DESC
/*
Ola             Tartak                        	1963-03-27 1	57
Krystyna        Czubówna                      	1965-08-23 2	55
Ala             Makota                        	1972-08-01 0	48
Krystian        Lewandowski                   	1984-02-03 1	36
Kazio           Sasin                         	1987-03-11 0	33
Jan             Kowalski                      	1988-05-20 0	32
Ania            Zzielonegowzgórza             	1989-09-22 1	31
Grzegorz        Markowski                     	1994-11-23 1	26
*/



-- Polecenie 3c)
SELECT
	CONVERT( nvarchar(30), LEFT(o.IMIE, 1 ) + '. ' + o.NAZWISKO ) AS [Klient]
,	CONVERT( INT, DATEDIFF( YY, o.date_ur, getdate() ) ) AS [Wiek]
FROM OSOBY o
	WHERE ( o.date_ur IS NOT NULL ) AND ( DATEDIFF( YY, o.date_ur, getdate() ) BETWEEN 30 AND 45 )
ORDER BY [Wiek] DESC
/*
K. Lewandowski                	36
K. Sasin                      	33
J. Kowalski                   	32
A. Zzielonegowzgórza          	31
*/



-- Polecenie 4)
SELECT
	CONVERT( nvarchar(256), o.NAZWISKO 
	+ ' mieszka w ' + mr.NAZWA 
	+ ', a pracuje w ' + mf.NAZWA /* Tutaj powinna być nazwa miasta firmowego, a nie rodzinnego */
	+ ' jako ' + e.STANOWISKO 
	+ ' w firmie ' + f.NAZWA 
	+ '.') AS [Dane klienta]
FROM ETATY e, OSOBY o, FIRMY f, MIASTA mr, MIASTA mf
	WHERE (o.ID_MIASTA = mr.ID_MIASTA) AND ( e.ID_OSOBY = o.ID_OSOBY ) AND ( f.ID_MIASTA = mf.ID_MIASTA ) AND (f.NAZWA_SKR = e.ID_FIRMY )
	AND ( f.ID_MIASTA != o.ID_MIASTA )
/*
Lewandowski                    mieszka w Warszawa, a pracuje w Tarnów jako Stolarz                                            w firmie Eagle Spark                                                 .
Tartak                         mieszka w Gdańsk, a pracuje w Warszawa jako Malarz                                             w firmie Ogrodnicy                                                   .
Makota                         mieszka w Wesoła, a pracuje w Warszawa jako Spawacz                                            w firmie Ogrodnicy                                                   .
Czubówna                       mieszka w Kraków, a pracuje w Wesoła jako Kasjer                                             w firmie Now                                                         .
Markowski                      mieszka w Warszawa, a pracuje w Wesoła jako Magazynier                                         w firmie Now                                                         .
Sasin                          mieszka w Tarnów, a pracuje w Gdańsk jako Kierowca                                           w firmie Edifier                                                     .
*/