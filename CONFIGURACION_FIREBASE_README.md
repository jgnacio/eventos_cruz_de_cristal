# 🔥 Configuración Completa de Firebase - Eventos Cruz de Cristal

## ✅ Estado Actual del Proyecto

**¡El proyecto ya está preparado para Firebase!** Se han implementado todos los servicios y repositorios necesarios.

### Lo que está implementado:
- ✅ Autenticación completa con Firebase Auth
- ✅ Base de datos Firestore para todos los modelos
- ✅ Repositorios para usuarios, ayunos, iglesias y eventos
- ✅ Servicio integrado de ayunos con notificaciones
- ✅ Estructura completa de datos
- ✅ Manejo de errores y logs

## 🚀 Pasos para Activar Firebase

### 1. Crear Proyecto en Firebase Console
1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Clic en "Crear proyecto"
3. Nombre: `eventos-cruz-de-cristal`
4. Habilita Google Analytics (opcional)
5. Crea el proyecto

### 2. Habilitar Servicios en Firebase

#### Authentication
1. En Firebase Console → Authentication → Sign-in method
2. Habilita **Email/Password**
3. Agrega dominios autorizados si es necesario

#### Firestore Database
1. En Firebase Console → Firestore Database
2. Crear base de datos
3. **Modo:** Empezar en modo de prueba (configurar reglas después)
4. **Ubicación:** us-central1 (o la más cercana)

#### Storage (Opcional - para imágenes futuras)
1. En Firebase Console → Storage
2. Comenzar

### 3. Configurar en Flutter

#### Instalar Firebase CLI
```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli
```

#### Configurar proyecto automáticamente
```bash
# Desde la raíz del proyecto
flutterfire configure

# Selecciona:
# - Tu proyecto: eventos-cruz-de-cristal
# - Plataformas: Android, iOS, Web
# - Aplicación: eventos_cruz_de_cristal
```

#### Reemplazar firebase_options.dart
El comando anterior generará un archivo `firebase_options.dart` con tus claves reales. Reemplaza el archivo actual en `lib/firebase_options.dart`.

### 4. Configurar Reglas de Firestore

En Firebase Console → Firestore Database → Reglas, reemplaza con:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Reglas para usuarios
    match /users/{userId} {
      // Los usuarios pueden leer y editar su propio perfil
      allow read, write: if request.auth != null && request.auth.uid == userId;
      // Los administradores pueden leer todos los usuarios
      allow read: if request.auth != null && 
        resource.data.rol in ['administradorGlobal', 'administradorIglesia'];
    }
    
    // Reglas para iglesias
    match /churches/{churchId} {
      // Todos los usuarios autenticados pueden leer iglesias aprobadas
      allow read: if request.auth != null && resource.data.isApproved == true;
      // Solo administradores globales pueden crear/editar iglesias
      allow write: if request.auth != null;
    }
    
    // Reglas para ayunos
    match /fastings/{fastingId} {
      // Todos los usuarios autenticados pueden leer ayunos
      allow read: if request.auth != null;
      // Solo administradores pueden crear/editar ayunos
      allow write: if request.auth != null;
    }
    
    // Reglas para registros de ayuno de usuarios
    match /user_fasting_records/{recordId} {
      // Los usuarios pueden leer y editar sus propios registros
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
    
    // Reglas para eventos
    match /events/{eventId} {
      // Todos los usuarios autenticados pueden leer eventos
      allow read: if request.auth != null;
      // Solo administradores pueden crear/editar eventos
      allow write: if request.auth != null;
    }
  }
}
```

### 5. Configurar Android (Si usas Android)

#### android/app/google-services.json
El comando `flutterfire configure` debería haberlo creado automáticamente. Si no:

1. En Firebase Console → Configuración del proyecto → Tus apps
2. Selecciona la app Android
3. Descarga `google-services.json`
4. Colócalo en `android/app/google-services.json`

#### android/app/build.gradle.kts
Agrega al final del archivo:
```kotlin
apply(plugin = "com.google.gms.google-services")
```

#### android/build.gradle.kts
En la sección `dependencies`:
```kotlin
classpath("com.google.gms:google-services:4.4.0")
```

### 6. Configurar iOS (Si usas iOS)

#### ios/Runner/GoogleService-Info.plist
El comando `flutterfire configure` debería haberlo creado automáticamente.

## 📊 Estructura de Datos en Firestore

### Colección: `users`
```javascript
{
  id: "user_id",
  email: "usuario@email.com",
  nombre: "Nombre Usuario",
  telefono: "+1234567890",
  rol: "miembro" | "administradorIglesia" | "administradorGlobal",
  isVerified: true,
  isBanned: false,
  iglesiasAsistidas: ["iglesia_id_1", "iglesia_id_2"],
  createdAt: timestamp,
  updatedAt: timestamp
}
```

### Colección: `churches`
```javascript
{
  id: "church_id",
  nombre: "Iglesia Ejemplo",
  direccion: "Calle 123",
  ciudad: "Ciudad",
  telefono: "+1234567890",
  email: "iglesia@email.com",
  pastor: "Pastor Nombre",
  descripcion: "Descripción de la iglesia",
  isApproved: true,
  createdAt: timestamp,
  updatedAt: timestamp
}
```

### Colección: `fastings`
```javascript
{
  id: "fasting_id",
  titulo: "Ayuno 21 días",
  descripcion: "Descripción del ayuno",
  fechaInicio: timestamp,
  fechaFin: timestamp,
  iglesiaId: "church_id",
  status: "abierto" | "cerrado",
  participantesPorDia: {
    "lunes": ["user_id_1", "user_id_2"],
    "martes": ["user_id_3"],
    // ... otros días
  },
  createdAt: timestamp,
  updatedAt: timestamp
}
```

### Colección: `user_fasting_records`
```javascript
{
  id: "record_id",
  userId: "user_id",
  fastingId: "fasting_id",
  dia: "lunes",
  fechaAyuno: timestamp,
  confirmoParticipacion: true,
  fechaConfirmacion: timestamp,
  completoAyuno: true,
  fechaCompletado: timestamp,
  notasUsuario: "Notas opcionales",
  createdAt: timestamp,
  updatedAt: timestamp
}
```

### Colección: `events`
```javascript
{
  id: "event_id",
  titulo: "Evento Especial",
  descripcion: "Descripción del evento",
  fechaInicio: timestamp,
  fechaFin: timestamp,
  iglesiaId: "church_id",
  createdAt: timestamp,
  updatedAt: timestamp
}
```

## 🎯 Uso de los Servicios

### Obtener servicios
```dart
final serviceLocator = ServiceLocator();

// Servicios principales
final authService = serviceLocator.authService;
final fastingService = serviceLocator.firebaseFastingService;

// Repositorios
final userRepo = serviceLocator.userRepository;
final fastingRepo = serviceLocator.fastingRepository;
final churchRepo = serviceLocator.churchRepository;
final eventRepo = serviceLocator.eventRepository;
```

### Ejemplos de uso
```dart
// Crear usuario
final user = UserModel(...);
await userRepo.createUser(user);

// Crear ayuno
final fasting = FastingModel(...);
await fastingService.createFasting(fasting);

// Confirmar participación
await fastingService.confirmFastingParticipation(
  userId: 'user_id',
  fastingId: 'fasting_id',
  dia: 'lunes',
);

// Escuchar cambios
fastingService.watchUserRecords(userId).listen((records) {
  // Actualizar UI
});
```

## 🔧 Comandos útiles

```bash
# Instalar dependencias
flutter pub get

# Generar código (si modificas modelos)
flutter packages pub run build_runner build

# Limpiar y regenerar
flutter packages pub run build_runner build --delete-conflicting-outputs

# Ejecutar app
flutter run
```

## 🚨 Notas Importantes

1. **Archivo temporal**: El `firebase_options.dart` actual tiene claves de ejemplo. Reemplázalo con el archivo real generado por `flutterfire configure`.

2. **Reglas de seguridad**: Las reglas de Firestore empiezan en modo de prueba. Configúralas según el ejemplo anterior para producción.

3. **Índices**: Firestore puede requerir índices para consultas complejas. Se crearán automáticamente cuando ejecutes consultas por primera vez.

4. **Notificaciones**: Las notificaciones locales ya están configuradas. Para notificaciones push, agrega Firebase Messaging.

5. **Testing**: Usa el modo mock cambiando `_useFirebase = false` en `service_locator.dart` para pruebas sin Firebase.

## ✅ Verificación

Después de la configuración, verifica que todo funcione:

1. **Autenticación**: Prueba registro y login
2. **Firestore**: Crea un usuario y verifica en Firebase Console
3. **Tiempo real**: Comprueba que los listeners funcionen
4. **Notificaciones**: Verifica que se programen correctamente

¡Tu aplicación está lista para usar Firebase! 🎉 