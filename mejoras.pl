% =============================================================================
% ARCHIVO: mejoras.pl
% CONTENIDO: Implementacion de 3 Mejoras Oficiales (Fase 4)
% =============================================================================

% -----------------------------------------------------------------------------
% MEJORA 1: PREPROCESAMIENTO DE TEXTO
% -----------------------------------------------------------------------------
analizar_texto(String) :-
    string_lower(String, StringMin),
    split_string(StringMin, " ", " .,;?!", ListaStrings),
    maplist(atom_string, ListaAtomos, ListaStrings),
    write('\n================================================'), nl,
    write('  FASE 1: ANALISIS LEXICO Y PREPROCESAMIENTO    '), nl,
    write('================================================'), nl,
    write('  Texto original : "'), write(String), write('"'), nl,
    write('  Lista de tokens: '), write(ListaAtomos), nl, nl,
    demostrar(ListaAtomos).

% -----------------------------------------------------------------------------
% MEJORA 3: ASIGNACIÓN DE FUNCIONES SINTÁCTICAS
% -----------------------------------------------------------------------------
mostrar_funciones(Arbol) :-
    extraer(Arbol).

extraer(o(GN, GV)) :-
    (obtener_nucleo(GN, Sujeto) -> write('  [Sujeto]: '), write(Sujeto), nl ; true),
    (GV = gv(v(Verbo), GN_Obj) -> 
        write('  [Verbo (Nucleo)]: '), write(Verbo), nl,
        (obtener_nucleo(GN_Obj, CD) -> write('  [Complemento Directo]: '), write(CD), nl ; true)
    ; GV = gv(v(Verbo), gadv(adv(Adv))) ->
        write('  [Verbo (Nucleo)]: '), write(Verbo), nl,
        write('  [Adverbio]: '), write(Adv), nl
    ; GV = gv(v(Verbo)) ->
        write('  [Verbo (Nucleo)]: '), write(Verbo), nl
    ; true), nl.
extraer(oc(O1, _, O2)) :- extraer(O1), extraer(O2).
extraer(_).

obtener_nucleo(gn(det(_), n(N), gadj(_)), N).
obtener_nucleo(gn(det(_), n(N)), N).
obtener_nucleo(gn(n(N)), N).
obtener_nucleo(or(GN_Base, _, _), N) :- obtener_nucleo(GN_Base, N).

% -----------------------------------------------------------------------------
% MEJORA 8: GENERACIÓN DE EXPLICACIONES AUTOMÁTICAS
% -----------------------------------------------------------------------------
explicar_metafora(Nombre, Verbo, TipoN, TipoV) :-
    write('  [!] EXPLICACION: Un elemento clasificado como ['), write(TipoN),
    write('] carece de la capacidad logica para realizar una ['),
    write(TipoV), write(']. Por lo tanto, la relacion "'),
    write(Nombre), write(' -> '), write(Verbo), write('" es un uso no literal.'), nl.