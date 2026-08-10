<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:2E0212,40:4A041E,70:730A31,100:A6174A&height=210&section=header&text=RUN%20TECATILLO%20RUN&fontSize=52&fontColor=FFFFFF&fontAlignY=36&desc=Endless%20runner%20en%20Godot%20%7C%20PIXELBITS%20Studio&descSize=18&descAlignY=58&descColor=F2B8C6&animation=fadeIn" width="100%"/>

![Godot](https://img.shields.io/badge/Godot-4.5-730A31?style=for-the-badge&logo=godotengine&logoColor=white&labelColor=2E0212)
![GDScript](https://img.shields.io/badge/GDScript-100%25-730A31?style=for-the-badge&logo=godotengine&logoColor=white&labelColor=2E0212)
![Version](https://img.shields.io/badge/Versión-2.0-730A31?style=for-the-badge&labelColor=2E0212)
![Estado](https://img.shields.io/badge/Estado-En%20desarrollo-730A31?style=for-the-badge&labelColor=2E0212)
![Platform](https://img.shields.io/badge/Plataforma-Windows%20%7C%20GL-730A31?style=for-the-badge&logo=windows&logoColor=white&labelColor=2E0212)
</div>

---

**RUN TECATILLO RUN** nació como proyecto escolar para demostrar conocimientos de programación visual, y hoy sigue creciendo como un juego completo: esquiva obstáculos, recoge coleccionables, sortea elementos voladores y compite por el mejor lugar en el marcador global, todo mientras Tecatillo corre sin parar.

> ⚠️ **Este repositorio contiene únicamente la lógica del proyecto** (scripts `.gd`, escenas `.tscn` y configuración de Godot). La carpeta `assets/` (imágenes, animaciones, audio y fuentes) **no está incluida** porque supera los límites cómodos de GitHub para un repositorio normal — ronda los **~210 MB**, con varios `.mp3`/`.wav` de más de 10 MB cada uno. Más abajo se explica exactamente qué debes reconstruir para que el proyecto corra.

---

## 🆕 Novedades de la Versión 2

Esta segunda versión reescribe buena parte del juego alrededor de **dos nuevos autoloads** (`Localization` y `SaveManager`) que centralizan todo lo configurable. Esto es lo nuevo:

### 🌐 Idioma dinámico (Opciones → General)
- Todos los textos de la interfaz (menús, HUD, marcador, mensajes de fin de partida) viven en un diccionario bilingüe **Español / English** dentro de `autoload/localization.gd`.
- El idioma elegido se guarda en `user://settings.json` y se recuerda entre sesiones.
- El cambio es **en caliente**: las pantallas ya abiertas se refrescan solas gracias a la señal `language_changed`, sin necesidad de reiniciar la escena.

### 🎁 Sistema de coleccionables configurable
- El jugador puede **activar o desactivar** cada coleccionable individualmente desde Opciones (moneda, Tecatillo, pizza, colmillos, logos de PIXELBITS y más).
- Se pueden **agregar imágenes propias** como coleccionables vía `FileDialog`; se importan y se guardan en `user://custom_collectibles`, persistentes entre partidas.
- La **frecuencia de aparición** es ajustable con un slider (de una cada 2 segundos a dos por segundo), medida en tiempo real y no en distancia recorrida, para que no se dispare cuando el juego va rápido.
- Los coleccionables se **auto-escalan** a un tamaño de referencia (44×43, el de la moneda original) sin importar la resolución de la imagen que subas, con filtrado lineal + mipmaps para evitar parpadeos.
- Por rendimiento, las instancias se **reciclan (pooling)** en vez de crearse y destruirse en cada aparición.

### 🛸 Elementos voladores con dificultad ajustable
- Nueva pestaña **"Elementos Voladores"** en Opciones, con un slider de **6 niveles (0 a 5)**:
  - Niveles 0-1: desactivados por completo.
  - Nivel 2: comportamiento clásico (factor 1.0x).
  - Nivel 5: máxima dificultad (factor 2.5x velocidad/frecuencia).
- A mayor nivel, además de ir más rápido, aparecen **más elementos por oleada** y con **mayor variación de velocidad** entre ellos.
- Igual que los coleccionables, admite imágenes propias y activar/desactivar cada elemento built-in (OVNI, dron, ESP32, Arduino Nano, etc.).

### 🏆 Marcador global (récord) y función de compartir
- Cada partida guarda nombre, carrera seleccionada, puntaje, coleccionables recogidos, nivel de dificultad voladora, fecha y hora — hasta **50 registros**, ordenados por puntaje.
- Nueva pantalla **Marcador Global** con la lista completa.
- **Compartir resultados** directo desde el juego:
  - Por **WhatsApp** o **Email**, ya sea un solo resultado o el Top 10 completo.
  - Los mensajes incluyen automáticamente una firma de PIXELBITS Studio con enlaces a redes.
- Reinicio del marcador protegido por contraseña (uso administrativo interno).

### ⚙️ Otras mejoras generales
- **Volumen** limitado a un máximo del 10% (a petición del propio equipo, para no reventar oídos) con botón de silencio.
- **Pantalla completa** activable desde Opciones.
- Reproductor de música (`MusicGrl.gd`) con playlist dinámica: escanea `assets/audio` en tiempo de ejecución, mezcla las canciones sin repetir la anterior, con intro y outro dedicados.
- Todo el guardado (`settings.json`, `leaderboard.json`, imágenes personalizadas) vive en `user://`, fuera del proyecto, para sobrevivir a reinstalaciones del build.
- Utilidades visuales compartidas (`scripts/game_utils.gd`) para que listas generadas por código (Opciones, marcador) mantengan el mismo estilo del resto de la interfaz.

---

> 🔎 Si al clonar el repositorio no ves las carpetas `autoload/` o `scripts/`, o la pantalla `leaderboard.gd/.tscn`, significa que ese push todavía no incluye la lógica de la V2 descrita arriba — pidelas al administrador antes de continuar, son las que activan idioma, marcador y coleccionables.

---

## ✅ Qué debes completar tú (obligatorio para poder correr el proyecto)

Lo único que falta para que Godot abra el proyecto sin errores de "recurso no encontrado" es reconstruir la carpeta **`assets/`** en la raíz, con exactamente estos nombres de subcarpeta (el código los usa como rutas fijas):

| Carpeta | Contenido esperado | Usada por |
|---|---|---|
| `assets/` (raíz) | Sprites del personaje, fondos (`clouds_1..4.png`), UI, ícono (`tecatillofacecuadro.png`), fuente `Cyberfall Italic.otf`, `stelar parallax.jpg`, etc. | Escenas de menú, HUD, personaje |
| `assets/audio/` | Todas las pistas `.mp3`/`.wav` de la playlist + `juegoIntroMaster.wav` y `juegoSalirMaster.wav` (nombres exactos, son rutas fijas en `MusicGrl.gd`) | `MusicGrl.gd` (escanea la carpeta completa en tiempo real) |
| `assets/coleccionables/` | PNGs de coleccionables (ej. `coin.png`, `Tecatillo.png`, `pizza.png`, `colmillosFA23.png`, `gardenEngineering.png`, `greenchLabs.png`, `uptRock.png`, `PIXELBITS.png`) | `SaveManager.BUILTIN_COLLECTIBLES_DIR` |
| `assets/elementosVoladores/` | PNGs de elementos voladores (ej. `ufo.png`, `ufo2.png`, `ovoide.png`, `flyuptID.png`, `esp32.png`, `nano.png`) | `SaveManager.BUILTIN_FLYING_DIR` |
| `assets/particulas/` | PNGs usados como partículas del jugador (ej. `IS.png`, `PBSblanco.png`) | `SaveManager.BUILTIN_PARTICLES_DIR`, `player.gd` |

**Detalles importantes al reconstruirla:**

1. **Los nombres deben coincidir exactamente** (mayúsculas incluidas) con los que usan los scripts. `save_manager.gd` trae además una lista de respaldo (`BUILTIN_MANIFESTS`) para cuando el build exportado no puede listar carpetas dinámicamente — si agregas o quitas un PNG de `coleccionables/` o `elementosVoladores/`, actualiza también ese diccionario.
2. `assets/audio/` se escanea completa como playlist en tiempo real: cualquier `.mp3` que agregues ahí entra automáticamente a la rotación (excepto `pressButton.mp3`, que está reservado a efectos de UI).
3. El ícono del proyecto (`config/icon` en `project.godot`) apunta a `res://assets/tecatillofacecuadro.png` — sin ese archivo, Godot mostrará una advertencia al abrir el proyecto (no es bloqueante, pero conviene tenerlo).
4. No hace falta subir los archivos `.import` a mano: Godot los regenera automáticamente la primera vez que abre el proyecto y detecta assets sin importar.

---

## ▶️ Cómo ejecutar el proyecto

1. Instala **[Godot Engine 4.5](https://godotengine.org/download)** (el proyecto usa el perfil `GL Compatibility`, corre bien incluso en equipos modestos).
2. Clona este repositorio.
3. Copia tu carpeta `assets/` completa (ver estructura de arriba) dentro de la raíz del proyecto clonado.
4. Abre Godot → **Import** → selecciona la carpeta del proyecto (donde está `project.godot`).
5. Deja que Godot termine de importar los assets nuevos (barra de progreso en la esquina inferior).
6. Presiona **F5** o el botón ▶️ para correr — la escena de inicio es `scenes/inicioymenus/inicio_1.tscn`.

### Autoloads requeridos (ya vienen configurados en `project.godot`, no los borres)

| Nombre | Script/Escena |
|---|---|
| `MusicGrl` | `res://scenes/inicioymenus/music_grl.tscn` |
| `SaveManager` | `res://autoload/save_manager.gd` |
| `Localization` | `res://autoload/localization.gd` |

---

## 🤝 Créditos

Desarrollado por **PIXELBITS Studio**, como proyecto de evidencia en programación visual — con el acompañamiento , paciencia y las pruebas de calidad certificadas por el Perrugu. 🐾

Síguenos para más actualizaciones del proyecto:

- 🐙 GitHub: [github.com/Pacheco55](https://github.com/Pacheco55)
- 🎥 Twitch: [twitch.tv/pixelbits_studio](https://www.twitch.tv/pixelbits_studio/about)

---

<div align="center">

*¡Vamos Colmillo, tú puedes con eso y mucho más!* 🏃💨




.........por cierto , esto lo subo a la fecha que estoy a 2 semanas de acabar con mi ciclo escolarizado de 9no cuatrimestre y prácticamente haber terminado la carrera en INGENIERIA de SOFTWARE , en los archivos es solo la lógica y backend de aquella primera versión de programación visual del 2024 , mas en el README.md únicamente la propuesta y multimedia de la versión 2 mejorada después de 2 años de carrera e implementacion de tecnologias diseñadas para trabajar con GODOT internamente con herramientas nativas y algunas modificadas para mi workflow .

GRACIAS COMUNIDAD UPT !

</div>
