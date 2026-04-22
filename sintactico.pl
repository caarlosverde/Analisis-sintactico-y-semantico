:- module(sintactico, [oracion/3]).

% --- REGLAS GRAMATICALES (Estructura de Árbol) ---

% Oración Simple (o)
oracion(o(GN, GV)) --> g_nominal(GN), g_verbal(GV).

% Oración Coordinada (oc)
oracion(oc(O1, C, O2)) --> oracion(O1), conjuncion(C), oracion(O2).

% Grupos Sintácticos
g_nominal(gn(N)) --> nombre(N).
g_nominal(gn(D, N)) --> determinante(D), nombre(N).
g_nominal(gn(D, N, GAdj)) --> determinante(D), nombre(N), g_adjetival(GAdj).
% Relativo: "El virus que atacó el sistema"
g_nominal(gn_rel(GN, Rel, GV)) --> g_nominal(GN), [que], {Rel = rel(que)}, g_verbal(GV).

g_verbal(gv(V)) --> verbo(V).
g_verbal(gv(V, GN)) --> verbo(V), g_nominal(GN).
g_verbal(gv(V, GP)) --> verbo(V), g_preposicional(GP).
g_verbal(gv(Adv, V, GN)) --> adverbio(Adv), verbo(V), g_nominal(GN).

g_adjetival(gadj(Adj)) --> adjetivo(Adj).
g_preposicional(gp(P, GN)) --> preposicion(P), g_nominal(GN).

% --- DICCIONARIO TECNOLÓGICO (Léxico) ---
determinante(det(el)) --> [el].
determinante(det(la)) --> [la].
determinante(det(un)) --> [un].

nombre(n(programador)) --> [programador].
nombre(n(codigo)) --> [codigo].
nombre(n(virus)) --> [virus].
nombre(n(red)) --> [red].
nombre(n(sistema)) --> [sistema].
nombre(n(servidor)) --> [servidor].
nombre(n(datos)) --> [datos].
nombre(n(ordenador)) --> [ordenador].
nombre(n(tecnico)) --> [tecnico].

verbo(v(escribio)) --> [escribio].
verbo(v(infecto)) --> [infecto].
verbo(v(procesa)) --> [procesa].
verbo(v(fallo)) --> [fallo].
verbo(v(reparo)) --> [reparo].
verbo(v(ataco)) --> [ataco].
verbo(v(colapso)) --> [colapso].

adjetivo(adj(rapido)) --> [rapido].
adjetivo(adj(roto)) --> [roto].

adverbio(adv(ayer)) --> [ayer].
adverbio(adv(mal)) --> [mal].

preposicion(prep(con)) --> [con].
preposicion(prep(en)) --> [en].

conjuncion(conj(y)) --> [y].
conjuncion(conj(pero)) --> [pero].
