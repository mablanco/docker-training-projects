# Ejercicio 06

**Nivel:** Intermedio · **Conceptos:** espacios de nombres, `--pid host`

## Planteamiento

La monitorización siempre ha sido una de las tareas diarias más importantes de un administrador de sistemas, aunque a menudo se descuida. Gracias al movimiento DevOps, hoy recibe mucha más atención y se considera uno de los pilares básicos de cualquier infraestructura de TI.

Hay herramientas de monitorización de línea de comandos tan útiles que querrías tenerlas disponibles en todas las plataformas que gestionas. Sin embargo, los sistemas de TI son heterogéneos (servidores propios, instancias en la nube, dispositivos de red…), así que normalmente no es posible.

¡Docker al rescate! Docker funciona en muchas plataformas, así que puedes construir una imagen de monitorización con tus herramientas favoritas y ejecutarla donde la necesites.

En este ejercicio tienes que diseñar y construir una imagen que incluya varias herramientas de monitorización de la familia `*top`. Después, ejecuta un contenedor que, por defecto, lance `atop` en el espacio de nombres de PID del host, de modo que muestre los procesos del host y no solo los del contenedor.

## Entregables

Un Dockerfile para la imagen y un script de shell (`run.sh`) que construya la imagen y ejecute el contenedor.

## Cómo comprobar la solución

Ejecuta tu script. `atop` debería arrancar y mostrar los procesos del host (por ejemplo, el demonio de Docker o tus aplicaciones de escritorio), no solo el propio `atop`. Pulsa `q` para salir.

`sol/test.sh` lo comprueba automáticamente con la solución de referencia.
