% =============================================================================
% PROYECTO: Analisis Sintactico y Semantico de Oraciones
% DOMINIO: Historia y Teoria de la Criptografia
% ARCHIVO: main.pl (Controlador Principal)
% =============================================================================

% --- CARGA DE MODULOS Y UTILIDADES ---
% Nota: Usamos include para asegurar la maxima compatibilidad de rutas.
:- consult(draw). 
:- include('conjunto_oraciones.pl').
:- include('sintactico.pl').
:- include('semantico.pl').
:- include('deteccion.pl'). 
:- include('mejoras.pl'). 

% -----------------------------------------------------------------------------
% PREDICADOS DE EJECUCION E INTERFAZ
% -----------------------------------------------------------------------------

% analizar/1: Predicado basico para analizar una lista de tokens directamente.
analizar(Oracion) :-
    oracion(Arbol, Oracion, []),
    draw(Arbol),
    mostrar_funciones(Arbol),
    simplificar(Arbol, Simples),
    write('Oraciones Simplificadas: '), write(Simples), nl.

% demostrar/1: Predicado principal que gestiona el Pipeline de las 5 Fases.
% Recibe una lista de atomos (ej. [el, canal, pierde, la, seguridad]).
demostrar(Oracion) :-
    write('================================================'), nl,
    write('  FASE 2: ANALISIS SINTACTICO (PARSING)         '), nl,
    write('================================================'), nl,
    (oracion(Arbol, Oracion, []) -> 
        write('  [OK] La oracion cumple las reglas gramaticales (DCG).'), nl,
        draw(Arbol), nl,
        
        % Mejora 5: Generacion del arbol interactivo en HTML
        generar_html(Arbol), nl,
        
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
        % Pasamos el Arbol para un analisis semantico estructural (evita falsos positivos)
        analisis_semantico(Arbol)
    ;   write('  [ERROR] La gramatica rechazo la oracion. Revisa el lexico.'), nl),
    write('\n================================================'), nl,
    write('                FIN DEL ANALISIS                '), nl,
    write('================================================'), nl.

% test_oracion/1: Permite probar oraciones del corpus (30 oraciones) por su numero.
test_oracion(N) :-
    lista_oraciones(L),
    nth1(N, L, Oracion),
    write('\nProbando oracion #'), write(N), write(': '), write(Oracion), nl,
    demostrar(Oracion).

% -----------------------------------------------------------------------------
% MODO DE USO SUGERIDO:
% 1. Para frases naturales: analizar_texto("El atacante rompe la clave.").
% 2. Para el corpus: test_oracion(12).
% -----------------------------------------------------------------------------