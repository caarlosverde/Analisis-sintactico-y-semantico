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

% --- Extraccion recursiva de palabras (Corregida) ---
extraer_palabra(n(Palabra), Palabra).
extraer_palabra(v(Palabra), Palabra).
extraer_palabra(Arbol, Palabra) :-
    compound(Arbol),          
    Arbol =.. [_ | Hijos],    
    member(Hijo, Hijos),      
    extraer_palabra(Hijo, Palabra).

% --- Detección de Metáfora (Usando el Árbol) ---
detectar_metafora_arbol(o(GN_Suj, GV), true) :-
    obtener_nucleo(GN_Suj, Nombre), tipo(Nombre, TipoN),
    obtener_nucleo_v(GV, Verbo), tipo(Verbo, TipoV),
    choque_semantico(TipoN, TipoV),
    write('  [*] METAFORA/INCOHERENCIA: "'), write(Nombre), write('" no puede realizar la accion de "'), write(Verbo), write('".'), nl,
    explicar_metafora(Nombre, Verbo, TipoN, TipoV).

% 2. Para oraciones subordinadas de relativo (LA NUEVA)
detectar_metafora_arbol(o(or(GN_Suj, _, GV_Rel), _), true) :-
    obtener_nucleo(GN_Suj, Nombre), tipo(Nombre, TipoN),
    obtener_nucleo_v(GV_Rel, Verbo), tipo(Verbo, TipoV),
    choque_semantico(TipoN, TipoV),
    write('  [*] METAFORA/INCOHERENCIA (Subordinada): "'), write(Nombre), write('" no puede realizar la accion de "'), write(Verbo), write('".'), nl,
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