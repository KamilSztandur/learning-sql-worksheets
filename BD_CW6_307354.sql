/* Kamil Sztandur 307354 Grupa 2*/
-- WE Informatyka Stosowana (2 semestr) 

-- Polecenia rozpoczynają się od 230 linijki. Do tego czasu tworzę i uzupełniam tabele rekordami --

/* Dodanie warunku na zrzucenie tabel w przypadku istnienia już takowych */
IF OBJECT_ID('dbo.WYPAS') IS NOT NULL
BEGIN
	DROP TABLE dbo.WYPAS
END
GO

IF OBJECT_ID('dbo.AUTO') IS NOT NULL
BEGIN
	DROP TABLE dbo.AUTO
END
GO

IF OBJECT_ID('dbo.WYP_AUTA') IS NOT NULL
BEGIN
	DROP TABLE dbo.WYP_AUTA
END
GO

IF OBJECT_ID('dbo.SLOWNIK') IS NOT NULL
BEGIN
	DROP TABLE dbo.SLOWNIK
END
GO



/* Utworzenie potrzebnych tabel */
CREATE TABLE dbo.AUTO
(	
	ID_AUTA int NOT NULL IDENTITY 
		CONSTRAINT PK_AUTA PRIMARY KEY
,	MARKA nchar(16) NOT NULL
,	MODEL nvarchar(16) NOT NULL 
)
GO


CREATE TABLE dbo.SLOWNIK
(
	DODATKI nchar(4) NOT NULL
)
GO


CREATE TABLE dbo.WYP_AUTA
(
	WYP nchar(4) NOT NULL
		CONSTRAINT PK_WYP_AUTA PRIMARY KEY
,	OPIS nvarchar(40)
)
GO


CREATE TABLE dbo.WYPAS
(
	ID_AUTA int NOT NULL 
		CONSTRAINT FK_AUTA__WYPAS Foreign Key
		REFERENCES dbo.AUTO (ID_AUTA)
,	WYP nchar(4) NOT NULL 
		CONSTRAINT FK_WYP_AUTA__WYPAS Foreign Key
		REFERENCES dbo.WYP_AUTA (WYP)
)



/* Uzupełnienie istniejących tabel jakimiś przykładowymi rekordami */
-- dla dbo.SŁOWNIK
INSERT INTO dbo.SLOWNIK(DODATKI)
	VALUES ('AC')
INSERT INTO dbo.SLOWNIK(DODATKI)
	VALUES ('ABS')
INSERT INTO dbo.SLOWNIK(DODATKI)
	VALUES ('NAVI')
INSERT INTO dbo.SLOWNIK(DODATKI)
	VALUES ('4x4')
INSERT INTO dbo.SLOWNIK(DODATKI)
	VALUES ('LETH')
INSERT INTO dbo.SLOWNIK(DODATKI)
	VALUES ('HEAT')
INSERT INTO dbo.SLOWNIK(DODATKI)
	VALUES ('CVT')

-- dla dbo.AUTO
INSERT INTO dbo.AUTO( MARKA, MODEL ) 
	VALUES ('BMW', 'G4')
INSERT INTO dbo.AUTO( MARKA, MODEL ) 
	VALUES ('Audi', 'A1')
INSERT INTO dbo.AUTO( MARKA, MODEL ) 
	VALUES ('Citroen', 'C5')
INSERT INTO dbo.AUTO( MARKA, MODEL ) 
	VALUES ('Toyota', 'Go')
INSERT INTO dbo.AUTO( MARKA, MODEL ) 
	VALUES ('Tesla', 'S')
INSERT INTO dbo.AUTO( MARKA, MODEL ) 
	VALUES ('Peugeot', 'Amecat')
INSERT INTO dbo.AUTO( MARKA, MODEL ) 
	VALUES ('Passat', 'Najlepszy')
INSERT INTO dbo.AUTO( MARKA, MODEL ) 
	VALUES ('BMW', 'G5')
INSERT INTO dbo.AUTO( MARKA, MODEL ) 
	VALUES ('Audi', 'A6')

-- dla dbo.WYP_AUTA
INSERT INTO dbo.WYP_AUTA( WYP, OPIS ) 
	VALUES ('AC', 'Ubezpieczenie samochodu')
INSERT INTO dbo.WYP_AUTA( WYP, OPIS ) 
	VALUES ('ABS', 'Antyblokowanie kół podczas hamowania')
INSERT INTO dbo.WYP_AUTA( WYP, OPIS ) 
	VALUES ('NAVI', 'Wbudowana nawigacja')
INSERT INTO dbo.WYP_AUTA( WYP, OPIS ) 
	VALUES ('4x4', 'Napęd na 4 koła')
INSERT INTO dbo.WYP_AUTA( WYP, OPIS ) 
	VALUES ('LETH', 'Tajemnicze wyposażenie')
INSERT INTO dbo.WYP_AUTA( WYP, OPIS ) 
	VALUES ('HEAT', 'Ogrzewanie samochodu')
INSERT INTO dbo.WYP_AUTA( WYP, OPIS ) 
	VALUES ('CVT', 'Automatyczna skrzynia biegów')


/* Teraz rozdajemy wyposażenia pośród nasze samochody */
INSERT INTO dbo.WYPAS( ID_AUTA, WYP ) 
	VALUES ( 1, 'HEAT')
INSERT INTO dbo.WYPAS( ID_AUTA, WYP ) 
	VALUES ( 1, 'ABS')

INSERT INTO dbo.WYPAS( ID_AUTA, WYP ) 
	VALUES ( 2, '4x4')

INSERT INTO dbo.WYPAS( ID_AUTA, WYP ) 
	VALUES ( 4, 'CVT')

INSERT INTO dbo.WYPAS( ID_AUTA, WYP ) 
	VALUES ( 5, 'NAVI')
INSERT INTO dbo.WYPAS( ID_AUTA, WYP ) 
	VALUES ( 5, 'AC')
INSERT INTO dbo.WYPAS( ID_AUTA, WYP ) 
	VALUES ( 5, 'HEAT')
INSERT INTO dbo.WYPAS( ID_AUTA, WYP ) 
	VALUES ( 5, 'ABS')

INSERT INTO dbo.WYPAS( ID_AUTA, WYP ) 
	VALUES ( 6, 'LETH')
INSERT INTO dbo.WYPAS( ID_AUTA, WYP ) 
	VALUES ( 6, 'AC')
INSERT INTO dbo.WYPAS( ID_AUTA, WYP ) 
	VALUES ( 6, 'CVT')

INSERT INTO dbo.WYPAS( ID_AUTA, WYP ) 
	VALUES ( 7, 'HEAT')
INSERT INTO dbo.WYPAS( ID_AUTA, WYP ) 
	VALUES ( 7, 'NAVI')
INSERT INTO dbo.WYPAS( ID_AUTA, WYP ) 
	VALUES ( 7, '4x4')
INSERT INTO dbo.WYPAS( ID_AUTA, WYP ) 
	VALUES ( 7, 'CVT')

INSERT INTO dbo.WYPAS( ID_AUTA, WYP ) 
	VALUES ( 8, 'ABS')

INSERT INTO dbo.WYPAS( ID_AUTA, WYP ) 
	VALUES ( 9, 'NAVI')


--SELECT *
--FROM dbo.AUTO
/*
ID_AUTA	MARKA	MODEL
1	BMW             	G4
2	Audi            	A1
3	Citroen         	C5
4	Toyota          	Go
5	Tesla           	S
6	Peugeot         	Amecat
7	Passat          	Najlepszy
8	BMW             	G5
9	Audi            	A6
*/

--SELECT *
--FROM dbo.SLOWNIK
/*
DODATKI
AC  
ABS 
NAVI
4x4 
LETH
HEAT
CVT 
*/

--SELECT *
--FROM dbo.WYP_AUTA
/*
WYP	OPIS
4x4 	Napęd na 4 koła
ABS 	Antyblokowanie kół podczas hamowania
AC  	Ubezpieczenie samochodu
CVT 	Automatyczna skrzynia biegów
HEAT	Ogrzewanie samochodu
LETH	Tajemnicze wyposażenie
NAVI	Wbudowana nawigacja
*/

--SELECT *
--FROM dbo.WYPAS
/*
ID_AUTA	WYP
1	HEAT
1	ABS 
2	4x4 
4	CVT 
5	NAVI
5	AC  
5	HEAT
5	ABS 
6	LETH
6	AC  
6	CVT 
7	HEAT
7	NAVI
7	4x4 
7	CVT 
8	ABS 
9	NAVI
*/


/* Przejdźmy teraz do poleceń */

-- Polecenie 1)
SELECT	a.ID_AUTA AS [ID Samochodu]
,		CONVERT( nvarchar(33), a.MARKA + ' ' + a.MODEL ) AS [Samochód] 
FROM dbo.AUTO a
WHERE NOT EXISTS (
		SELECT 1
		FROM dbo.WYPAS w
		WHERE (w.ID_AUTA = a.ID_AUTA)
)
/* Wynik zapytania:
ID Samochodu	Samochód
3				Citroen          C5
*/

-- Polecenie 2)
SELECT	a.ID_AUTA AS [ID Samochodu]
,		CONVERT( nvarchar(33), a.MARKA + ' ' + a.MODEL ) AS [Samochód] 
FROM dbo.AUTO a
WHERE NOT EXISTS (
		SELECT	1
		FROM	dbo.WYPAS w
		WHERE	(w.ID_AUTA = a.ID_AUTA)
		AND		(w.WYP = 'AC')
)
ORDER BY 1
/* Wynik zapytania:
ID Samochodu	Samochód
1	BMW              G4
2	Audi             A1
3	Citroen          C5
4	Toyota           Go
7	Passat           Najlepszy
8	BMW              G5
9	Audi             A6
*/


-- Polecenie 3)
SELECT	a.ID_AUTA AS [ID Samochodu]
,		CONVERT( nvarchar(33), a.MARKA + ' ' + a.MODEL ) AS [Samochód] 
FROM dbo.AUTO a
WHERE EXISTS (
				SELECT 1
				FROM dbo.WYPAS w
				WHERE (a.ID_AUTA = w.ID_AUTA)
				AND w.WYP = 'AC'
) AND EXISTS (
				SELECT 1
				FROM dbo.WYPAS w
				WHERE (a.ID_AUTA = w.ID_AUTA)
				AND w.WYP = 'ABS'
)
/* Wynik zapytania:
1	BMW              G4
5	Tesla            S
6	Peugeot          Amecat
8	BMW              G5
*/


-- Polecenie 4)
SELECT	a.ID_AUTA AS [ID Samochodu]
,		CONVERT( nvarchar(33), a.MARKA + ' ' + a.MODEL ) AS [Samochód] 
FROM dbo.AUTO a
WHERE EXISTS (
				SELECT 1
				FROM dbo.WYPAS w
				WHERE (a.ID_AUTA = w.ID_AUTA)
				AND w.WYP IN ('AC', 'ABS')
)

-- Polecenie 5)
SELECT	s.DODATKI AS [Wyposażenie]
,		COUNT( w.WYP ) AS [Ilość użytkujących samochodów]
FROM dbo.SLOWNIK s
LEFT OUTER JOIN dbo.WYPAS w
	ON (s.DODATKI = w.WYP)
GROUP BY s.DODATKI
/* Wynik zapytania: 
Wyposażenie	Ilość użytkujących samochodów
4x4 		2
ABS 		3
AC  		2
CVT 		3
HEAT		3
LETH		0 <--- Specjalnie na potrzeby polecenia wyzerowałem tę ilość, aby upewnić się, że polecenie zwróci także 0
NAVI		3
*/

-- Polecenie 6)
SELECT	TOP 1 WITH TIES
		a.ID_AUTA AS [ID najbardziej rozbudowanego Samochodu]
,		COUNT( w.WYP ) AS [Ilość dodatków]
FROM dbo.AUTO a
JOIN dbo.WYPAS w
	ON (w.ID_AUTA = a.ID_AUTA)
GROUP BY a.ID_AUTA
ORDER BY 2 DESC
/* Wynik zapytania:
ID	Samochodu	Ilość dodatków
5				4
7				4

Czyli obydwa samochody (5 i 6) mają największą ilość wyposażeń
*/