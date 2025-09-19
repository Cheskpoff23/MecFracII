# Documentación LaTeX para Mecánica de la Fractura II

Este repositorio contiene la documentación en LaTeX para el curso de Mecánica de la Fractura II, siguiendo las normas APA 7ma Edición.

## Archivos incluidos

- `MecFracII.tex`: Documento principal en LaTeX con estructura APA
- `MecFracII.bib`: Archivo de bibliografía con referencias relevantes
- `README_LaTeX.md`: Este archivo de documentación

## Estructura del documento

El documento `MecFracII.tex` incluye las siguientes secciones según normas APA:

1. **Portada (Title Page)**: Información del documento, autor, institución y fecha
2. **Tabla de Contenido (Table of Contents)**: Índice automático generado por LaTeX
3. **Introducción**: Presentación del tema y objetivos
4. **Desarrollo/Cuerpo**: 
   - Fundamentos Teóricos de la Mecánica de la Fractura
   - Técnicas Experimentales y Numéricas
   - Aplicaciones en Ingeniería
5. **Conclusión**: Síntesis y reflexiones finales
6. **Bibliografía**: Referencias en formato APA usando BibLaTeX

## Compilación

Para compilar el documento, se requiere una distribución de LaTeX con los siguientes paquetes:

### Paquetes LaTeX necesarios
- `babel` (español)
- `biblatex` con estilo APA
- `biber` (backend de bibliografía)
- `geometry` (márgenes)
- `setspace` (espaciado doble)  
- `times` (fuente Times New Roman)
- `fancyhdr` (encabezados)
- `amsmath`, `amsfonts` (matemáticas)
- `graphicx`, `float`, `caption` (figuras)

### Comandos de compilación
```bash
pdflatex MecFracII.tex
biber MecFracII
pdflatex MecFracII.tex
pdflatex MecFracII.tex
```

## Contenido académico

El documento cubre conceptos avanzados de mecánica de la fractura incluyendo:

- Criterios de fractura avanzados
- Mecánica de la fractura elastoplástica
- Integral J de Rice
- Ley de Paris para fatiga
- Técnicas experimentales modernas (DIC, ensayos ASTM)
- Métodos numéricos (MEF, XFEM)
- Aplicaciones en industrias aeroespacial, civil y petroquímica

## Bibliografía

El archivo `MecFracII.bib` contiene 20 referencias académicas relevantes, incluyendo:

- Libros de texto fundamentales (Anderson, Broek, Suresh)
- Artículos científicos clásicos (Griffith, Rice, Paris)
- Normas ASTM actualizadas
- Publicaciones sobre métodos numéricos modernos

## Personalización

Para personalizar el documento:

1. Editar la portada con información específica del autor/institución
2. Agregar o modificar contenido en las secciones principales
3. Incluir figuras en formato compatible con LaTeX
4. Agregar referencias adicionales al archivo .bib
5. Ajustar el formato según requerimientos específicos

El documento está diseñado para ser fácilmente modificable y extensible según las necesidades específicas del curso o proyecto.