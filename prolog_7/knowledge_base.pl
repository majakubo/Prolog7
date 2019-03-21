zadanie(ZAD):- ZAD = zadanie1.

    plansza([[w  ,w  ,w  ,w  ,w  ,w  ,w  ,w  ,w  ],
			 [w,  b1R,b1 ,r1R,r1 ,x  ,g1R,y1R,w  ],
             [w,  b1 ,b1 ,x  ,r2R,r2 ,x  ,y1 ,w  ],
             [w,  x  ,x  ,x  ,y2R,g2R,x  ,y3R,w  ],
             [w,  p1R,p1 ,z  ,y2 ,g3R,x  ,y3 ,w  ],
             [w,  p1 ,p1 ,x  ,x  ,x  ,b2R,b2 ,w  ],
             [w,  p1 ,p1 ,x  ,r3R,r3 ,b2 ,b2 ,w  ],
             [w  ,w  ,w  ,w  ,w  ,w  ,w  ,w  ,w  ]]).
% Manipulacja stringiem
     pierwszy_znak(Z, PZ):-
        string_chars(Z, Str),
        nth0(0, Str, PZ).
% REGUŁY PRZYNALEŻNOŚCI DO KOLORÓW i ROGÓW
    blue(C):-
        string_chars(C, [H|_]),
        H = b.
        
    red(C):-
        string_chars(C, [H|_]),
        H = r.
     
    purple(C):-
        string_chars(C, [H|_]),
        H = p.
     
    yellow(C):-
        string_chars(C, [H|_]),
        H = y.

    green(C):-
        string_chars(C, [H|_]),
        H = g.

    czy_jest_rogiem(Z):-
        string_chars(Z, Str),
        nth0(_, Str, r).

%SPRAWDZANIE OBIEKTU NA POLU X Y    
    %%czy_puste(B,[[X,Y]|[]]).
    czy_puste(B, Y, X) :-
        pozycja(B, Y, X, x).
    
    czy_sciana(B, Y, X, _):-
        zadanie(zadanie2),
        pozycja(B, Y, X, w).  
    
    czy_sciana(B, Y, X, Kolor_Klocka):-
    	 zadanie(zadanie1),
         pozycja(B, Y, X, w);
    	 \+pozycja(B, Y, X, Kolor_Klocka).      
    
    pozycja(B, Y, X, Char) :-
        nth0(Y, B, Column), 
        nth0(X, Column, Char).
    

% REGUŁY MODYFIKOWANIA PLANSZY
   
    podmien_w_liscie(Index, Elem, [_|T], [Elem|T]) :-
        Index = 0, !. 
    podmien_w_liscie(Index, Elem, [H|T], [H|Out]) :-
        Index1 is Index - 1,
        podmien_w_liscie(Index1, Elem, T, Out).  
     
    wstaw_do_dwuwymiarowej([X1,Y1,C],B, Bnew) :-
        nth0(X1, B, ColFrom),
        podmien_w_liscie(Y1, C, ColFrom, ColFromNew),
        podmien_w_liscie(X1, ColFromNew, B, Bnew).
	
    wykonaj_wiele_przemieszczen([], B, Bnew):-
        Bnew = B, !.

	%wykonaj_wiele_przemieszczen(lista wspolrzednych i znakow->[[x, y, z]..],
	%                            Board, Bnew)
    wykonaj_wiele_przemieszczen([H|T], B, Bnew):-
    	wstaw_do_dwuwymiarowej(H, B, Btemp),
        wykonaj_wiele_przemieszczen(T, Btemp, Bnew).
	
% ROZPAKOWYWANIE LISTY
	rozpakuj_jedno_elementowa_liste([H|_], H).
	
    rozpakuj_dwu_elementowa_liste([H|T], H, B):-
        rozpakuj_jedno_elementowa_liste(T, B).
	
    rozpakuj_trzy_elementowa_liste([H|T], H, B, C):-
        rozpakuj_dwu_elementowa_liste(T, B, C).

    
% ZNAJDYWANIE ROGU
     
     znajdz_rog_przeszkody(R, _, R):-
         rozpakuj_trzy_elementowa_liste(R, _, _, Z),
         czy_jest_rogiem(Z), !.
     znajdz_rog_przeszkody(R, B, [Yr,Xr, CharNew]) :-
        rozpakuj_trzy_elementowa_liste(R, _, _, C),
        atom_concat(C, 'R', CharNew),
	    pozycja(B,Yr,Xr,CharNew).
        

%przemieszczanie klocka
    przemiesc(R, B, Bnew):-
        rozpakuj_trzy_elementowa_liste(R, _, _, Z),
        pierwszy_znak(Z, Kolor),
        czy_mozliwy(R, B, Bnew, d, Kolor),
        !.
    przemiesc(R, B, Bnew):-
        rozpakuj_trzy_elementowa_liste(R, _, _, Z),
        pierwszy_znak(Z, Kolor),
        czy_mozliwy(R, B, Bnew, l, Kolor),
        !.
    przemiesc(R, B, Bnew):-
        rozpakuj_trzy_elementowa_liste(R, _, _, Z),
        pierwszy_znak(Z, Kolor),
        czy_mozliwy(R, B, Bnew, p, Kolor),
        !.
    przemiesc(R, B, Bnew):-
        rozpakuj_trzy_elementowa_liste(R, Y, X, Z),
        pierwszy_znak(Z, Kolor),
        czy_mozliwy(R, B, Bnew, g, Kolor),
        !.        



% Możliwość poruszania się	

    %zielony dol 
    czy_mozliwy(R, B, Bnew, Kierunek, Kolor):-
        Kierunek = d,
        Kolor = z,
        rozpakuj_trzy_elementowa_liste(R, Y, X, _),
        Y1 is Y+1,
        czy_puste(B, Y1, X),
        wykonaj_ruch(R, B, Bnew, Kierunek, Kolor),!.
    
    %zielony dol  
    czy_mozliwy(R, B, Bnew, Kierunek, Kolor):-
        Kierunek = d,
        Kolor = z,
        rozpakuj_trzy_elementowa_liste(R, Y, X, Z),
        Y1 is Y+1,
        \+ czy_puste(B, Y1, X),
        \+ czy_sciana(B, Y1, X, Z),
        pozycja(B, Y1, X, C),
        znajdz_rog_przeszkody([Y1, X, C], B, Rnew),
        przemiesc(Rnew, B, BnewT),
        wykonaj_ruch(R, BnewT, Bnew, Kierunek, Kolor),!.
    
    %zielony gora 
    czy_mozliwy(R, B, Bnew, Kierunek, Kolor):-
        Kierunek = g,
        Kolor = z,
        rozpakuj_trzy_elementowa_liste(R, Y, X, _),
        Y1 is Y-1,
        czy_puste(B, Y1, X),
        wykonaj_ruch(R, B, Bnew, Kierunek, Kolor),!.
    
    %zielony gora  
    czy_mozliwy(R, B, Bnew, Kierunek, Kolor):-
        Kierunek = g,
        Kolor = z,
        rozpakuj_trzy_elementowa_liste(R, Y, X, Z),
        Y1 is Y-1,
        \+ czy_puste(B, Y1, X),
        \+ czy_sciana(B, Y1, X, Z),
        pozycja(B, Y1, X, C),
        znajdz_rog_przeszkody([Y1, X, C], B, Rnew),
        przemiesc(Rnew, B, BnewT),
        wykonaj_ruch(R, BnewT, Bnew, Kierunek, Kolor),!.
    
    %zielony lewo  
    czy_mozliwy(R, B, Bnew, Kierunek, Kolor):-
        Kierunek = l,
        Kolor = z,
        rozpakuj_trzy_elementowa_liste(R, Y, X, Z),
        X1 is X-1,
        czy_puste(B, Y, X1),
        wykonaj_ruch(R, B, Bnew, Kierunek, Kolor),!.
    
    %zielony lewo   
    czy_mozliwy(R, B, Bnew, Kierunek, Kolor):-
        Kierunek = l,
        Kolor = z,
        rozpakuj_trzy_elementowa_liste(R, Y, X, Z),
        X1 is X-1,
        \+ czy_puste(B, Y, X1),
        \+ czy_sciana(B, Y, X1, Z),
        pozycja(B, Y, X1, C),
        znajdz_rog_przeszkody([Y, X1, C], B, Rnew),
        przemiesc(Rnew, B, BnewT),
        wykonaj_ruch(R, BnewT, Bnew, Kierunek, Kolor),!.
	
    %zielony prawo
	czy_mozliwy(R, B, Bnew, Kierunek, Kolor):-
        Kierunek = p,
        Kolor = z,
        rozpakuj_trzy_elementowa_liste(R, Y, X, _),
        X1 is X+1,
        czy_puste(B, Y, X1),
        wykonaj_ruch(R, B, Bnew, Kierunek, Kolor),!.
    
    %zielony prawo  
    czy_mozliwy(R, B, Bnew, Kierunek, Kolor):-
        Kierunek = p,
        Kolor = z,
        rozpakuj_trzy_elementowa_liste(R, Y, X, Z),
        X1 is X+1,
        \+ czy_puste(B, Y, X1),
        \+ czy_sciana(B, Y1, X, Z),
        pozycja(B, Y, X1, C),
        znajdz_rog_przeszkody([Y, X1, C], B, Rnew),
        przemiesc(Rnew, B, BnewT),
        wykonaj_ruch(R, BnewT, Bnew, Kierunek, Kolor),!.
	
	
	
	
    


             
%REGUŁY PORUSZANIA SIĘ
%zielony dol 
wykonaj_ruch(R, B, Bnew, Kierunek, Kolor):-
        Kolor = z,
        Kierunek = d,
        rozpakuj_trzy_elementowa_liste(R, Y, X, Z),
        N is Y+1,
        wykonaj_wiele_przemieszczen([[Y, X, x], [N, X, Z]], B, Bnew).
 
%zielony gora 
wykonaj_ruch(R, B, Bnew, Kierunek, Kolor):-
        Kolor = z,
        Kierunek = g,
        rozpakuj_trzy_elementowa_liste(R, Y, X, Z),
        N is Y-1,
        wykonaj_wiele_przemieszczen([[Y, X, x], [N, X, Z]], B, Bnew).
%zielony lewo
wykonaj_ruch(R, B, Bnew, Kierunek, Kolor):-
        Kolor = z,
        Kierunek = l,
        rozpakuj_trzy_elementowa_liste(R, Y, X, Z),
        N is X-1,
        wykonaj_wiele_przemieszczen([[Y, X, x], [Y, N, Z]], B, Bnew).
% zielony prawo 
wykonaj_ruch(R, B, Bnew, Kierunek, Kolor):-
        Kolor = z,
        Kierunek = p,    
        rozpakuj_trzy_elementowa_liste(R, Y, X, Z),
        N is X+1,
        wykonaj_wiele_przemieszczen([[Y, X, x], [Y, N, Z]], B, Bnew).
%czerowny dol 
wykonaj_ruch(R, B, Bnew, Kierunek, Kolor):-
        Kolor = c,
        Kierunek = d,    
        rozpakuj_trzy_elementowa_liste(R, Y, X, Z),
        N is Y+1,
    	M is X+1,
         wykonaj_wiele_przemieszczen([[Y, X, x], [Y, M, x], [N,X,Z],[N,M,Z]], B, Bnew).
%czerwony gora 
wykonaj_ruch(R, B, Bnew, Kierunek, Kolor):-
        Kolor = c,
        Kierunek = g,    
        rozpakuj_trzy_elementowa_liste(R, Y, X, Z),
        N is Y-1,
    	M is X+1,
         wykonaj_wiele_przemieszczen([[Y, X, x], [Y, M, x], [N,X,Z],[N,M,Z]], B, Bnew).
%czerwony lewo 
wykonaj_ruch(R, B, Bnew, Kierunek, Kolor):-
        Kolor = c,
        Kierunek = l,    
        rozpakuj_trzy_elementowa_liste(R, Y, X, Z),
        N is X-1, 
    	M is X+1,
        wykonaj_wiele_przemieszczen([[Y,M,x], [Y,N,Z]], B, Bnew).
%czerwony prawo 
wykonaj_ruch(R, B, Bnew, Kierunek, Kolor):-
        Kolor = c,
        Kierunek = p,        
        rozpakuj_trzy_elementowa_liste(R, Y, X, Z),
    	M is X+2,
        wykonaj_wiele_przemieszczen([[Y,X,x],[Y,M,Z]], B, Bnew).
%zolty dol 
wykonaj_ruch(R, B, Bnew, Kierunek, Kolor):-
        Kolor = z,
        Kierunek = d,    
        rozpakuj_trzy_elementowa_liste(R, Y, X, Z),
    	M is Y+2,
        wykonaj_wiele_przemieszczen([[Y,X,x],[M,X,Z]], B, Bnew).
%zolty gora 
wykonaj_ruch(R, B, Bnew, Kierunek, Kolor):-
        Kolor = z,
        Kierunek = g,    
        rozpakuj_trzy_elementowa_liste(R, Y, X, Z),
    	M is Y-1,
    	N is Y+1,
        wykonaj_wiele_przemieszczen([[M,X,Z],[N,X,x]], B, Bnew).
%zolty prawo 
wykonaj_ruch(R, B, Bnew, Kierunek, Kolor):-
        Kolor = z,
        Kierunek = p,    
        rozpakuj_trzy_elementowa_liste(R, Y, X, Z),
    	M is X+1,
    	N is Y+1,
        wykonaj_wiele_przemieszczen([[Y,X,x],[N,X,x],[Y,M,Z],[N,M,Z]],B, Bnew).
 
%zolty lewo 
wykonaj_ruch(R, B, Bnew, Kierunek, Kolor):-
        Kolor = z,
        Kierunek = l,    
        rozpakuj_trzy_elementowa_liste(R, Y, X, Z),
    	M is X-1,
    	N is Y+1,
        wykonaj_wiele_przemieszczen([[Y,X,x],[N,X,x],[Y,M,Z],[N,M,Z]], B, Bnew).
%niebieski dol 
wykonaj_ruch(R, B, Bnew, Kierunek, Kolor):-
        Kolor = n,
        Kierunek = d,    
        rozpakuj_trzy_elementowa_liste(R, Y, X, Z),
    	M is X + 1,
    	N is Y + 2,
        wykonaj_wiele_przemieszczen([[Y,X,x],[Y,M,x],[N,X,Z],[N,M,Z]], B, Bnew).
%niebieski gora 
wykonaj_ruch(R, B, Bnew, Kierunek, Kolor):-
     Kolor = n,
        Kierunek = g,    
       rozpakuj_trzy_elementowa_liste(R, Y, X, Z),
    	M is Y + 1,
    	N is X +1,
    	Q is Y - 1,
        wykonaj_wiele_przemieszczen([[M,X,x],[M,N,x],[Q, X, Z], [Q,N, Z]], B, Bnew).
%niebieski prawo 
wykonaj_ruch(R, B, Bnew, Kierunek, Kolor):-
        Kolor = n,
        Kierunek = p,        
        rozpakuj_trzy_elementowa_liste(R, Y, X, Z),
    	M is Y + 1,
    	N is X + 2,
        wykonaj_wiele_przemieszczen([[Y,X,x],[M,X,x],[Y,N,Z],[M,N,Z]], B, Bnew).
%niebieski lewo 
wykonaj_ruch(R, B, Bnew, Kierunek, Kolor):-
        Kolor = n,
        Kierunek = l,    
        rozpakuj_trzy_elementowa_liste(R, Y, X, Z),
    	M is X + 1,
    	N is Y + 1,
    	Q is X - 1,
        wykonaj_wiele_przemieszczen([[Y,M,x],[N,M,x],[Y,Q,Z],[N,Q,Z]], B, Bnew).
%fioletowy gora 
wykonaj_ruch(R, B, Bnew, Kierunek, Kolor):-
        Kolor = f,
        Kierunek = g,    
        rozpakuj_trzy_elementowa_liste(R, Y, X, Z),
    	M is X + 1,
    	N is Y - 1,
    	Q is Y + 2,
        wykonaj_wiele_przemieszczen([[N,X,Z],[N,M,Z],[Q,X,x],[Q,M,x]], B, Bnew).
%fioletowy dol 
wykonaj_ruch(R, B, Bnew, Kierunek, Kolor):-
        Kolor = f,
        Kierunek = d,    
        rozpakuj_trzy_elementowa_liste(R, Y, X, Z),
    	M is Y + 3,
    	N is X + 1,
        wykonaj_wiele_przemieszczen([[Y,X,x],[Y,N,x],[M,X,Z],[M,N,Z]], B, Bnew).

%%fioletowy lewo 
wykonaj_ruch(R, B, Bnew, Kierunek, Kolor):-
        Kolor = f,
        Kierunek = l,    
        rozpakuj_trzy_elementowa_liste(R, Y, X, Z),
    	N is X + 1,
    	M is Y + 1,
    	Q is Y + 2,
    	W is X - 1,
        wykonaj_wiele_przemieszczen([[Y,N,x],[M,N,x],[Q,N,x],[Y,W,Z],[M,W,Z],[Q,W,Z]], B, Bnew).

%%fioletowy prawo 
wykonaj_ruch(R, B, Bnew, Kierunek, Kolor):-
        Kolor = f,
        Kierunek = p,    
        rozpakuj_trzy_elementowa_liste(R, Y, X, Z),
    	M is Y + 1,
    	N is Y + 2,
    	Q is X + 2,
        wykonaj_wiele_przemieszczen([[Y,X,x],[M,X,x],[N,X,x],[Y,Q,Z],[M,Q,Z],[N,Q,Z]], B, Bnew).
 
