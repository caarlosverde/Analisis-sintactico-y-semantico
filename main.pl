:- [draw].         % El archivo que ya tienes
:- [sintactico].
:- [conjunto_oraciones].
% Estos se crearán en siguientes minutas
% :- [semantico]. 
% :- [deteccion].
% :- [mejoras].

% Predicado para analizar y dibujar una frase
analizar(ListaPalabras) :-
    oracion(Arbol, ListaPalabras, []),
    draw(Arbol).
