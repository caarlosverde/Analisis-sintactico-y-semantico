% =============================================================================
% ARCHIVO: draw.pl (VERSION PROFESIONAL CLI-STYLE)
% CONTENIDO: Visualizador Dinamico de Arbol Sintactico Abstracto (AST)
% =============================================================================

draw(Arbol) :-
    write('\n--- ARBOL SINTACTICO (AST) PROFESIONAL ---'), nl,
    Arbol =.. [Raiz | Hijos],
    write('['), write(Raiz), write(']'), nl,
    imprimir_hijos(Hijos, '').

% Caso base: no hay hijos que imprimir
imprimir_hijos([], _).

% Caso A: Es el ÚLTIMO hijo de la lista (cierra la rama con \--)
imprimir_hijos([Hijo], Prefijo) :-
    write(Prefijo), write('\\-- '),
    procesar_nodo(Hijo, Prefijo, '    ').

% Caso B: Es un hijo INTERMEDIO (usa |-- y pasa la linea vertical | a sus hijos)
imprimir_hijos([Hijo | Resto], Prefijo) :-
    Resto \= [],
    write(Prefijo), write('|-- '),
    procesar_nodo(Hijo, Prefijo, '|   '),
    imprimir_hijos(Resto, Prefijo).

% Procesa el contenido del nodo actual
procesar_nodo(Nodo, PrefijoActual, Espaciado) :-
    Nodo =.. [Functor | Args],
    ( Args = [Hoja], atomic(Hoja) ->
        % Es una hoja terminal (el final de la rama: la palabra)
        write('['), write(Functor), write('] -> "'), write(Hoja), write('"'), nl
    ;
        % Es un nodo intermedio (tiene mas ramas colgando)
        write('['), write(Functor), write(']'), nl,
        atom_concat(PrefijoActual, Espaciado, NuevoPrefijo),
        imprimir_hijos(Args, NuevoPrefijo)
    ).