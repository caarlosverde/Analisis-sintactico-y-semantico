% =============================================================================
% PROYECTO: Analisis Sintactico y Semantico de Oraciones
% DOMINIO: Historia y Teoria de la Criptografia
% ARCHIVO: main.pl (Controlador Principal)
% =============================================================================

:- consult(draw). 
:- include('conjunto_oraciones.pl').
:- include('sintactico.pl').
:- include('semantico.pl').
:- include('deteccion.pl'). 
:- include('mejoras.pl'). 

% -----------------------------------------------------------------------------
% PREDICADOS DE EJECUCION E INTERFAZ
% -----------------------------------------------------------------------------

analizar(Oracion) :-
    oracion(Arbol, Oracion, []),
    draw(Arbol),
    mostrar_funciones(Arbol),
    simplificar(Arbol, Simples),
    write('Oraciones Simplificadas: '), write(Simples), nl.

demostrar(Oracion) :-
    write('================================================'), nl,
    write('  FASE 2: ANALISIS SINTACTICO (PARSING)         '), nl,
    write('================================================'), nl,
    (oracion(Arbol, Oracion, []) -> 
        write('  [OK] La oracion cumple las reglas gramaticales (DCG).'), nl,
        draw(Arbol), nl,
        
        write('================================================'), nl,
        write('  FASE 3: EXTRACCION DE ROLES (MEJORA 3)        '), nl,
        write('================================================'), nl,
        mostrar_funciones(Arbol),
        
        write('================================================'), nl,
        write('  FASE 4: SIMPLIFICACION LOGICA                 '), nl,
        write('================================================'), nl,
        (simplificar(Arbol, Simples) -> 
            write('  [OK] Oracion descompuesta en estructuras simples:'), nl,
            write('  '), write(Simples), nl, nl
        ;   write('  [ERROR] Fallo en la simplificacion.'), nl),
        
        write('================================================'), nl,
        write('  FASE 5: REVISION SEMANTICA (FASE 2.3)         '), nl,
        write('================================================'), nl,
        analisis_semantico(Arbol)
    ;   write('  [ERROR] La gramatica rechazo la oracion. Revisa el lexico.'), nl),
    write('\n================================================'), nl,
    write('                FIN DEL ANALISIS                '), nl,
    write('================================================'), nl.

test_oracion(N) :-
    lista_oraciones(L),
    nth1(N, L, Oracion),
    write('\nProbando oracion #'), write(N), write(': '), write(Oracion), nl,
    demostrar(Oracion).