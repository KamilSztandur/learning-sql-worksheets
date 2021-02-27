/* Polecenie a) */
-- Przybyłem, przeczytałem, przećwiczyłem, zrozumiałem :)



/* Polecenie b) */
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
/* Wynik:
ID klienta	Klient			Pensja klienta	ID Firmy klienta	Miejscowość klienta
5			Ala Makota      6000			OGR       			Wesoła
*/





/* Polecenie c)
   Sprawdźmy, czy rzeczywiście pokazuje tylko etaty z miasta na literę W, szukając takiej samej pensji poza miastami na W */
SELECT 
	e.ID_OSOBY AS [ID klienta]
,	CONVERT( nvarchar(64), o.IMIE + ' ' + o.NAZWISKO ) AS [Klient]
,	e.PENSJA AS [Pensja klienta]
,	e.ID_FIRMY AS [ID Firmy klienta]
,	mO.NAZWA AS [MiejscowoÅ“Ã¦ klienta]
FROM dbo.ETATY e
JOIN dbo.OSOBY o 
	ON (o.ID_OSOBY = e.ID_OSOBY )
JOIN dbo.MIASTA mO
	ON (o.ID_MIASTA = mO.ID_MIASTA ) AND ( mO.NAZWA NOT LIKE 'W%' ) 
WHERE e.PENSJA = ( SELECT MAX( MAXe.PENSJA )
				   FROM dbo.ETATY MAXe, dbo.MIASTA MAXmO, dbo.OSOBY MAXo
				   WHERE ( MAXo.ID_MIASTA = MAXmO.ID_MIASTA ) 
						
						AND ( MAXo.ID_OSOBY = MAXe.ID_OSOBY )
						AND ( MAXmO.NAZWA LIKE 'W%' ) 
				 )
/* Wynik:
ID klienta	Klient					Pensja klienta	ID Firmy klienta	Miejscowość klienta
3			Ania Zzielonegowzgórza  6000			ES        			Tarnów

   Rzeczywiście w Tarnowie istnieje etat o takiej samej pensji, ale nie wyświetliło go w poprzednim zapytaniu.
   Podobnie tamten etat nie wyświetlił się teraz, gdy kazałem wyświetlać miasta nie zaczynające się na literę W.
   Więc wszystko jest prawidłowo :)
*/