% =============================================================================
% PROYECTO: Análisis Sintáctico y Semántico de Oraciones
% DOMINIO: Historia y Teoría de la Criptografía
% =============================================================================

:- consult(draw). % Herramienta externa para dibujar los árboles

% -----------------------------------------------------------------------------
% 1. PREDICADOS DE EJECUCIÓN E INTERFAZ
% -----------------------------------------------------------------------------

% Predicado básico para analizar y simplificar
analizar(Oracion) :-
    oracion(Arbol, Oracion, []),
    draw(Arbol),
    simplificar(Arbol, Simples),
    write('Oraciones Simplificadas: '), write(Simples), nl.

% Predicado estrella para la defensa (A prueba de balas)
demostrar(Oracion) :-
    write('--- INICIANDO ANALISIS ---'), nl,
    (oracion(Arbol, Oracion, []) -> 
        write('OK: La oracion es sintacticamente correcta.'), nl,
        draw(Arbol),
        (simplificar(Arbol, Simples) -> 
            write('OK: Simplificacion logica conseguida:'), nl,
            write(Simples), nl
        ;   write('ERROR: Fallo en la simplificacion.')), nl
    ;   write('ERROR: La gramatica rechazo la oracion. Revisa el lexico.'), nl),
    write('--- FIN DEL ANALISIS ---'), nl.

% Predicado para probar oraciones del corpus por número (1 al 30)
test_oracion(N) :-
    lista_oraciones(L),
    nth1(N, L, Oracion),
    write('Probando oracion #'), write(N), write(': '), write(Oracion), nl,
    demostrar(Oracion).

% -----------------------------------------------------------------------------
% 2. REGLAS GRAMATICALES (DCG)
% -----------------------------------------------------------------------------

oracion(O) --> o_coord(O).
oracion(O) --> o_simple(O).

o_coord(oc(O1, C, O2)) --> o_simple(O1), [','], conjuncion(C), o_simple(O2).
o_coord(oc(O1, C, O2)) --> o_simple(O1), conjuncion(C), o_simple(O2).

o_simple(o(GN, GV)) --> g_nominal(GN), g_verbal(GV).

g_nominal(GN) --> gn_rel(GN).
g_nominal(GN) --> gn_basico(GN).

gn_basico(gn(D, N)) --> determinante(D), nombre(N).
gn_basico(gn(D, N, GAdj)) --> determinante(D), nombre(N), g_adjetival(GAdj).
gn_basico(gn(N)) --> nombre(N). 

gn_rel(or(GN_Base, rel(que), GV)) --> gn_basico(GN_Base), [que], g_verbal(GV).

g_verbal(gv(V)) --> verbo(V).
g_verbal(gv(V, GN)) --> verbo(V), g_nominal(GN).
g_verbal(gv(V, Adv)) --> verbo(V), adverbio(Adv).
g_verbal(gv(V, GP)) --> verbo(V), g_preposicional(GP).

g_adjetival(gadj(Adj)) --> adjetivo(Adj).

% Contracciones obligatorias del español
g_preposicional(gp(prep(a), gn(det(el), N))) --> [al], nombre(N).
g_preposicional(gp(prep(de), gn(det(el), N))) --> [del], nombre(N).
g_preposicional(gp(P, GN)) --> preposicion(P), g_nominal(GN).

% -----------------------------------------------------------------------------
% 3. LÓGICA DE SIMPLIFICACIÓN RECURSIVA
% -----------------------------------------------------------------------------

simplificar(oc(O1, _, O2), Res) :-
    simplificar(O1, Res1),
    simplificar(O2, Res2),
    append(Res1, Res2, Res).

simplificar(o(or(GN_Suj, rel(que), GV_Rel), GV_Princ), [o(GN_Suj, GV_Princ), o(GN_Suj, GV_Rel)]).
simplificar(o(GN_Suj, gv(V, or(GN_Obj, rel(que), GV_Rel))), [o(GN_Suj, gv(V, GN_Obj)), o(GN_Obj, GV_Rel)]).
simplificar(Simple, [Simple]).

% -----------------------------------------------------------------------------
% 4. DICCIONARIO LÉXICO
% -----------------------------------------------------------------------------

determinante(det(el)) --> [el].
determinante(det(la)) --> [la].
determinante(det(los)) --> [los].
determinante(det(las)) --> [las].
determinante(det(un)) --> [un].
determinante(det(una)) --> [una].

nombre(n(libro)) --> [libro].
nombre(n(evolucion)) --> [evolucion].
nombre(n(criptografia)) --> [criptografia].
nombre(n(computadoras)) --> [computadoras].
nombre(n(criptoanalisis)) --> [criptoanalisis].
nombre(n(seguridad)) --> [seguridad].
nombre(n(canal)) --> [canal].
nombre(n(probabilidad)) --> [probabilidad].
nombre(n(informacion)) --> [informacion].
nombre(n(esteganografia)) --> [esteganografia].
nombre(n(censura)) --> [censura].
nombre(n(euclides)) --> [euclides].
nombre(n(inversa)) --> [inversa].
nombre(n(contrasena)) --> [contrasena].
nombre(n(contrasenas)) --> [contrasenas].
nombre(n(letras)) --> [letras].
nombre(n(espectro)) --> [espectro].
nombre(n(rango)) --> [rango].
nombre(n(algoritmos)) --> [algoritmos].
nombre(n(algoritmo)) --> [algoritmo].
nombre(n(bloques)) --> [bloques].
nombre(n(tiempo)) --> [tiempo].
nombre(n(dato)) --> [dato].
nombre(n(valor)) --> [valor].
nombre(n(destinatario)) --> [destinatario].
nombre(n(mensaje)) --> [mensaje].
nombre(n(mensajes)) --> [mensajes].
nombre(n(usuario)) --> [usuario].
nombre(n(texto)) --> [texto].
nombre(n(receptor)) --> [receptor].
nombre(n(gobierno)) --> [gobierno].
nombre(n(vidas)) --> [vidas].
nombre(n(ciudadano)) --> [ciudadano].
nombre(n(libertad)) --> [libertad].
nombre(n(suma)) --> [suma].
nombre(n(propiedad)) --> [propiedad].
nombre(n(elemento)) --> [elemento].
nombre(n(simetria)) --> [simetria].
nombre(n(certeza)) --> [certeza].
nombre(n(suceso)) --> [suceso].
nombre(n(incertidumbre)) --> [incertidumbre].
nombre(n(claves)) --> [claves].
nombre(n(clave)) --> [clave].
nombre(n(debilidad)) --> [debilidad].
nombre(n(tambores)) --> [tambores].
nombre(n(maquina)) --> [maquina].
nombre(n(trabajos)) --> [trabajos].
nombre(n(teoria)) --> [teoria].
nombre(n(importancia)) --> [importancia].
nombre(n(transposicion)) --> [transposicion].
nombre(n(elementos)) --> [elementos].
nombre(n(mecanismo)) --> [mecanismo].
nombre(n(tira)) --> [tira].
nombre(n(baston)) --> [baston].
nombre(n(funcion)) --> [funcion].
nombre(n(fuentes)) --> [fuentes].
nombre(n(salida)) --> [salida].
nombre(n(cesar)) --> [cesar].
nombre(n(secreto)) --> [secreto].
nombre(n(proceso)) --> [proceso].
nombre(n(caracteristicas)) --> [caracteristicas].
nombre(n(red)) --> [red].
nombre(n(politica)) --> [politica].
nombre(n(experto)) --> [experto].
nombre(n(moral)) --> [moral].
nombre(n(diccionario)) --> [diccionario].
nombre(n(peligro)) --> [peligro].
nombre(n(peligros)) --> [peligros].
nombre(n(estrategia)) --> [estrategia].
nombre(n(leyendas)) --> [leyendas].
nombre(n(ventajas)) --> [ventajas].
nombre(n(atacante)) --> [atacante].
nombre(n(sistema)) --> [sistema].
nombre(n(resumen)) --> [resumen].

verbo(v(presenta)) --> [presenta].
verbo(v(presentan)) --> [presentan].
verbo(v(acompana)) --> [acompana].
verbo(v(compromete)) --> [compromete].
verbo(v(pierde)) --> [pierde].
verbo(v(determina)) --> [determina].
verbo(v(evita)) --> [evita].
verbo(v(calcula)) --> [calcula].
verbo(v(contiene)) --> [contiene].
verbo(v(es)) --> [es].
verbo(v(son)) --> [son].
verbo(v(cifran)) --> [cifran].
verbo(v(posee)) --> [posee].
verbo(v(copia)) --> [copia].
verbo(v(aparece)) --> [aparece].
verbo(v(escribe)) --> [escribe].
verbo(v(lee)) --> [lee].
verbo(v(vigila)) --> [vigila].
verbo(v(cumple)) --> [cumple].
verbo(v(aumenta)) --> [aumenta].
verbo(v(disminuye)) --> [disminuye].
verbo(v(codifican)) --> [codifican].
verbo(v(inician)) --> [inician].
verbo(v(constituyen)) --> [constituyen].
verbo(v(apoyan)) --> [apoyan].
verbo(v(tienen)) --> [tienen].
verbo(v(cambia)) --> [cambia].
verbo(v(rodea)) --> [rodea].
verbo(v(esconde)) --> [esconde].
verbo(v(mezcla)) --> [mezcla].
verbo(v(produce)) --> [produce].
verbo(v(empleaba)) --> [empleaba].
verbo(v(protege)) --> [protege].
verbo(v(oculta)) --> [oculta].
verbo(v(modifica)) --> [modifica].
verbo(v(analiza)) --> [analiza].
verbo(v(genera)) --> [genera].
verbo(v(alcanza)) --> [alcanza].
verbo(v(suscita)) --> [suscita].
verbo(v(desliga)) --> [desliga].
verbo(v(ataca)) --> [ataca].
verbo(v(aplica)) --> [aplica].
verbo(v(conoce)) --> [conoce].
verbo(v(evalua)) --> [evalua].
verbo(v(publica)) --> [publica].
verbo(v(rompe)) --> [rompe].

adjetivo(adj(constante)) --> [constante].
adjetivo(adj(ocho)) --> [ocho].

adverbio(adv(bien)) --> [bien].

preposicion(prep(a)) --> [a].
preposicion(prep(de)) --> [de].
preposicion(prep(en)) --> [en].

conjuncion(conj(y)) --> [y].
conjuncion(conj(pero)) --> [pero].
conjuncion(conj(o)) --> [o].

% -----------------------------------------------------------------------------
% 5. CORPUS DE ORACIONES (Fase 1 completada)
% -----------------------------------------------------------------------------

lista_oraciones([
    % --- 10 Oraciones Simples (o) ---
    [el, libro, presenta, una, evolucion, constante],
    [la, criptografia, acompana, a, las, computadoras],
    [el, criptoanalisis, compromete, la, seguridad],
    [el, canal, pierde, la, seguridad],
    [la, probabilidad, determina, la, informacion],
    [la, esteganografia, evita, la, censura],
    [euclides, calcula, la, inversa],
    [la, contrasena, contiene, ocho, letras],
    [el, espectro, es, el, rango],
    [los, algoritmos, cifran, los, bloques],

    % --- 6 Oraciones Coordinadas (oc) ---
    [la, informacion, posee, un, tiempo, y, el, dato, pierde, el, valor],
    [el, destinatario, copia, las, letras, y, el, mensaje, aparece],
    [el, usuario, escribe, el, texto, y, el, receptor, lee, el, mensaje],
    [el, gobierno, vigila, las, vidas, y, el, ciudadano, pierde, la, libertad],
    [la, suma, cumple, la, propiedad, y, el, elemento, posee, la, simetria],
    [la, certeza, aumenta, la, informacion, y, el, suceso, disminuye, la, incertidumbre],

    % --- 8 Oraciones Subordinadas de Relativo (or) ---
    [las, claves, que, codifican, los, mensajes, presentan, una, debilidad],
    [los, tambores, que, inician, la, maquina, constituyen, la, clave],
    [los, trabajos, que, apoyan, la, teoria, tienen, una, importancia],
    [la, transposicion, que, cambia, los, elementos, es, un, mecanismo],
    [la, tira, que, rodea, el, baston, esconde, el, texto],
    [la, funcion, que, mezcla, las, fuentes, produce, una, salida],
    [el, algoritmo, que, empleaba, cesar, protege, el, secreto],
    [el, proceso, que, oculta, la, informacion, modifica, el, mensaje],

    % --- 6 Oraciones Compuestas (ocm - Relativa + Coordinada) ---
    [el, atacante, analiza, el, mensaje, que, oculta, la, informacion, ',', y, el, sistema, protege, el, secreto],
    [la, funcion, que, genera, el, resumen, cumple, las, caracteristicas, ',', y, la, red, alcanza, la, seguridad],
    [la, criptografia, que, suscita, la, politica, protege, el, sistema, ',', pero, el, experto, desliga, la, moral],
    [el, diccionario, que, ataca, las, contrasenas, es, un, peligro, ',', y, el, usuario, aplica, la, estrategia],
    [el, ciudadano, que, conoce, las, leyendas, evalua, los, peligros, ',', y, el, gobierno, publica, las, ventajas],
    [la, contrasena, que, aparece, en, el, diccionario, aumenta, la, probabilidad, ',', y, el, atacante, rompe, el, sistema]
]).