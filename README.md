# PRO202 · Actividad sumativa de la semana 9

Proyecto académico individual de AIEP, del módulo **Taller de Bases de Datos (PRO202), unidad 2**.

**Estudiante:** Blas Pinto  
**Profesor:** Marcelo Trigo

La actividad consiste en automatizar las altas y bajas de productos de una empresa que vende artículos electrónicos y guardar los movimientos en una tabla de auditoría. Este repositorio reúne el código SQL, el informe y las evidencias reales de ejecución. Es un trabajo de estudiante.

## Solución

- Tablas `Productos` y `AuditoriaInventario`.
- Procedimientos `sp_AltaProducto` y `sp_BajaProducto`, con parámetros, validaciones y manejo de excepciones.
- Triggers `AFTER INSERT` y `AFTER DELETE` para registrar acciones INS y DEL por cada fila afectada.
- Ampliación según los aspectos de la rúbrica: validación con `INSTEAD OF UPDATE`, auditoría condicional `AFTER UPDATE` y demostración de cursor `LOCAL FAST_FORWARD`.

SQL Server no ofrece triggers BEFORE de este tipo. El informe explica la adaptación mediante INSTEAD OF; no la presenta como un trigger BEFORE.

## Archivos

| Carpeta | Contenido |
| --- | --- |
| [sql](sql) | Implementación del caso y ampliación para la rúbrica |
| [informe](informe) | Informe editable y PDF en la plantilla de entrega |
| [evidencias](evidencias) | Índice, capturas originales y resultados completos |

## Cómo ejecutar la implementación

Se utilizó SQL Server 2022 Express LocalDB, versión 16.0.1000.6, en Windows. También puede utilizarse una instancia compatible de SQL Server con permisos para crear los objetos.

1. Crear una base nueva y vacía, destinada exclusivamente a las pruebas.
2. Seleccionar esa base en el editor SQL.
3. Ejecutar `sql/01_Implementacion.sql` completo, respetando los separadores GO.
4. Ejecutar `sql/02_Ampliacion_rubrica.sql` completo.
5. Consultar los ejemplos y la matriz de pruebas del informe. El registro completo conserva las consultas y los resultados de la ejecución documentada.

Los scripts crean objetos; no deben repetirse sobre una base que ya los contenga. No se aporta aquí un ejecutor automático de la serie de pruebas.

## Pruebas y evidencias

Se probaron altas y bajas válidas, baja inexistente, valores nulos, vacíos y negativos, operaciones de varias filas, actualizaciones válidas, actualización sin cambios, rechazo de actualización inválida, cursor con datos y cursor vacío. Se consultaron las definiciones de los procedimientos y los triggers registrados.

El cierre de la serie ampliada confirmó **0 productos, 4 INS, 4 DEL y 2 UPD**. Una prueba de stock y precio cero fue revertida con ROLLBACK y no integra ese recuento. Los datos son ficticios; la ejecución y los resultados son reales.

Las imágenes son capturas de un visor local de registros obtenidos mediante .NET SqlClient; no son capturas de la interfaz de SQL Server Management Studio. Hay 35 conjuntos de evidencia, paginados en 57 capturas, además de una vista general. El informe reducido tiene 18 páginas e incorpora siete figuras principales, en ocho capturas, para facilitar la lectura. El código completo y todas las evidencias permanecen en este repositorio.

No se probaron todas las condiciones de concurrencia o fallos de infraestructura. La limpieza de recursos en el CATCH del cursor está implementada, pero no se provocó un fallo dentro de su recorrido.

## Fuentes y asistencia

El informe cita las orientaciones de la actividad y la documentación de Microsoft Learn sobre CREATE TRIGGER, TRY...CATCH y DECLARE CURSOR. Los originales de las instrucciones y de la plantilla se conservan en el proyecto local.

Se utilizó Codex para organizar requisitos, preparar código, ejecutar pruebas locales, capturar los resultados y apoyar la redacción y revisión. Esta asistencia también se declara en el informe. La autoría académica corresponde a Blas Pinto.

Como referencia para una coordinación futura, [claude-work-mcp](https://github.com/blaspinto5/claude-work-mcp) reúne herramientas MCP de archivos, notas compartidas Codex–Claude, APIs configuradas y comandos permitidos. Se propone que Claude planifique y analice errores, mientras Codex ejecute. No se registró uso de Claude o de ese servidor durante las pruebas documentadas.
