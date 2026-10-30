# Proyectos de formación en Docker

Ejercicios prácticos para aprender Docker resolviendo problemas pequeños y realistas. Están pensados tanto para quien aprende Docker por su cuenta como para docentes que quieran ejercicios listos para sus cursos. Todo se publica bajo licencia GPLv3, así que puedes usarlo y adaptarlo libremente.

> **En proceso de actualización:** los ejercicios son de 2019 y se están poniendo al día, uno a uno, con las prácticas actuales de Docker. Los que llevan ✅ en el índice ya están actualizados y la CI los comprueba cada semana.

## Cómo se organiza cada ejercicio

Cada ejercicio está en un directorio numerado:

- `README.md`: el problema que hay que resolver, los entregables y cómo comprobar que la solución funciona.
- `src/` (opcional): ficheros de partida.
- `sol/`: una posible solución. Normalmente hay varias válidas, así que tómala como referencia, no como la única respuesta.
- `sol/test.sh`: un script que construye y ejecuta la solución y comprueba que funciona. La CI lo ejecuta en cada cambio.

El objetivo es encontrar una solución sencilla y que funcione para el problema tal y como se plantea. Recursos como los volúmenes o contenedores adicionales solo hacen falta si el problema los pide.

## Requisitos

- Docker Engine con el plugin de Compose (`docker compose`), o Docker Desktop.
- Bash, para ejecutar los scripts `run.sh` y `test.sh`.
- Conexión a internet, para descargar imágenes y paquetes.

## Para alumnos

1. Elige un ejercicio del índice. El nivel da una idea del orden, pero los ejercicios encadenados (02 → 03, 08 → 09 → 10) se apoyan unos en otros.
2. Lee su `README.md` e intenta resolverlo sin mirar `sol/`.
3. Comprueba tu solución con los pasos que indica el README del ejercicio.
4. Compárala con la de `sol/`. Si la tuya es distinta pero funciona, perfecto.

## Para docentes

- Cada ejercicio es independiente y se puede repartir tal cual: basta con dar al alumnado el `README.md` y el directorio `src/` del ejercicio.
- La columna de conceptos del índice ayuda a elegir ejercicios para los temas de cada sesión.
- `sol/test.sh` comprueba una solución automáticamente. Puedes adaptarlo para comprobar las soluciones de tus alumnos.
- Las sugerencias y los ejercicios nuevos son bienvenidos (consulta [Cómo contribuir](#cómo-contribuir)).

## Índice de ejercicios

| # | Ejercicio | Nivel | Conceptos | Actualizado |
|---|-----------|-------|-----------|-------------|
| [01](01) | Arreglar el build de una imagen con una instalación completa de WordPress | Básico | Dockerfile, interpretar errores de build | |
| [02](02) | Desplegar WordPress y MySQL en dos contenedores | Básico | Imágenes oficiales, redes, variables de entorno | |
| [03](03) | Orquestar el ejercicio 02 con Docker Compose | Básico | Docker Compose | |
| [04](04) | Desplegar un entorno de desarrollo y pruebas de Magento 2 (se sustituirá por Nextcloud) | Avanzado | Construir la imagen de una aplicación PHP compleja | |
| [05](05) | Desplegar un proxy inverso Nginx delante de dos servidores web con distintas versiones de PHP | Intermedio | Varias imágenes, redes, proxy inverso | |
| [06](06) | Construir una imagen de monitorización que ejecute `atop` en el espacio de nombres de PID del host | Intermedio | Espacios de nombres, `--pid host` | ✅ |
| [07](07) | Construir la imagen de un servidor web Apache con soporte de PHP | Básico | Dockerfile, volúmenes | |
| [08](08) | Construir la imagen de una aplicación Flask para un entorno de desarrollo | Básico | Imágenes de lenguajes, dependencias | |
| [09](09) | Desplegar en producción una aplicación CRUD basada en Flask y Vue.js con Docker Compose | Avanzado | Varias imágenes, servidores de producción, Docker Compose | |
| [10](10) | Probar los endpoints de la aplicación del ejercicio 09 (pasará de pyresttest a Hurl) | Intermedio | Imágenes de herramientas, pruebas de APIs | |
| [11](11) | Diseñar una imagen multi-stage que compile y ejecute una aplicación sencilla en Go | Intermedio | Builds multi-stage, imágenes mínimas | |

## Nota sobre seguridad

Para no desviar la atención del problema que se resuelve, las contraseñas y credenciales de estos ejercicios están escritas en claro.

No lo hagas nunca en producción ni en ningún entorno sensible. Usa en su lugar una solución de gestión de secretos, como los secretos de Docker, los secretos de build de BuildKit, HashiCorp Vault o el gestor de secretos de tu proveedor cloud.

## Cómo contribuir

Los ejercicios nuevos y las mejoras son bienvenidos. Para mantener la coherencia del repositorio:

1. Crea un directorio con el número siguiente al último que haya en el repositorio.
2. Añade un `README.md` con el problema, los entregables esperados y cómo comprobar la solución. Usa un ejercicio existente como plantilla.
3. Añade los ficheros de partida en `src/` y una solución que funcione en `sol/`.
4. Añade un script `sol/test.sh` que construya y ejecute la solución y falle si no funciona, y añade el ejercicio a la matriz de `.github/workflows/exercises.yml`.
5. Añade el ejercicio al índice de arriba, con tu nombre y un email o URL de contacto entre paréntesis.

Los Dockerfiles de las soluciones se validan con [hadolint](https://github.com/hadolint/hadolint) usando las reglas de `.hadolint.yaml`.

## Licencia

GPLv3
