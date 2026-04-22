% =============================================================================
% PROJECT: Syntactic and Semantic Analysis of Cryptography Sentences
% COURSE: Conocimiento y Razonamiento Automatizado (UAH)
% FILE: main.pl
% =============================================================================

:- consult(draw). % External tool for drawing constituent trees

% -----------------------------------------------------------------------------
% 1. EXECUTION PREDICATES (Main Interface)
% -----------------------------------------------------------------------------

% analyzes a sentence, draws the tree, and shows its simplified forms
analizar(Sentence) :-
    oracion(Tree, Sentence, []),
    draw(Tree),
    simplificar(Tree, SimpleForms),
    write('Simplified Sentences: '), write(SimpleForms), nl.

% Debugging predicate to test and explain results
demostrar(Sentence) :-
    write('--- STARTING ANALYSIS ---'), nl,
    (oracion(Tree, Sentence, []) -> 
        write('OK: Sentence parsed successfully.'), nl,
        draw(Tree),
        (simplificar(Tree, SimpleForms) -> 
            write('OK: Simplification logic applied:'), nl,
            write(SimpleForms), nl
        ;   write('ERR: Simplification failed.')), nl
    ;   write('ERR: Grammar rejected the sentence. Check the Lexicon.'), nl),
    write('--- END OF ANALYSIS ---'), nl.

% Predicate to test sentences from the internal corpus by index
test_oracion(N) :-
    lista_oraciones(L),
    nth1(N, L, Sentence),
    write('Testing sentence #'), write(N), write(': '), write(Sentence), nl,
    demostrar(Sentence).

% -----------------------------------------------------------------------------
% 2. DCG GRAMMAR RULES (Syntactic Structure)
% -----------------------------------------------------------------------------

% Top-level: A sentence can be coordinated or simple
oracion(O) --> o_coord(O).
oracion(O) --> o_simple(O).

% Coordinated Sentence (oc) - Handles optional commas before conjunctions
o_coord(oc(O1, C, O2)) --> o_simple(O1), [','], conjuncion(C), o_simple(O2).
o_coord(oc(O1, C, O2)) --> o_simple(O1), conjuncion(C), o_simple(O2).

% Simple Sentence (o)
o_simple(o(GN, GV)) --> g_nominal(GN), g_verbal(GV).

% Noun Phrase (gn): Basic or with an embedded relative clause
g_nominal(GN) --> gn_rel(GN).
g_nominal(GN) --> gn_basico(GN).

gn_basico(gn(D, N)) --> determinante(D), nombre(N).
gn_basico(gn(D, N, GAdj)) --> determinante(D), nombre(N), g_adjetival(GAdj).
gn_basico(gn(N)) --> nombre(N). 

% Relative Clause (or) within a Noun Phrase
gn_rel(or(GN_Base, rel(que), GV)) --> gn_basico(GN_Base), [que], g_verbal(GV).

% Verb Phrase (gv)
g_verbal(gv(V)) --> verbo(V).
g_verbal(gv(V, GN)) --> verbo(V), g_nominal(GN).
g_verbal(gv(V, Adv)) --> verbo(V), adverbio(Adv).
g_verbal(gv(V, GP)) --> verbo(V), g_preposicional(GP).

% Adjective Phrase (gadj)
g_adjetival(gadj(Adj)) --> adjetivo(Adj).

% Prepositional Phrase (gp): Includes special rule for "al" contraction
g_preposicional(gp(prep(a), gn(det(el), N))) --> [al], nombre(N).
g_preposicional(gp(P, GN)) --> preposicion(P), g_nominal(GN).

% -----------------------------------------------------------------------------
% 3. SIMPLIFICATION LOGIC (Sentence Decomposition)
% -----------------------------------------------------------------------------

% Recursively split coordinated sentences
simplificar(oc(O1, _, O2), Res) :-
    simplificar(O1, Res1),
    simplificar(O2, Res2),
    append(Res1, Res2, Res).

% Extract relative clause from the subject
simplificar(o(or(GN_Suj, rel(que), GV_Rel), GV_Princ), [o(GN_Suj, GV_Princ), o(GN_Suj, GV_Rel)]).

% Extract relative clause from the object
simplificar(o(GN_Suj, gv(V, or(GN_Obj, rel(que), GV_Rel))), [o(GN_Suj, gv(V, GN_Obj)), o(GN_Obj, GV_Rel)]).

% Base case for simple sentences
simplificar(Simple, [Simple]).

% -----------------------------------------------------------------------------
% 4. LEXICON (Vocabulary Dictionary)
% -----------------------------------------------------------------------------

determinante(det(el)) --> [el].
determinante(det(la)) --> [la].
determinante(det(los)) --> [los].
determinante(det(las)) --> [las].
determinante(det(un)) --> [un].
determinante(det(una)) --> [una].

nombre(n(dualidad)) --> [dualidad].
nombre(n(historia)) --> [historia].
nombre(n(matematicos)) --> [matematicos].
nombre(n(reconocimiento)) --> [reconocimiento].
nombre(n(voces)) --> [voces].
nombre(n(disponibilidad)) --> [disponibilidad].
nombre(n(algoritmos)) --> [algoritmos].
nombre(n(algoritmo)) --> [algoritmo].
nombre(n(comunidad)) --> [comunidad].
nombre(n(ciudadanos)) --> [ciudadanos].
nombre(n(ciudadano)) --> [ciudadano].
nombre(n(palabra)) --> [palabra].
nombre(n(secreto)) --> [secreto].
nombre(n(sensacion)) --> [sensacion].
nombre(n(programa)) --> [programa].
nombre(n(seguridad)) --> [seguridad].
nombre(n(software)) --> [software].
nombre(n(codigo)) --> [codigo].
nombre(n(patentes)) --> [patentes].
nombre(n(amenaza)) --> [amenaza].
nombre(n(militares)) --> [militares].
nombre(n(civiles)) --> [civiles].
nombre(n(civil)) --> [civil].
nombre(n(militar)) --> [militar].
nombre(n(enemigo)) --> [enemigo].
nombre(n(agujero)) --> [agujero].
nombre(n(gobierno)) --> [gobierno].
nombre(n(informacion)) --> [informacion].
nombre(n(usuario)) --> [usuario].
nombre(n(experto)) --> [experto].
nombre(n(fallos)) --> [fallos].
nombre(n(fallo)) --> [fallo].
nombre(n(vidas)) --> [vidas].
nombre(n(libertad)) --> [libertad].
nombre(n(acceso)) --> [acceso].
nombre(n(policia)) --> [policia].
nombre(n(comunicacion)) --> [comunicacion].
nombre(n(comunicaciones)) --> [comunicaciones].
nombre(n(persona)) --> [persona].
nombre(n(personas)) --> [personas].
nombre(n(sistema)) --> [sistema].
nombre(n(clave)) --> [clave].
nombre(n(programador)) --> [programador].
nombre(n(poder)) --> [poder].
nombre(n(tecnicas)) --> [tecnicas].
nombre(n(intimidad)) --> [intimidad].
nombre(n(echelon)) --> [echelon].
nombre(n(red)) --> [red].
nombre(n(anonimato)) --> [anonimato].
nombre(n(criptografia)) --> [criptografia].
nombre(n(tecnologia)) --> [tecnologia].
nombre(n(fuente)) --> [fuente].
nombre(n(humanidad)) --> [humanidad].
nombre(n(derecho)) --> [derecho].
nombre(n(estado)) --> [estado].
nombre(n(escrutinio)) --> [escrutinio].
nombre(n(puertas)) --> [puertas].
nombre(n(puerta)) --> [puerta].
nombre(n(ataque)) --> [ataque].
nombre(n(datos)) --> [datos].
nombre(n(politica)) --> [politica].
nombre(n(sociedad)) --> [sociedad].
nombre(n(conocimiento)) --> [conocimiento].
nombre(n(empresa)) --> [empresa].
nombre(n(vulnerabilidad)) --> [vulnerabilidad].
nombre(n(correo)) --> [correo].

verbo(v(provoco)) --> [provoco].
verbo(v(alcanzaron)) --> [alcanzaron].
verbo(v(alcanza)) --> [alcanza].
verbo(v(claman)) --> [claman].
verbo(v(son)) --> [son].
verbo(v(es)) --> [es].
verbo(v(escrutina)) --> [escrutina].
verbo(v(confian)) --> [confian].
verbo(v(provoca)) --> [provoca].
verbo(v(arruina)) --> [arruina].
verbo(v(mantiene)) --> [mantiene].
verbo(v(descubrieron)) --> [descubrieron].
verbo(v(encuentra)) --> [encuentra].
verbo(v(oculta)) --> [oculta].
verbo(v(estudia)) --> [estudia].
verbo(v(corrige)) --> [corrige].
verbo(v(vigila)) --> [vigila].
verbo(v(pierde)) --> [pierde].
verbo(v(pierden)) --> [pierden].
verbo(v(ralentiza)) --> [ralentiza].
verbo(v(intercepta)) --> [intercepta].
verbo(v(desarrolla)) --> [desarrolla].
verbo(v(rompe)) --> [rompe].
verbo(v(tiene)) --> [tiene].
verbo(v(conoce)) --> [conoce].
verbo(v(elimina)) --> [elimina].
verbo(v(controla)) --> [controla].
verbo(v(protegen)) --> [protegen].
verbo(v(protege)) --> [protege].
verbo(v(limitan)) --> [limitan].
verbo(v(monitoriza)) --> [monitoriza].
verbo(v(garantiza)) --> [garantiza].
verbo(v(defiende)) --> [defiende].
verbo(v(muestra)) --> [muestra].
verbo(v(permite)) --> [permite].
verbo(v(renuncian)) --> [renuncian].
verbo(v(facilita)) --> [facilita].
verbo(v(roba)) --> [roba].
verbo(v(desliga)) --> [desliga].
verbo(v(publica)) --> [publica].
verbo(v(evalua)) --> [evalua].
verbo(v(detecta)) --> [detecta].
verbo(v(esconde)) --> [esconde].
verbo(v(diseno)) --> [diseno].
verbo(v(ataca)) --> [ataca].
verbo(v(colapso)) --> [colapso].
verbo(v(espia)) --> [espia].
verbo(v(comete)) --> [comete].
verbo(v(usa)) --> [usa].

adjetivo(adj(civil)) --> [civil].
adjetivo(adj(accesibles)) --> [accesibles].
adjetivo(adj(buenos)) --> [buenos].
adjetivo(adj(malo)) --> [malo].
adjetivo(adj(libre)) --> [libre].

adverbio(adv(hoy)) --> [hoy].
adverbio(adv(siempre)) --> [siempre].
adverbio(adv(eventualmente)) --> [eventualmente].
adverbio(adv(tambien)) --> [tambien].

preposicion(prep(a)) --> [a].
preposicion(prep(con)) --> [con].
preposicion(prep(en)) --> [en].
preposicion(prep(por)) --> [por].

conjuncion(conj(y)) --> [y].
conjuncion(conj(pero)) --> [pero].
conjuncion(conj(o)) --> [o].

% -----------------------------------------------------------------------------
% 5. CORPUS OF SENTENCES (Source: Manuel J. Lucena Lopez)
% -----------------------------------------------------------------------------

lista_oraciones([
    % --- Simple Sentences (o) ---
    [la, dualidad, civil, provoco, la, historia],
    [los, matematicos, alcanzaron, el, reconocimiento],
    [las, voces, claman, la, disponibilidad],
    [los, algoritmos, accesibles, son, buenos],
    [la, comunidad, escrutina, los, algoritmos],
    [los, ciudadanos, confian, la, palabra],
    [el, secreto, provoca, una, sensacion],
    [un, programa, malo, arruina, la, seguridad],
    [el, software, libre, mantiene, el, codigo],
    [las, patentes, son, una, amenaza],

    % --- Coordinated Sentences (oc) ---
    [los, militares, descubrieron, los, algoritmos, y, los, civiles, alcanzaron, el, reconocimiento],
    [el, enemigo, encuentra, un, agujero, y, el, gobierno, oculta, la, informacion],
    [el, usuario, estudia, el, codigo, y, el, experto, corrige, los, fallos],
    [el, gobierno, vigila, las, vidas, y, el, ciudadano, pierde, la, libertad],
    [el, gobierno, ralentiza, el, acceso, o, la, policia, intercepta, la, comunicacion],
    [el, civil, publica, el, descubrimiento, ',', pero, el, militar, esconde, el, codigo],

    % --- Relative Clauses (or) ---
    [la, persona, que, desarrolla, el, algoritmo, rompe, el, codigo],
    [el, secreto, que, tiene, el, sistema, es, la, clave],
    [el, programador, que, conoce, el, codigo, elimina, los, fallos],
    [el, gobierno, que, controla, la, informacion, tiene, el, poder],
    [las, tecnicas, que, protegen, la, intimidad, limitan, el, poder],
    [echelon, es, la, red, que, monitoriza, las, comunicaciones],
    [el, anonimato, que, garantiza, la, libertad, protege, al, ciudadano],
    [la, criptografia, es, la, tecnologia, que, garantiza, el, anonimato],

    % --- Compound Sentences (ocm) ---
    [la, informacion, es, la, fuente, que, controla, la, humanidad],
    [el, ciudadano, que, protege, la, intimidad, defiende, el, derecho, ',', y, el, estado, pierde, el, poder],
    [el, programa, que, muestra, el, codigo, permite, el, escrutinio, ',', y, la, comunidad, corrige, el, fallo],
    [las, personas, que, renuncian, a, la, libertad, pierden, la, seguridad, ',', pero, el, gobierno, mantiene, el, poder],
    [el, software, que, tiene, las, puertas, facilita, el, ataque, ',', o, el, enemigo, roba, los, datos],
    [el, experto, que, diseno, el, algoritmo, publico, el, codigo, ',', y, la, sociedad, alcanza, el, conocimiento],
    [el, sistema, que, evalua, la, seguridad, detecta, la, amenaza, ',', pero, la, empresa, esconde, la, vulnerabilidad]
]).