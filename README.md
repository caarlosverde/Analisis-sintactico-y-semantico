# Análisis sintáctico y semántico de oraciones en Prolog

Analizador de **procesamiento de lenguaje natural (PLN)** para español escrito en Prolog. Toma una frase, la tokeniza, construye su árbol sintáctico con una gramática DCG, extrae sujeto y predicado, descompone las oraciones compuestas en simples y detecta ambigüedades léxicas y metáforas. El dominio es la historia y la teoría de la criptografía.

## Pipeline

1. **Análisis léxico**: normaliza el texto y lo convierte en tokens.
2. **Análisis sintáctico (parsing)**: gramática DCG con oraciones simples, coordinadas y de relativo, grupos nominales, verbales, adjetivales y preposicionales. Dibuja el árbol en consola.
3. **Funciones sintácticas**: extrae sujeto, verbo y complementos de cada oración.
4. **Simplificación lógica**: separa las oraciones coordinadas y de relativo en estructuras simples.
5. **Revisión semántica**: usa una base de conocimiento de categorías (persona, institución, disciplina, concepto...) para detectar **ambigüedades léxicas** y **metáforas** (p. ej. un sujeto abstracto con un verbo de acción física).

Además genera un **árbol sintáctico interactivo en HTML** (`arbol_interactivo.html`) en el que se puede hacer clic en cada nodo para ver su categoría.

## Uso

Con [SWI-Prolog](https://www.swi-prolog.org/):

```prolog
?- [main].
?- analizar_texto("El atacante rompe la clave.").   % frase en lenguaje natural
?- test_oracion(12).                                 % oración nº 12 del corpus
```

## Estructura

| Archivo | Contenido |
| --- | --- |
| `main.pl` | Controlador del pipeline de 5 fases |
| `sintactico.pl` | Gramática DCG, simplificación y léxico |
| `semantico.pl` | Base de conocimiento semántico (categorías de palabras) |
| `deteccion.pl` | Detección de ambigüedades y metáforas |
| `mejoras.pl` | Tokenización, funciones sintácticas y exportación a HTML |
| `draw.pl` | Visualización del árbol en consola |
| `conjunto_oraciones.pl` | Corpus de 30 oraciones de prueba |
