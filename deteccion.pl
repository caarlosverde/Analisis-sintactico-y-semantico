% =============================================================================
% ARCHIVO: deteccion.pl
% =============================================================================

analisis_semantico(Arbol) :-
    write('--- REVISION SEMANTICA ---'), nl,
    findall(P, (extraer_palabra(Arbol, P), es_ambigua(P)), Ambiguedades),
    list_to_set(Ambiguedades, AmbiguedadesUnicas),
    findall(M, detectar_metafora_arbol(Arbol, M), Metaforas),
    ( AmbiguedadesUnicas == [], Metaforas == [] -> 
        write('  [OK] Todo correcto. No se detectan problemas semanticos.'), nl
    ;   true
    ).

% --- Detección de Ambigüedad ---
es_ambigua(Palabra) :-
    tipo(Palabra, T1), tipo(Palabra, T2), T1 @< T2,
    write('  [!] AMBIGUEDAD LEXICA: La palabra "'), write(Palabra), 
    write('" puede referirse a ['), write(T1), write('] o ['), write(T2), write('].'), nl.

extraer_palabra(Arbol, Palabra) :-
    term_variables(Arbol, []), % Asegura que el arbol esta instanciado
    Arbol =.. [_, Arg1 | _],
    (Arg1 = n(Palabra) ; Arg1 = v(Palabra) ; extraer_palabra(Arg1, Palabra)).
extraer_palabra(Arbol, Palabra) :-
    Arbol =.. [_, _, Arg2 | _], extraer_palabra(Arg2, Palabra).

% --- Detección de Metáfora (Usando el Árbol) ---
detectar_metafora_arbol(o(GN_Suj, GV), true) :-
    obtener_nucleo(GN_Suj, Nombre), tipo(Nombre, TipoN),
    obtener_nucleo_v(GV, Verbo), tipo(Verbo, TipoV),
    choque_semantico(TipoN, TipoV),
    write('  [*] METAFORA/INCOHERENCIA: "'), write(Nombre), write('" no puede realizar la accion de "'), write(Verbo), write('".'), nl,
    explicar_metafora(Nombre, Verbo, TipoN, TipoV).
detectar_metafora_arbol(oc(O1, _, O2), true) :-
    (detectar_metafora_arbol(O1, true) ; detectar_metafora_arbol(O2, true)).

% Ayudante para sacar el verbo del GV
obtener_nucleo_v(gv(v(Verbo)), Verbo).
obtener_nucleo_v(gv(v(Verbo), _), Verbo).

% --- Incompatibilidades ---
choque_semantico(estructura_datos, accion_ofensiva).   
choque_semantico(informacion, accion_negativa).        
choque_semantico(informacion, estado_posesion).        
choque_semantico(disciplina, accion_relacional).