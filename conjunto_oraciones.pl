% =============================================================================
% ARCHIVO: conjunto_oraciones.pl
% CONTENIDO: Corpus de 30 oraciones (Historia y Teoría de la Criptografía)
% =============================================================================

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