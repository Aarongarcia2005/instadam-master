# InstaDAM 📸

> Una aplicación de red social multiplataforma construida con Flutter y SQLite.

---

## Descripción

InstaDAM es una red social local que permite a los usuarios compartir posts, interactuar con likes y comentarios, y gestionar su perfil personal. Toda la información se almacena localmente mediante SQLite, sin necesidad de conexión a internet ni servidor externo.

---

## Tecnologías utilizadas

| Tecnología | Versión | Uso |
|---|---|---|
| Flutter | ≥ 3.38.0 | Framework principal |
| Dart | ≥ 3.11.0 | Lenguaje |
| sqflite | 2.4.2 | Base de datos local |
| sqflite_common_ffi | 2.4.0 | Soporte desktop |
| sqflite_common_ffi_web | 0.4.5 | Soporte web |
| shared_preferences | 2.5.5 | Persistencia de sesión |

---

## Funcionalidades

- **Autenticación** — Login con usuario y contraseña
- **Feed** — Visualización del listado de posts de todos los usuarios
- **Posts** — Crear, ver y eliminar publicaciones
- **Likes** — Dar y quitar me gusta en posts
- **Comentarios** — Agregar comentarios a cualquier post
- **Perfil** — Ver información del usuario y sus posts propios
- **Configuración** — Ajustes y preferencias de la aplicación

---

## Estructura del proyecto

```
lib/
├── main.dart
├── database/
│   └── db_helper.dart          # Lógica SQLite: tablas, CRUD
├── models/
│   ├── user.dart               # Modelo de usuario
│   ├── post.dart               # Modelo de post
│   └── comment.dart            # Modelo de comentario
├── screens/
│   ├── login_screen.dart       # Pantalla de inicio de sesión
│   ├── feed_screen.dart        # Feed principal
│   ├── profile_screen.dart     # Perfil de usuario
│   ├── create_post_screen.dart # Creación de post
│   ├── comments_screen.dart    # Vista de comentarios
│   └── settings_screen.dart    # Configuración
├── services/
│   └── preferences_service.dart # Gestión de preferencias
└── widgets/
    ├── post_card.dart          # Tarjeta de post reutilizable
    ├── comment_tile.dart       # Item de comentario
    └── like_button.dart        # Botón de like animado
```

---

## Instalación y ejecución

### Requisitos previos

- Flutter SDK ≥ 3.38.0 instalado ([flutter.dev](https://flutter.dev))
- Dart incluido con Flutter

### Pasos

```bash
# 1. Acceder al directorio del proyecto
cd instadam

# 2. Instalar dependencias
flutter pub get

# 3. Ejecutar la aplicación
flutter run

# Para ejecutar en web específicamente
flutter run -d web

# Para ejecutar en Windows
flutter run -d windows
```

### Plataformas soportadas

Android · iOS · Web · Windows · macOS · Linux

---

## Base de datos

La app utiliza SQLite a través de `sqflite`, con soporte multiplataforma:

- **Android / iOS**: `sqflite` nativo
- **Windows / Linux / macOS**: `sqflite_common_ffi` vía FFI
- **Web**: `sqflite_common_ffi_web`

La inicialización se gestiona automáticamente en `db_helper.dart` según la plataforma detectada en tiempo de ejecución.

---

## ♿ Accesibilidad

InstaDAM ha sido diseñado para ser completamente usable con **TalkBack** (lector de pantalla de Android) y cumple los criterios de accesibilidad **WCAG 2.1 nivel AA**. Las mejoras se han implementado pantalla a pantalla a lo largo del desarrollo.

---

### Estándares aplicados

| Criterio | Requisito | Aplicación en InstaDAM |
|---|---|---|
| Contraste texto normal | 4,5:1 mínimo | Texto blanco `#FFFFFF` sobre degradado `#4F5BD5→#FEDA75` → ratio **5,54:1** ✅ |
| Contraste texto grande (≥ 18pt) | 3:1 mínimo | Cumplido en títulos y cabeceras ✅ |
| Contraste iconos informativos | 3:1 mínimo | Iconos de acción sobre fondo con contraste suficiente ✅ |
| Tamaño mínimo de toque | 48×48 dp | Todos los botones e iconos interactivos cumplen el mínimo Material Design ✅ |
| Separación entre elementos táctiles | 8 dp mínimo | Aplicado en toda la navegación ✅ |
| Color no es el único indicador | WCAG 1.4.1 | Estados comunicados con icono + texto, nunca solo color ✅ |
| Texto escalable | WCAG 1.4.4 | Sin ningún `textScaleFactor: 1.0` fijo en el código ✅ |

---

### Paleta de colores accesible

La paleta fue validada con herramienta de contraste WCAG antes de implementarla:

- **Fondo principal**: degradado `#4F5BD5` → `#FEDA75` (inspirado en Instagram)
- **Texto principal**: `#FFFFFF` — contraste 5,54:1 sobre el fondo → **WCAG AA Pass**
- **Elementos interactivos**: `#FFFFFF` — contraste máximo sobre el degradado

> El color nunca es el único medio para transmitir información. Los estados activo/inactivo se diferencian con **icono diferente + color**, garantizando accesibilidad para personas con daltonismo.

---

### Splash Screen

- TalkBack anuncia el estado de carga: *"Carregant aplicació..."* mediante `Semantics` con `liveRegion: true`.
- Sin animaciones que puedan causar crisis epilépticas (cumple WCAG 2.3.1).
- El texto de carga es blanco sobre fondo degradado con contraste suficiente.
- Gestiona la lógica de redirección: si hay sesión activa navega al feed; si no, al login.

---

### Login y Registro

**Problemas resueltos:**

| ❌ Problema original | ✅ Solución implementada |
|---|---|
| Placeholder como label (desaparece al escribir) | `labelText` persistente visible en todo momento fuera del `TextField` |
| Errores visuales sin anuncio auditivo | `errorText` + `liveRegion: true` para que TalkBack lo anuncie automáticamente |
| Sin gestión de foco | `Enter` pasa de email → contraseña con `FocusNode` encadenados |
| Botón sin descripción semántica | `Semantics(label: 'Iniciar sessió', button: true)` con tamaño mínimo 48dp |
| Switch "Recordar usuario" sin estado | `Semantics(toggled: bool, label: '...')` comunica el estado activo/inactivo |

**Regla de oro aplicada:** Si TalkBack anuncia "Botó" o "Switch" sin explicar la función → el formulario no es accesible.

---

### Feed y PostCard

- Cada post incluye un `Semantics` con label compuesto: autor, contenido (primeros 30 caracteres) y número de likes.
- El avatar decorativo está envuelto en `ExcludeSemantics` para evitar ruido semántico innecesario.
- El orden de lectura es lógico y predecible: avatar → autor → contenido → likes → comentarios.

---

### Likes

- El botón de like usa `Semantics` con `toggled: true/false` → TalkBack anuncia *"M'agrada, 5 likes, actiu"* o *"inactiu"*.
- `onTapHint` describe la acción inversa al estado actual: *"Treure like"* / *"Donar like"*.
- El estado se diferencia con **dos iconos distintos**: `Icons.favorite` (activo) y `Icons.favorite_border` (inactivo), nunca solo por color.
- Al dar o quitar like aparece un `SnackBar` marcado con `liveRegion: true` que TalkBack anuncia automáticamente sin que el usuario mueva el foco.

---

### Comentarios

- Cada comentario agrupa autor + texto + tiempo con `MergeSemantics` → TalkBack lo lee como una unidad coherente: *"blanco, fa 1 minut: Tercer post InstaDAM"*.
- El avatar circular (inicial decorativa) se excluye con `ExcludeSemantics`.
- El campo de texto usa `labelText: 'Escriu un comentari'` (etiqueta persistente, no solo `hintText`).
- El botón de enviar tiene `Semantics(label: 'Enviar comentari')` explícito.
- El nuevo comentario al añadirse se anuncia con `liveRegion: LiveRegionMode.polite`.
- Si la lista está vacía, TalkBack lee el mensaje *"No hi ha comentaris"*.

---

### Crear Post

- El selector de imagen anuncia su estado dinámicamente: *"Cap imatge seleccionada"* / *"Imatge seleccionada: foto.jpg"*.
- El campo descripción usa `labelText: 'Descripció *'` con indicación de obligatoriedad.
- Los errores de validación se anuncian automáticamente: `errorText` + `FocusNode.requestFocus()` mueve el foco al campo erróneo.
- El botón publicar cambia su label durante la carga: *"Publicar"* → *"Publicant..."*, y se deshabilita (`onPressed: null`) para evitar envíos dobles.
- Confirmación de publicación mediante `SnackBar` con `Semantics(liveRegion: true)`.
- Orden de foco lógico: Selector imagen → Descripción → Publicar.

---

### Perfil de Usuario

- La foto de perfil incluye `Semantics(image: true, label: 'Foto de perfil de [username]')`.
- Las estadísticas (posts, seguidores, siguiendo) se agrupan con `MergeSemantics` → se leen como frase completa: *"Estadístiques: 24 publicacions, 150 seguidors, 89 seguint"*.
- El botón "Editar perfil" cumple el mínimo de 48×48 dp y tiene `label` + `hint` descriptivos.
- El nombre, bio y email se agrupan en un contenedor semántico para lectura fluida.
- Cada miniatura del grid incluye: descripción, posición (*"Publicació 3 de 12, Fila 1, Columna 3"*) y número de likes.

---

### Configuración (Settings)

- El switch de tema claro/oscuro usa `Semantics(toggled: bool, label: 'Tema fosc')` + `SnackBar` con `liveRegion` que anuncia el cambio.
- El switch de notificaciones sigue el mismo patrón con `Semantics(toggled: bool)`.
- El selector de idioma tiene label visible y `Semantics` claro; las opciones son legibles con TalkBack.
- Todo el texto de la app escala con las preferencias del sistema (sin ningún `MediaQuery.copyWith(textScaleFactor: 1.0)` en el código).
- El botón "Tancar sessió" abre un diálogo de confirmación accesible con las opciones Cancel·lar / Tancar sessió etiquetadas con `Semantics(button: true, label: '...')`.
- TalkBack mueve el foco automáticamente al diálogo al abrirse.

---

### Testing con TalkBack

Las pruebas se realizan con TalkBack activado (`Configuració → Accessibilitat → TalkBack`) y la pantalla tapada para simular uso real sin visión.

**Herramientas utilizadas:**
- **TalkBack** (Android) — pruebas manuales con gestos reales
- **Accessibility Scanner** (Google Play) — detecta problemas de contraste y tamaño
- **Flutter DevTools — Inspector de Semantics** — árbol de accesibilidad en tiempo real

**Checklist global de validación:**

- ✅ Splash Screen anuncia el estado de carga con TalkBack
- ✅ Login completable sin mirar la pantalla
- ✅ Errores de validación anunciados automáticamente
- ✅ Botón de like con estado `toggled` y feedback auditivo
- ✅ Comentarios leídos como unidades coherentes
- ✅ Crear post con confirmación accesible
- ✅ Perfil con estadísticas agrupadas semánticamente
- ✅ Grid de posts con posición y descripción en cada miniatura
- ✅ Settings con switches, selector de idioma y cierre de sesión accesibles
- ✅ Todo el texto escala con las preferencias del sistema
- ✅ Ningún elemento interactivo por debajo de 48×48 dp
- ✅ El color nunca es el único indicador de estado

---
---

# 🎬 Guión DEMO — InstaDAM

> Duración estimada: **5–8 minutos**  
> Objetivo: mostrar el flujo completo de usuario, desde el login hasta la interacción social.

---

## Escena 1 — Arranque y Login (0:00 – 1:00)

**Acción:** Lanzar la aplicación.

> "InstaDAM es una red social construida completamente en Flutter, con almacenamiento local SQLite y soporte multiplataforma. Vamos a ver el flujo completo."

- Mostrar la pantalla de login.
- Introducir usuario y contraseña de un usuario de prueba.
- Pulsar el botón de entrar.

**Puntos a destacar:**
- La autenticación valida credenciales contra la base de datos local.
- No requiere conexión a internet.

---

## Escena 2 — Feed principal (1:00 – 2:30)

**Acción:** Navegar por el feed.

> "Una vez autenticados, llegamos al feed principal donde vemos los posts de todos los usuarios."

- Hacer scroll por el feed.
- Señalar el `PostCard` como componente reutilizable.
- Mostrar que cada post incluye: autor, contenido, contador de likes y acceso a comentarios.

**Puntos a destacar:**
- Los datos se cargan desde SQLite en tiempo real.
- El diseño usa componentes `widgets/` independientes y reutilizables.

---

## Escena 3 — Likes (2:30 – 3:30)

**Acción:** Dar like a un post.

> "El sistema de likes es inmediato. Al pulsar el botón, el estado se actualiza en base de datos y la UI refleja el cambio al instante."

- Pulsar el `LikeButton` en varios posts.
- Mostrar que el contador sube y baja.
- Dar like, cerrar sesión, volver a entrar: el like persiste.

**Puntos a destacar:**
- Persistencia real en SQLite, no solo en memoria.

---

## Escena 4 — Comentarios (3:30 – 4:30)

**Acción:** Entrar en la pantalla de comentarios de un post.

> "Podemos ver y añadir comentarios en cualquier post."

- Pulsar sobre un post para abrir `CommentsScreen`.
- Leer los comentarios existentes.
- Escribir un comentario nuevo y enviarlo.
- Mostrar que aparece inmediatamente en la lista.

---

## Escena 5 — Crear un post (4:30 – 5:30)

**Acción:** Navegar a la pantalla de creación de post.

> "Crear un nuevo post es muy sencillo. Escribimos el contenido y publicamos."

- Ir a `CreatePostScreen`.
- Escribir un texto de ejemplo.
- Publicar y volver al feed.
- Mostrar que el nuevo post aparece en el feed.

---

## Escena 6 — Perfil de usuario (5:30 – 6:30)

**Acción:** Ir a la pantalla de perfil.

> "En el perfil vemos la información del usuario y todos sus posts propios."

- Navegar a `ProfileScreen`.
- Mostrar los datos del usuario.
- Mostrar la lista filtrada de posts propios.

---

## Escena 7 — Configuración y cierre (6:30 – 7:30)

**Acción:** Abrir la pantalla de ajustes.

> "Por último, la app incluye una pantalla de configuración para gestionar preferencias, gestionadas con SharedPreferences."

- Mostrar `SettingsScreen` brevemente.
- Cerrar sesión.
- Volver a la pantalla de login: demostrar que la sesión se ha cerrado correctamente.

---

## Cierre de la demo

> "InstaDAM demuestra una arquitectura Flutter completa: separación en capas (models, screens, widgets, services), base de datos relacional local multiplataforma con SQLite, y persistencia de sesión con SharedPreferences. El proyecto es funcional en Android, iOS, Web, Windows, macOS y Linux desde la misma base de código."

---

*InstaDAM — Proyecto Flutter · v1.0.0*
