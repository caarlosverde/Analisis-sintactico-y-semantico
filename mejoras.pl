% =============================================================================
% ARCHIVO: mejoras.pl
% CONTENIDO: Implementacion de Mejoras (Tokenizacion, Roles, HTML Interactivo)
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
mostrar_funciones(Arbol) :- extraer(Arbol).

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

% -----------------------------------------------------------------------------
% MEJORA 5: VISUALIZACION EN HTML INTERACTIVO (Modo Oscuro + Esquinas Cuadradas)
% -----------------------------------------------------------------------------
:- dynamic contador_nodos/1.
:- dynamic nodo_hoja/3. % Almacena ID, Categoria y Palabra para el JS

nuevo_id(ID) :- retract(contador_nodos(N)), ID is N + 1, assertz(contador_nodos(ID)).

reiniciar_estado :-
    retractall(contador_nodos(_)), retractall(nodo_hoja(_,_,_)),
    assertz(contador_nodos(0)).

generar_html(Arbol) :-
    reiniciar_estado,
    open('arbol_interactivo.html', write, Stream),
    
    % --- 1. CABECERA Y CONFIGURACION (securityLevel: "loose" DESBLOQUEA LOS CLICS) ---
    write(Stream, '<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><title>AST Interactivo</title>'), nl(Stream),
    write(Stream, '<script type="module">'), nl(Stream),
    write(Stream, 'import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.esm.min.mjs";'), nl(Stream),
    write(Stream, 'mermaid.initialize({ startOnLoad: true, theme: "dark", securityLevel: "loose", flowchart: { curve: "step" } });'), nl(Stream),
    write(Stream, '</script>'), nl(Stream),
    
    % --- 2. ESTILOS CSS ---
    write(Stream, '<style>'), nl(Stream),
    write(Stream, 'body { font-family: "Segoe UI", sans-serif; background-color: #0f172a; color: #f8fafc; text-align: center; margin: 0; padding: 40px; }'), nl(Stream),
    write(Stream, 'h2 { background: linear-gradient(90deg, #38bdf8, #818cf8); -webkit-background-clip: text; -webkit-text-fill-color: transparent; font-size: 2.5em; margin-bottom: 5px; }'), nl(Stream),
    write(Stream, '.mermaid { background: #1e293b; padding: 40px; border-radius: 16px; border: 1px solid #334155; margin: 20px auto; max-width: 95%; overflow-x: auto; }'), nl(Stream),
    write(Stream, '#modal { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.8); z-index:1000; justify-content:center; align-items:center; }'), nl(Stream),
    write(Stream, '.modal-caja { background:#1e293b; padding:40px; border-radius:15px; border: 1px solid #3b82f6; box-shadow: 0 0 30px rgba(59,130,246,0.4); min-width: 350px; }'), nl(Stream),
    write(Stream, 'button:hover { transform: scale(1.05); }'), nl(Stream),
    write(Stream, '</style></head><body>'), nl(Stream),
    
    % --- 3. MAQUETACION HTML Y VENTANA EMERGENTE ---
    write(Stream, '<h2>Árbol Sintáctico Profesional (AST)</h2>'), nl(Stream),
    write(Stream, '<p style="color:#94a3b8; font-style:italic;">Haz clic en cualquier palabra final (verde) para ver sus propiedades lógicas.</p>'), nl(Stream),
    
    write(Stream, '<div id="modal">'), nl(Stream),
    write(Stream, '  <div class="modal-caja">'), nl(Stream),
    write(Stream, '    <h1 id="m-palabra" style="color:#38bdf8; font-size:3em; text-transform:uppercase; margin:0;"></h1>'), nl(Stream),
    write(Stream, '    <p id="m-cat" style="color:#e2e8f0; font-size:1.5em; background:#0f172a; padding:15px; border-radius:8px; font-family:monospace;"></p>'), nl(Stream),
    write(Stream, '    <button onclick="document.getElementById(\'modal\').style.display=\'none\'" style="margin-top:20px; padding:12px 30px; font-size:1.2em; background:#3b82f6; color:#fff; border:none; border-radius:8px; cursor:pointer;">CERRAR</button>'), nl(Stream),
    write(Stream, '  </div></div>'), nl(Stream),

    % --- 4. INICIO DEL GRAFO MERMAID ---
    write(Stream, '<div class="mermaid">'), nl(Stream),
    write(Stream, 'flowchart TD'), nl(Stream),
    write(Stream, '    classDef raiz fill:#6d28d9,stroke:#8b5cf6,stroke-width:3px,color:#fff,rx:8,ry:8;'), nl(Stream),
    write(Stream, '    classDef grupo fill:#1e40af,stroke:#3b82f6,stroke-width:2px,color:#fff,rx:5,ry:5;'), nl(Stream),
    write(Stream, '    classDef hoja fill:#065f46,stroke:#10b981,stroke-width:3px,color:#fff,cursor:pointer;'), nl(Stream),
    
    recorrer_para_html(Arbol, 0, Stream),
    escribir_alineacion_y_eventos(Stream),
    
    write(Stream, '</div>'), nl(Stream),
    
    % --- 5. SCRIPT JAVASCRIPT GLOBAL ---
    write(Stream, '<script>'), nl(Stream),
    write(Stream, '  const diccNodos = {'), nl(Stream),
    escribir_diccionario_js(Stream),
    write(Stream, '  };'), nl(Stream),
    write(Stream, '  window.mostrarInfo = function(idNodo) {'), nl(Stream),  % <--- LA CLAVE ESTÁ AQUÍ (window)
    write(Stream, '    let datos = diccNodos[idNodo];'), nl(Stream),
    write(Stream, '    if(datos) {'), nl(Stream),
    write(Stream, '      document.getElementById("m-palabra").innerText = datos.palabra;'), nl(Stream),
    write(Stream, '      document.getElementById("m-cat").innerText = "Categoría: [" + datos.cat + "]";'), nl(Stream),
    write(Stream, '      document.getElementById("modal").style.display = "flex";'), nl(Stream),
    write(Stream, '    }'), nl(Stream),
    write(Stream, '  };'), nl(Stream),
    write(Stream, '</script>'), nl(Stream),
    write(Stream, '</body></html>'), nl(Stream),
    close(Stream),
    write('  [OK] Archivo HTML interactivo generado con exito.'), nl.

% --- LOGICA RECURSIVA PARA DIBUJAR ---
recorrer_para_html(Nodo, IDPadre, Stream) :-
    Nodo =.. [Functor | Hijos], nuevo_id(MiID),
    ( Hijos = [Hoja], atomic(Hoja) ->
        write(Stream, '    node'), write(Stream, MiID), write(Stream, '(["<b>['), write(Stream, Functor), write(Stream, ']</b><br><i>'), write(Stream, Hoja), write(Stream, '</i>"])'), nl(Stream),
        write(Stream, '    class node'), write(Stream, MiID), write(Stream, ' hoja;'), nl(Stream),
        assertz(nodo_hoja(MiID, Functor, Hoja)) % Guardamos para el clic
    ;
        ( IDPadre == 0 -> Clase = 'raiz' ; Clase = 'grupo' ),
        write(Stream, '    node'), write(Stream, MiID), write(Stream, '["<b>['), write(Stream, Functor), write(Stream, ']</b>"]'), nl(Stream),
        write(Stream, '    class node'), write(Stream, MiID), write(Stream, ' '), write(Stream, Clase), write(Stream, ';'), nl(Stream),
        recorrer_hijos(Hijos, MiID, Stream)
    ),
    ( IDPadre \== 0 -> write(Stream, '    node'), write(Stream, IDPadre), write(Stream, ' ==> node'), write(Stream, MiID), nl(Stream) ; true ).

recorrer_hijos([], _, _).
recorrer_hijos([H|T], IDPadre, Stream) :- recorrer_para_html(H, IDPadre, Stream), recorrer_hijos(T, IDPadre, Stream).

% --- ALINEAR AL MISMO NIVEL Y CREAR EVENTOS ---
escribir_alineacion_y_eventos(Stream) :-
    findall([ID, Cat, Pal], nodo_hoja(ID, Cat, Pal), Lista),
    ( Lista \= [] ->
        write(Stream, '    %% Forzar mismo nivel'), nl(Stream),
        write(Stream, '    subgraph Base [ ]'), nl(Stream),
        write(Stream, '    style Base fill:none,stroke:none;'), nl(Stream),
        escribir_nodos_base(Stream, Lista),
        write(Stream, '    end'), nl(Stream),
        write(Stream, '    %% Eventos Click'), nl(Stream),
        escribir_eventos_click(Stream, Lista)
    ; true ).

escribir_nodos_base(_, []).
escribir_nodos_base(Stream, [[ID,_,_]|T]) :- write(Stream, '    node'), write(Stream, ID), nl(Stream), escribir_nodos_base(Stream, T).

escribir_eventos_click(_, []).
escribir_eventos_click(Stream, [[ID,_,_]|T]) :- 
    write(Stream, '    click node'), write(Stream, ID), write(Stream, ' mostrarInfo "Ver propiedades"'), nl(Stream), 
    escribir_eventos_click(Stream, T).

% --- DICCIONARIO PARA JAVASCRIPT ---
escribir_diccionario_js(Stream) :-
    findall([ID, Cat, Pal], nodo_hoja(ID, Cat, Pal), Lista),
    escribir_lineas_js(Stream, Lista).

escribir_lineas_js(_, []).
escribir_lineas_js(Stream, [[ID, Cat, Pal]|T]) :-
    write(Stream, '    "node'), write(Stream, ID), write(Stream, '": { cat: "'), write(Stream, Cat), write(Stream, '", palabra: "'), write(Stream, Pal), write(Stream, '" },'), nl(Stream),
    escribir_lineas_js(Stream, T).