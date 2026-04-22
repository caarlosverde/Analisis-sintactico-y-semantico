:- module(conjunto_oraciones, [test_oracion/1, lista_oraciones/1]).

% Ejemplo de lista para pruebas automáticas
lista_oraciones([
    [el, programador, escribio, el, codigo],
    [el, virus, infecto, la, red],
    [el, tecnico, reparo, el, servidor, y, el, sistema, fallo]
]).

test_oracion(N) :-
    lista_oraciones(L),
    nth1(N, L, Oracion),
    write('Probando: '), write(Oracion), nl.
