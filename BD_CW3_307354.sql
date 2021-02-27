SELECT
	CONVERT( nvarchar(256), o.NAZWISKO 
	+ ' mieszka w ' + mO.NAZWA 
	+ ', a pracuje w ' + mF.NAZWA /* Tutaj powinna być nazwa miasta firmowego, a nie rodzinnego */
	+ ' jako ' + e.STANOWISKO 
	+ ' w firmie ' + f.NAZWA 
	) AS [Status klienta]
,	CONVERT( nvarchar(32),  wO.NAZWA ) AS [Województwo rodzinne]
,	CONVERT( nvarchar(32),  wF.NAZWA ) AS [Województwo firmowe]
FROM ETATY e, OSOBY o, FIRMY f, MIASTA mO, MIASTA mF, WOJ wO, WOJ wF
	WHERE (o.ID_MIASTA = mO.ID_MIASTA) AND ( e.ID_OSOBY = o.ID_OSOBY ) AND ( f.ID_MIASTA = mF.ID_MIASTA ) AND (f.NAZWA_SKR = e.ID_FIRMY )
	AND ( f.ID_MIASTA != o.ID_MIASTA ) AND ( wO.KOD_WOJ = mO.KOD_WOJ ) AND ( wF.KOD_WOJ = mF.KOD_WOJ )
/*
Status klienta																																														Województwo rodzinne	Województwo firmowe
Lewandowski                    mieszka w Warszawa, a pracuje w Tarnów jako Stolarz                                            w firmie Eagle Spark                                                 	Mazowieckie				Małopolska
Tartak                         mieszka w Gdańsk, a pracuje w Warszawa jako Malarz                                             w firmie Ogrodnicy                                                   	Pomorskie				Mazowieckie
Makota                         mieszka w Wesoła, a pracuje w Warszawa jako Spawacz                                            w firmie Ogrodnicy                                                   	Mazowieckie				Mazowieckie
Czubówna                       mieszka w Kraków, a pracuje w WesoÂ³a jako Kasjer                                             w firmie Now                                                         	Małopolska				Mazowieckie
Markowski                      mieszka w Warszawa, a pracuje w WesoÂ³a jako Magazynier                                         w firmie Now                                                         Mazowieckie				Mazowieckie
Sasin                          mieszka w Tarnów, a pracuje w GdaÃ±sk jako Kierowca                                           w firmie Edifier                                                     	Małopolska				Pomorskie
*/



IF OBJECT_ID('T_FA') IS NOT NULL
	DROP TABLE T_FA

IF OBJECT_ID('T_TOWAR') IS NOT NULL
	DROP TABLE T_TOWAR

IF OBJECT_ID('T_VAT') IS NOT NULL
	DROP TABLE T_VAT

CREATE TABLE T_VAT
(	v_code		nchar(1) NOT NULl CONSTRAINT PK_T_VAT PRIMARY KEY
,	v_name		nchar(6) NOT NULL
,	v_percent	money NOT NULL
)
GO
CREATE TABLE T_TOWAR
(	v_code		nchar(1) NOT NULl 
		CONSTRAINT FK__T_VAT__T_TOWAR FOREIGN KEY
		REFERENCES T_VAT(v_code)
,	id_tow		nchar(10) NOT NULL CONSTRAINT PK_T_TOW PRIMARY KEY
,	cena		money NOT NULL
)
/* pozycje z faktury */
CREATE TABLE T_FA
(	id_faktury	int NOT NULL /* powinien to być klucz obcy do tabeli Faktury */
 ,	id_tow		nchar(10)	/* co sprzedano */
		CONSTRAINT FK_T_FA__T_TOWAR FOREIGN KEY REFERENCES T_TOWAR(id_tow)
 ,	netto		money		NOT NULL /* po jakiej cenie - jka wtedy obowiązywała */
 ,	ilosc		money		NOT NULL
 ,	v_code		nchar(1)	NOT NULL /* po jakiej stawce - jaka wtedy obowiązywała */
	CONSTRAINT FK_T_FA__T_VAT REFERENCES T_VAT(v_code)
 )

GO

INSERT INTO T_VAT ( v_code, v_name, v_percent ) VALUES ('a','23%',0.23)
INSERT INTO T_VAT ( v_code, v_name, v_percent ) VALUES ('b','8%',0.08)
GO
INSERT INTO T_TOWAR( v_code, id_tow, cena ) VALUES (N'a', N'Jabłka', 10)
INSERT INTO T_TOWAR( v_code, id_tow, cena ) VALUES ( N'a', N'Gruszki', 10)
GO
/* wszystko po stawce 22 */
INSERT INTO T_FA (id_faktury, id_tow, netto, ilosc, v_code) VALUES (1, N'Jabłka', 10, 10, 'a')
INSERT INTO T_FA (id_faktury, id_tow, netto, ilosc, v_code) VALUES (2, N'Jabłka', 9, 9, 'a')
INSERT INTO T_FA (id_faktury, id_tow, netto, ilosc, v_code) VALUES (2, N'Gruszki', 12, 20, 'a')


UPDATE T_TOWAR SET v_code = 'b' 
INSERT INTO T_VAT ( v_code, v_name, v_percent ) VALUES ( 'c', '3%', 0.03 )
UPDATE T_TOWAR SET v_code = 'c' WHERE id_tow = N'Jabłka'


INSERT INTO T_FA ( id_faktury, id_tow, netto, ilosc, v_code ) VALUES ( 3, N'Jabłka', 9, 15, 'c' )
INSERT INTO T_FA ( id_faktury, id_tow, netto, ilosc, v_code ) VALUES ( 3, N'Gruszki', 12, 5, 'b' )


SELECT	STR(f.id_faktury,2,0) AS [ID]
,		t.id_tow 
,		str(f.netto,5,1)AS [cenaZfa]
,		STR(f.ilosc,5,1)AS [ileNaFa]
,		STR(f.ilosc*f.netto,6,1)
						AS [nettoFa]
,		STR(f.ilosc*f.netto*(1+vFa.v_percent) ,6,1)
						AS [bruttoFa]
,		vFa.v_code		AS [vatFa] 
,		vFa.v_name		AS [VaFaNazwa]				
,		str(vFa.v_percent,4,2)	
							AS VATfaProc 
,		vTow.v_name		AS [obecnyVat]
,		STR(t.cena,5,1)	AS [aktCena]
	/* wszystkie tabelki z naszej "mikrobazy" */
	FROM T_FA f, T_TOWAR t, T_VAT vFA, T_VAT vTow
	/* wszystkie klucze obce */
	WHERE	(f.id_tow = t.id_tow)
	AND		(f.v_code = vFa.v_code)
	AND		(t.v_code = vTow.v_code)



/*
dla jednokrotnego wybrania T_VAT kolumny przestają rozróżniać aktualny towarowy VAT od 
tego na fakturze i zaczynają wyświetlać albo tylko towarowy, albo tylko fakturowy w obu 
kolumnach (zależy jaki warunek relacji damy przy WHERE).
*/