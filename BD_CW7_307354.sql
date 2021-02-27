--/* Kamil Sztandur 307354 Grupa 2*/
-- WE Informatyka Stosowana (2 semestr) 
use B_307354


/* Polecenie 1) */
-- Sprawdzenie, czy dana procedura już istnieje i (opcjonalne) utworzenie jej szkieletu
IF NOT EXISTS
(
	SELECT 1
	FROM sysobjects o
	WHERE o.[name] = 'DROP_IF_EXISTS'
	AND (OBJECTPROPERTY(o.[ID], 'IsProcedure') = 1 )
)
BEGIN
	DECLARE @stmt nvarchar(256)
	SET @stmt = 'CREATE PROCEDURE dbo.DROP_IF_EXISTS AS'
	EXEC sp_sqlexec @stmt 
END
GO

-- Utworzenie właściwej procedury zrzucającej tabelę
ALTER PROCEDURE dbo.DROP_IF_EXISTS ( @Table_name nvarchar(128) )
AS
	IF EXISTS
	(
		SELECT 1
		FROM sysobjects o
		join syscolumns c ON (o.id = c.id)
		WHERE ( OBJECTPROPERTY(o.id, 'isUserTable') = 1 
				AND (o.[name] = @Table_name) 
			) 
			OR OBJECT_ID('tempdb..' + @Table_name) IS NOT NULL /* Usuwanie takze tabel tymczasowych */
	) 
	BEGIN
		DECLARE @drop_command nvarchar(256)
		SET @drop_command = CONVERT( nvarchar(140), 'DROP TABLE ' + @Table_name )
		EXEC sp_sqlexec @drop_command
	END
GO

-- Skrypt z pierwszych zajęć laboratoryjnych (odpowiednio skrócony na potrzeby tego sprawozdania)

/* POCZĄTEK SKRYPTU Z PIERWSZYCH ZAJĘĆ LABORATORYJNYCH */
EXEC dbo.DROP_IF_EXISTS @Table_name = 'ETATY'
EXEC dbo.DROP_IF_EXISTS @Table_name = 'FIRMY'
EXEC dbo.DROP_IF_EXISTS @Table_name = 'OSOBY'
EXEC dbo.DROP_IF_EXISTS @Table_name = 'MIASTA'
EXEC dbo.DROP_IF_EXISTS @Table_name = 'WOJ'

/* Tymczasem zakładać tabele należy od tej najbardziej nadrzędnej do podrzędnej */
CREATE TABLE dbo.WOJ
(	KOD_WOJ nchar(10) NOT NULL
		CONSTRAINT PK_WOJ PRIMARY KEY 
,	NAZWA nvarchar(40) NOT NULL
)
GO

CREATE TABLE dbo.MIASTA
(	ID_MIASTA int NOT NULL IDENTITY 
		CONSTRAINT PK_MIASTA PRIMARY KEY
,	KOD_WOJ nchar(10) NOT NULL
		CONSTRAINT FK_MIASTA_WOJ FOREIGN KEY
		REFERENCES WOJ(KOD_WOJ)
,	NAZWA nvarchar(40) NOT NULL 
)
GO

CREATE TABLE dbo.OSOBY
(	ID_MIASTA int NOT NULL 
		CONSTRAINT PK_CITY FOREIGN KEY
		REFERENCES MIASTA(ID_MIASTA)
,	IMIE nchar(15) NOT NULL
,	NAZWISKO nchar(30) NOT NULL
,	ADRES nchar(60) NOT NULL
,	ID_OSOBY int NOT NULL IDENTITY
		CONSTRAINT PK_OSOBY PRIMARY KEY
)
GO

CREATE TABLE dbo.FIRMY
(	ID_MIASTA int NOT NULL 
		CONSTRAINT FK_PK_MIASTA FOREIGN KEY
		REFERENCES MIASTA(ID_MIASTA)
,	NAZWA_SKR nchar(10) NOT NULL
		CONSTRAINT PK_FIRMY PRIMARY KEY
,	NAZWA nchar(60) NOT NULL 
,	ULICA nchar(60) NOT NULL
,	KOD_POCZTOWY nchar(12) NOT NULL
,	ADRES AS CONVERT( nvarchar(130), KOD_POCZTOWY + ' ' + NAZWA_SKR + ' ' + 'ul. ' + ULICA ) 
)
GO

CREATE TABLE dbo.ETATY
(	ID_OSOBY int NOT NULL
		CONSTRAINT FK_PK_OSOBY FOREIGN KEY
		REFERENCES OSOBY(ID_OSOBY)
,	ID_FIRMY nchar(10) NOT NULL
		CONSTRAINT FK_PK_FIRMY FOREIGN KEY
		REFERENCES FIRMY(NAZWA_SKR)
,	STANOWISKO nchar(50) NOT NULL
,	PENSJA int NOT NULL
,	OD DATETIME NOT NULL
,	DO DATETIME NULL
,	ID_ETATU int NOT NULL IDENTITY
		CONSTRAINT PK_ETATY PRIMARY KEY
)
GO

INSERT INTO WOJ( KOD_WOJ, NAZWA ) VALUES ('MAL','Małopolska')
INSERT INTO WOJ( KOD_WOJ, NAZWA ) VALUES ('MAZ','Mazowieckie')
INSERT INTO WOJ( KOD_WOJ, NAZWA ) VALUES ('POM','Pomorskie')

INSERT INTO MIASTA(KOD_WOJ, NAZWA) VALUES ('MAL','Kraków')
INSERT INTO MIASTA( KOD_WOJ, NAZWA ) VALUES ( 'MAL', 'Tarnów' )
INSERT INTO MIASTA( KOD_WOJ, NAZWA ) VALUES ( 'MAZ', 'Warszawa' )
INSERT INTO MIASTA( KOD_WOJ, NAZWA ) VALUES ( 'MAZ', 'Wesoła' )
INSERT INTO MIASTA( KOD_WOJ, NAZWA ) VALUES ( 'POM', 'Gdañsk' )

INSERT INTO FIRMY( NAZWA_SKR, NAZWA, KOD_POCZTOWY, ULICA, ID_MIASTA ) 
	VALUES ('KWM', 'Klub wielbicieli MS', '00-020', 'Zapolskiej 18', 1 )
INSERT INTO FIRMY( NAZWA_SKR, NAZWA, KOD_POCZTOWY, ULICA, ID_MIASTA ) 
	VALUES ('ES', 'Eagle Spark', '02-931', 'Robotnicza 19', 2 )
INSERT INTO FIRMY( NAZWA_SKR, NAZWA, KOD_POCZTOWY, ULICA, ID_MIASTA ) 
	VALUES ('OGR', 'Ogrodnicy', '03-233', 'Pulaska 12', 3 )
INSERT INTO FIRMY( NAZWA_SKR, NAZWA, KOD_POCZTOWY, ULICA, ID_MIASTA ) 
	VALUES ('NOW', 'Now', '03-784', 'Narutowicza 16', 4 )
INSERT INTO FIRMY( NAZWA_SKR, NAZWA, KOD_POCZTOWY, ULICA, ID_MIASTA ) 
	VALUES ('EDI', 'Edifier', '06-343', 'Debowa 5', 5 )

INSERT INTO OSOBY( ID_MIASTA, IMIE, NAZWISKO, ADRES ) VALUES ( 1, 'Jan', 'Kowalski', 'Prosta 7' )
INSERT INTO OSOBY( ID_MIASTA, IMIE, NAZWISKO, ADRES ) VALUES ( 3, 'Krystian', 'Lewandowski', 'Zielona 14')
INSERT INTO OSOBY( ID_MIASTA, IMIE, NAZWISKO, ADRES ) VALUES ( 2, 'Ania', 'Zzielonegowzgórza', 'Mickiewicza 18')
INSERT INTO OSOBY( ID_MIASTA, IMIE, NAZWISKO, ADRES ) VALUES ( 5, 'Ola', 'Tartak', 'Aleje Jerozolimskie 12')
INSERT INTO OSOBY( ID_MIASTA, IMIE, NAZWISKO, ADRES ) VALUES ( 4, 'Ala', 'Makota', 'Sobieskiego 4')
INSERT INTO OSOBY( ID_MIASTA, IMIE, NAZWISKO, ADRES ) VALUES ( 1, 'Krystyna', 'Czubówna', 'Polna 2')
INSERT INTO OSOBY( ID_MIASTA, IMIE, NAZWISKO, ADRES ) VALUES ( 3, 'Grzegorz', 'Markowski', 'Jana Pawla 4')
INSERT INTO OSOBY( ID_MIASTA, IMIE, NAZWISKO, ADRES ) VALUES ( 2, 'Kazio', 'Sasin', 'Brudna 5')

INSERT INTO ETATY( ID_FIRMY, ID_OSOBY, OD, PENSJA, STANOWISKO )
	VALUES( 'KWM', 1, CONVERT( datetime, '20111230', 112 ), 11000, 'Konsultant' )
INSERT INTO ETATY( ID_FIRMY, ID_OSOBY, OD, PENSJA, STANOWISKO )
	VALUES( 'ES', 2, CONVERT( datetime, '20120227', 112 ), 5000, 'Stolarz' )
INSERT INTO ETATY( ID_FIRMY, ID_OSOBY, OD, PENSJA, STANOWISKO )
	VALUES( 'ES', 3, CONVERT( datetime, '20120122', 112 ), 6000, 'Minister śmiesznych kroków' )
INSERT INTO ETATY( ID_FIRMY, ID_OSOBY, OD, PENSJA, STANOWISKO )
	VALUES( 'OGR', 4, CONVERT( datetime, '20110630', 112 ), 34000, 'Malarz' )
INSERT INTO ETATY( ID_FIRMY, ID_OSOBY, OD, PENSJA, STANOWISKO )
	VALUES( 'OGR', 5, CONVERT( datetime, '20100609', 112 ), 6000, 'Spawacz' )
INSERT INTO ETATY( ID_FIRMY, ID_OSOBY, OD, PENSJA, STANOWISKO )
	VALUES( 'NOW', 6, CONVERT( datetime, '20130411', 112 ), 5400, 'Kasjer' )
INSERT INTO ETATY( ID_FIRMY, ID_OSOBY, OD, PENSJA, STANOWISKO )
	VALUES( 'NOW', 7, CONVERT( datetime, '20151202', 112 ), 3200, 'Magazynier' )
INSERT INTO ETATY( ID_FIRMY, ID_OSOBY, OD, PENSJA, STANOWISKO , DO )
	VALUES( 'EDI', 8, CONVERT( datetime, '20180701', 112 ), 15000, 'Kierowca', '20200526' )
INSERT INTO ETATY( ID_FIRMY, ID_OSOBY, OD, PENSJA, STANOWISKO )
	VALUES( 'EDI', 5, CONVERT( datetime, '20180701', 112 ), 3500, 'Szef' )
/* KONIEC SKRYPTU Z PIERWSZYCH ZAJĘĆ LABORATORYJNYCH */


/* Polecenie 2) */
--Stwórzmy tabelę tymczasową z poszukiwanymi dodatkami do samochodu
EXEC dbo.DROP_IF_EXISTS @Table_name = '#selected_wyp'

CREATE TABLE #selected_wyp
(
	WYP nchar(4) NOT NULL 
		CONSTRAINT FK_WYP_AUTA__WYPAS Foreign Key
		REFERENCES dbo.WYP_AUTA (WYP)
)

INSERT INTO #selected_wyp( WYP ) 
	VALUES ('AC')
INSERT INTO #selected_wyp( WYP ) 
	VALUES ('CVT')

-- Sprawdzenie, czy dana procedura już istnieje i (opcjonalne) utworzenie jej szkieletu
IF NOT EXISTS
(
	SELECT 1
	FROM sysobjects o
	WHERE o.[name] = 'SHOW_WYP'
	AND (OBJECTPROPERTY(o.[ID], 'IsProcedure') = 1 )
)
BEGIN
	DECLARE @stmt nvarchar(256)
	SET @stmt = 'CREATE PROCEDURE dbo.SHOW_WYP AS'
	EXEC sp_sqlexec @stmt 
END
GO

-- Uzupełnienie właściwej procedury
ALTER PROCEDURE dbo.SHOW_WYP
AS
	DECLARE @id_wyposazenia nchar(16)
	DECLARE CC INSENSITIVE CURSOR FOR
		SELECT t.WYP
		FROM #selected_wyp t
	OPEN CC
	FETCH NEXT FROM CC INTO @id_wyposazenia
	
	CREATE TABLE #car_list (
		[ID_AUTA] int NOT NULL
	,	[Samochód] nvarchar(33) NOT NULL
	,	[Wyposażenie] nchar(4) NOT NULL 
	)

	WHILE @@FETCH_STATUS = 0 
	BEGIN
		SELECT	a.ID_AUTA AS [ID Samochodu]
		,		CONVERT( nvarchar(33), a.MARKA + ' ' + a.MODEL ) AS [Samochód]
		,		CONVERT( nvarchar(4), @id_wyposazenia ) AS [Wyposażenie]
		FROM dbo.AUTO a
		WHERE EXISTS (
			SELECT	1
			FROM	dbo.WYPAS w
			WHERE	(w.ID_AUTA = a.ID_AUTA)
			AND		(w.WYP = @id_wyposazenia)
		)
		ORDER BY 1

		FETCH NEXT FROM CC INTO @id_wyposazenia
	END
	
	CLOSE CC
	DEALLOCATE CC
GO

-- Test procedury nr. 2
EXEC dbo.SHOW_WYP

/* Efekt wywołania:
ID Samochodu	Samochód	Wyposażenie
5	Tesla            S	AC  
6	Peugeot          Amecat	AC  

ID Samochodu	Samochód	Wyposażenie
4	Toyota           Go	CVT 
6	Peugeot          Amecat	CVT 
7	Passat           Najlepszy	CVT 
*/


/* Polecenie 3) */
-- Sprawdzenie, czy dana procedura już istnieje i (opcjonalne) utworzenie jej szkieletu
IF NOT EXISTS
(
	SELECT 1
	FROM sysobjects o
	WHERE o.[name] = 'PKT3'
	AND (OBJECTPROPERTY(o.[ID], 'IsProcedure') = 1 )
)
BEGIN
	DECLARE @stmt nvarchar(256)
	SET @stmt = 'CREATE PROCEDURE dbo.PKT3 AS'
	EXEC sp_sqlexec @stmt 
END
GO

-- Napisanie właściwej procedury
ALTER PROCEDURE dbo.PKT3 @id_miasta int = NULL, @kod_woj nchar(10) = null, @akt bit = 0
AS	
	IF @akt = 0
		SELECT	w.NAZWA AS [Województwo]
		,		m.NAZWA AS [Miasto]
		,		f.NAZWA AS [Firma]
		,		AVG( e.PENSJA ) AS [Średnia Pensja w firmie]
		FROM dbo.ETATY e
		JOIN dbo.FIRMY f
			ON (e.ID_FIRMY = f.NAZWA_SKR)
		JOIN dbo.MIASTA m
			ON m.ID_MIASTA = f.ID_MIASTA 
			AND m.ID_MIASTA LIKE COALESCE( CONVERT( nvarchar(16), @id_miasta), '%' )
		JOIN dbo.WOJ w
			ON w.KOD_WOJ = m.KOD_WOJ 
			AND w.KOD_WOJ LIKE COALESCE( @kod_woj, '%' )
		GROUP BY f.NAZWA, m.NAZWA, w.NAZWA
		ORDER BY w.NAZWA, m.NAZWA
	ELSE
		SELECT	w.NAZWA AS [Województwo]
		,		m.NAZWA AS [Miasto]
		,		f.NAZWA AS [Firma]
		,		AVG( e.PENSJA ) AS [Średnia Pensja w firmie]
		FROM dbo.OSOBY o
		JOIN dbo.ETATY e
			ON e.ID_OSOBY = o.ID_OSOBY
			AND e.DO IS NOT NULL
		JOIN dbo.FIRMY f
			ON (e.ID_FIRMY = f.NAZWA_SKR)
		JOIN dbo.MIASTA m
			ON m.ID_MIASTA = f.ID_MIASTA 
			AND m.ID_MIASTA LIKE COALESCE( CONVERT( nvarchar(16), @id_miasta), '%' )
		JOIN dbo.WOJ w
			ON w.KOD_WOJ = m.KOD_WOJ 
			AND w.KOD_WOJ LIKE COALESCE( @kod_woj, '%' )
		GROUP BY f.NAZWA, m.NAZWA, w.NAZWA
		ORDER BY w.NAZWA, m.NAZWA

GO

-- Test działania procedury nr. 3
EXEC PKT3
/* Efekt wywołania:
Województwo		Miasto		Firma					Średnia Pensja w firmie
Małopolska		Kraków		Klub wielbicieli MS		11000
Małopolska		Tarnów		Eagle Spark				5500
Mazowieckie		Warszawa	Ogrodnicy				20000
Mazowieckie		Wesoła		Now						4300
Pomorskie		Gdansk		Edifier					9250
*/

EXEC PKT3 @akt = 1, @KOD_WOJ = 'POM', @id_miasta = 5
/* Efekt wywołania:
Województwo		Miasto		Firma					Średnia Pensja w firmie
Pomorskie		Gdansk		Edifier					15000
*/

EXEC PKT3 @akt = 0, @KOD_WOJ = 'POM', @id_miasta = 5
/* Efekt wywołania:
Województwo		Miasto		Firma					Średnia Pensja w firmie
Pomorskie		Gdansk		Edifier					9250
*/