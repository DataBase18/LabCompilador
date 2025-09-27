# 🧠 Compilador Básico en Flutter

Este es un proyecto universitario desarrollado como parte del curso de compiladores. Implementa un compilador básico desde cero utilizando **Flutter** y **Dart** con compilación de escritorio, sin librerías externas. El objetivo fue aplicar los fundamentos teóricos de análisis sintáctico y construcción de lenguajes en una interfaz funcional y educativa.

## 🎯 Funcionalidades principales

- 📜 **Análisis sintáctico predictivo**  
  Implementación de un parser basado en gramáticas libres de contexto, con manejo de símbolos terminales y no terminales.

- 🔍 **Funciones Primera y Segunda**  
  Cálculo de conjuntos *First* y *Follow* para cada símbolo de la gramática, esenciales para la construcción del analizador.

- 🧩 **Matriz de análisis**  
  Generación de la tabla de parsing para guiar el análisis sintáctico descendente.

- 🌀 **Manejo de epsilon (ε)**  
  Soporte para producciones vacías y su impacto en los conjuntos y la matriz.

- 🔄 **Transformación de gramáticas recursivas por la izquierda**  
  Identificación y reescritura de producciones con recursividad izquierda para permitir el análisis predictivo.

- 🖥️ **Interfaz visual en Flutter**  
  Permite ingresar gramáticas, visualizar los conjuntos calculados, transformar producciones y simular el análisis de cadenas.

## 🛠️ Tecnologías utilizadas

- [Flutter](https://flutter.dev/) — Framework para UI multiplataforma (Pero orientado escritorio en este proyecto)  
- [Dart](https://dart.dev/) — Lenguaje de programación  
- Sin librerías externas: todo el análisis fue implementado manualmente


## 📦 Instalación

```bash
git clone https://github.com/DataBase18/LabCompilador.git
cd LabCompilador
flutter pub get
flutter run
