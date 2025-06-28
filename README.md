# Eventos Cruz de Cristal

Aplicación móvil para la gestión de eventos e iglesias, desarrollada en Flutter.

## 📋 Descripción

Esta aplicación permite la gestión completa de eventos religiosos, iglesias y actividades de ayuno. Está diseñada para tres tipos de usuarios principales:

- **Administrador Global (AG)**: Control total de la plataforma
- **Administrador de Iglesia (AI)**: Gestión de su iglesia específica
- **Miembro (M)**: Participación en eventos y ayunos

## 🚀 Características Principales

### 📅 Gestión de Eventos
- Creación, edición y eliminación de eventos
- Sistema de likes y participación
- Notificaciones automáticas (24h y 1h antes)
- Historial de eventos pasados
- Filtrado y búsqueda avanzada

### ⛪ Gestión de Iglesias
- Registro y solicitud de nuevas iglesias
- Listado público de iglesias
- Gestión de asistentes
- Aprobación/rechazo de solicitudes

### 🙏 Módulo de Ayuno
- Creación de motivos de ayuno
- Asignación por días de la semana
- Tablero de participantes
- Recordatorios automáticos a las 21:00

### 📱 Notificaciones
- Eventos creados
- Recordatorios de eventos
- Cambios en eventos
- Asignaciones de ayuno
- Mensajes globales del administrador

### 🔐 Sistema de Roles y Permisos
- Autenticación segura
- Control de acceso basado en roles
- Verificación de email obligatoria
- Sistema de bans y desactivación

## 🛠️ Tecnologías Utilizadas

- **Flutter**: Framework principal
- **Dart**: Lenguaje de programación
- **GoRouter**: Navegación
- **Bloc/Cubit**: Gestión de estado
- **Firebase**: Autenticación y backend
- **Hive**: Almacenamiento local
- **json_serializable**: Serialización de datos

## 📦 Dependencias Principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^14.2.7
  flutter_bloc: ^8.1.3
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  shared_preferences: ^2.2.2
  dio: ^5.4.0
  cached_network_image: ^3.3.1
  image_picker: ^1.0.7
```

## 🏗️ Arquitectura del Proyecto

```
lib/
├── config/
│   └── router.dart              # Configuración de rutas
├── core/
│   ├── constants/
│   │   └── app_constants.dart   # Constantes de la aplicación
│   ├── utils/                   # Utilidades
│   ├── services/                # Servicios globales
│   └── error/                   # Manejo de errores
├── features/
│   ├── auth/                    # Autenticación
│   ├── church/                  # Gestión de iglesias
│   ├── events/                  # Gestión de eventos
│   ├── fasting/                 # Módulo de ayuno
│   ├── admin/                   # Panel de administración
│   └── notifications/           # Sistema de notificaciones
└── shared/
    ├── models/                  # Modelos de datos
    ├── widgets/                 # Widgets reutilizables
    └── repositories/            # Repositorios de datos
```

## 🚀 Instalación y Configuración

### Prerrequisitos
- Flutter SDK (>= 3.8.1)
- Dart SDK (>= 3.8.1)
- Android Studio / VS Code
- Firebase CLI (opcional)

### Pasos de Instalación

1. **Clonar el repositorio:**
```bash
git clone [URL_DEL_REPOSITORIO]
cd eventos_cruz_de_cristal
```

2. **Instalar dependencias:**
```bash
flutter pub get
```

3. **Generar archivos de código:**
```bash
flutter packages pub run build_runner build
```

4. **Configurar Firebase:**
   - Crear proyecto en Firebase Console
   - Agregar apps Android/iOS
   - Descargar y configurar archivos de configuración

5. **Ejecutar la aplicación:**
```bash
flutter run
```

## 📋 Requisitos Funcionales Implementados

### ✅ Autenticación y Roles (RF-1)
- [x] Pantalla inicial de registro
- [x] Flujo de registro de iglesia
- [x] Flujo de registro de miembros
- [x] Verificación de email
- [x] Gestión de roles

### ✅ Gestión de Iglesias (RF-2)  
- [x] Listado público de iglesias
- [x] Sistema de asistencia
- [x] Aprobación de solicitudes

### ✅ Gestión de Eventos (RF-4)
- [x] CRUD completo de eventos
- [x] Sistema de likes
- [x] Filtrado y búsqueda
- [x] Historial de eventos

### ✅ Módulo de Ayuno (RF-5)
- [x] Creación de motivos
- [x] Asignación por días
- [x] Tablero de participantes

### ✅ Sistema de Notificaciones (RF-6)
- [x] Notificaciones de eventos
- [x] Recordatorios automáticos
- [x] Mensajes globales

## 📱 Pantallas Principales

### Autenticación
- Splash Screen
- Login
- Registro (Miembro/Iglesia)

### Principales
- Dashboard/Inicio
- Lista de Eventos
- Detalle de Evento
- Lista de Iglesias
- Módulo de Ayunos

### Administración
- Panel de Administración
- Gestión de Usuarios
- Gestión de Iglesias
- Analíticas

## 🔒 Permisos y Seguridad

| Acción | AG | AI | M |
|--------|----|----|---|
| Crear/Editar Iglesia | ✅ | ❌ | ❌ |
| Crear/Editar Evento | ✅ | ✅* | ❌ |
| Crear/Editar Ayuno | ✅ | ✅* | ❌ |
| Dar/Quitar Like | ✅ | ✅ | ✅ |
| Asignarse Día Ayuno | ✅ | ✅ | ✅ |
| Notificación Global | ✅ | ❌ | ❌ |

*Solo para su iglesia

## 🤝 Contribución

1. Fork el proyecto
2. Crear una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir un Pull Request

## 📝 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## 👥 Equipo de Desarrollo

- **Desarrollador Principal**: [Tu Nombre]
- **Diseño UI/UX**: [Nombre del Diseñador]
- **Backend**: [Nombre del Desarrollador Backend]

## 📞 Contacto

Para preguntas o soporte, contacta a:
- Email: soporte@eventoscruzdecruzal.com
- Teléfono: +1234567890

## 🗺️ Roadmap

### Versión 1.1
- [ ] Chat en tiempo real
- [ ] Integración con calendarios
- [ ] Modo offline mejorado

### Versión 1.2
- [ ] Streaming de eventos en vivo
- [ ] Sistema de donaciones
- [ ] Estadísticas avanzadas

---

**Eventos Cruz de Cristal** - Conectando comunidades de fe 🙏
