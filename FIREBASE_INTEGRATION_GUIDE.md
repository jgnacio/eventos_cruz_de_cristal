# 🔥 Guía de Integración Firebase

Esta guía te muestra cómo integrar Firebase correctamente en tu aplicación de Eventos Cruz de Cristal.

## 📋 Prerrequisitos

1. **Cuenta de Firebase**: Ve a [Firebase Console](https://console.firebase.google.com/)
2. **Flutter configurado**: Asegúrate de tener Flutter instalado
3. **Firebase CLI**: Instala Firebase CLI globalmente

```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli
```

## 🚀 Paso 1: Configuración del Proyecto Firebase

### 1.1 Crear Proyecto en Firebase Console
1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Clic en "Crear proyecto"
3. Nombre: `eventos-cruz-de-cristal`
4. Habilita Google Analytics (opcional)
5. Crea el proyecto

### 1.2 Habilitar Servicios Necesarios
En la consola de Firebase:

1. **Authentication**:
   - Ve a Authentication > Sign-in method
   - Habilita Email/Password
   - Configura dominio autorizado

2. **Firestore Database**:
   - Ve a Firestore Database
   - Crear base de datos
   - Modo: Empezar en modo de prueba (cambiarlo después)
   - Ubicación: us-central (o la más cercana)

3. **Storage** (opcional para imágenes):
   - Ve a Storage
   - Comenzar

## 🔧 Paso 2: Configuración en Flutter

### 2.1 Instalar Dependencias
Agrega al `pubspec.yaml`:

```yaml
dependencies:
  # Firebase Core (requerido)
  firebase_core: ^2.24.2
  
  # Authentication
  firebase_auth: ^4.15.3
  
  # Firestore Database
  cloud_firestore: ^4.13.6
  
  # Storage (opcional)
  firebase_storage: ^11.5.6
  
  # Analytics (opcional)
  firebase_analytics: ^10.7.4

dev_dependencies:
  # Para generar configuración automática
  flutterfire_cli: ^0.3.0
```

### 2.2 Configurar Firebase en el Proyecto

```bash
# Ejecutar desde la raíz del proyecto
flutterfire configure

# Selecciona:
# - Tu proyecto Firebase creado anteriormente
# - Plataformas: Android, iOS, Web (las que necesites)
# - Aplicación: eventos_cruz_de_cristal
```

Este comando creará automáticamente:
- `lib/firebase_options.dart`
- Configuración para Android (`android/app/google-services.json`)
- Configuración para iOS (`ios/Runner/GoogleService-Info.plist`)

### 2.3 Inicializar Firebase en main.dart

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}
```

## 🔄 Paso 3: Cambiar a Firebase en el Código

### 3.1 Activar Firebase en ServiceLocator
En `lib/core/services/service_locator.dart`:

```dart
class ServiceLocator {
  // Cambiar esta línea a true
  static const bool _useFirebase = true; // ✅ Activar Firebase
  
  // ... resto del código
}
```

### 3.2 Descomentar FirebaseAuthService
En `lib/core/services/firebase_auth_service.dart`:

1. Descomenta todo el código (quita `/*` y `*/`)
2. Asegúrate de que todos los imports estén correctos

### 3.3 Inicializar FirebaseAuthService
En `main.dart`, después de inicializar Firebase:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Inicializar servicios de Firebase
  await ServiceLocator().authService.initialize();
  
  runApp(const MyApp());
}
```

## 📊 Paso 4: Estructura de Datos en Firestore

### 4.1 Colección Users
```
users/{userId}
├── id: string
├── email: string
├── nombre: string
├── telefono: string
├── rol: "administradorGlobal" | "administradorIglesia" | "miembro"
├── isVerified: boolean
├── iglesiasAsistidas: string[] (opcional)
├── createdAt: timestamp
└── updatedAt: timestamp (opcional)
```

### 4.2 Colección Churches
```
churches/{churchId}
├── id: string
├── nombre: string
├── direccion: string
├── ciudad: string
├── telefono: string
├── email: string
├── pastor: string
├── descripcion: string
├── isApproved: boolean
├── createdAt: timestamp
└── updatedAt: timestamp
```

### 4.3 Colección Fastings
```
fastings/{fastingId}
├── id: string
├── titulo: string
├── descripcion: string
├── fechaInicio: timestamp (opcional)
├── fechaFin: timestamp (opcional)
├── iglesiaId: string
├── status: "abierto" | "cerrado"
├── participantesPorDia: map
│   ├── lunes: string[]
│   ├── martes: string[]
│   └── ... (otros días)
├── createdAt: timestamp
└── updatedAt: timestamp
```

### 4.4 Colección Events
```
events/{eventId}
├── id: string
├── titulo: string
├── descripcion: string
├── fechaInicio: timestamp
├── fechaFin: timestamp
├── ubicacion: string
├── iglesiaId: string
├── imagenUrl: string (opcional)
├── likes: string[]
├── status: "activo" | "historico" | "cancelado"
├── createdAt: timestamp
└── updatedAt: timestamp
```

## 🔒 Paso 5: Reglas de Seguridad

### 5.1 Firestore Rules
En Firebase Console > Firestore > Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      allow read: if request.auth != null && 
                      (resource.data.rol == 'administradorGlobal' || 
                       resource.data.rol == 'administradorIglesia');
    }
    
    // Churches
    match /churches/{churchId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
                       (getUserRole() == 'administradorGlobal' ||
                        getUserRole() == 'administradorIglesia');
    }
    
    // Events
    match /events/{eventId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
                       (getUserRole() == 'administradorGlobal' ||
                        getUserRole() == 'administradorIglesia');
    }
    
    // Fastings
    match /fastings/{fastingId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
                       (getUserRole() == 'administradorGlobal' ||
                        getUserRole() == 'administradorIglesia');
    }
    
    // Function to get user role
    function getUserRole() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data.rol;
    }
  }
}
```

### 5.2 Authentication Rules
En Firebase Console > Authentication > Settings:

- **Dominios autorizados**: Agrega tu dominio de producción
- **Plantillas de email**: Personaliza los emails de verificación

## 🧪 Paso 6: Testing con Firebase

### 6.1 Crear Usuarios de Prueba
Puedes crear usuarios de prueba directamente en Firebase Console:

1. Ve a Authentication > Users
2. Clic en "Agregar usuario"
3. Crea usuarios con diferentes roles:
   - `admin@test.com` (Administrador Global)
   - `pastor@test.com` (Administrador Iglesia)
   - `miembro@test.com` (Miembro)

### 6.2 Poblar Datos de Prueba
Crea un script para poblar datos iniciales:

```dart
// lib/utils/seed_data.dart
class SeedData {
  static Future<void> seedInitialData() async {
    final firestore = FirebaseFirestore.instance;
    
    // Crear iglesia de prueba
    await firestore.collection('churches').doc('church1').set({
      'id': 'church1',
      'nombre': 'Iglesia Central',
      'direccion': 'Av. Principal 123',
      'ciudad': 'Ciudad',
      'telefono': '+1234567890',
      'email': 'contacto@iglesiacentral.com',
      'pastor': 'Pastor Juan',
      'descripcion': 'Iglesia de prueba para desarrollo',
      'isApproved': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
    
    // Crear eventos de prueba
    await firestore.collection('events').doc('event1').set({
      'id': 'event1',
      'titulo': 'Culto Dominical',
      'descripcion': 'Culto de adoración y predicación',
      'fechaInicio': Timestamp.fromDate(DateTime.now().add(Duration(days: 7))),
      'fechaFin': Timestamp.fromDate(DateTime.now().add(Duration(days: 7, hours: 2))),
      'ubicacion': 'Iglesia Central',
      'iglesiaId': 'church1',
      'likes': <String>[],
      'status': 'activo',
      'createdAt': FieldValue.serverTimestamp(),
    });
    
    // Crear ayuno de prueba
    await firestore.collection('fastings').doc('fasting1').set({
      'id': 'fasting1',
      'titulo': 'Ayuno por la Paz',
      'descripcion': 'Ayuno comunitario por la paz mundial',
      'fechaInicio': Timestamp.fromDate(DateTime.now()),
      'fechaFin': Timestamp.fromDate(DateTime.now().add(Duration(days: 30))),
      'iglesiaId': 'church1',
      'status': 'abierto',
      'participantesPorDia': {
        'lunes': <String>[],
        'martes': <String>[],
        'miercoles': <String>[],
        'jueves': <String>[],
        'viernes': <String>[],
        'sabado': <String>[],
        'domingo': <String>[],
      },
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
```

## 🚀 Paso 7: Deployment

### 7.1 Para Android
1. Configura el signing en `android/app/build.gradle`
2. Agrega el SHA-1 fingerprint en Firebase Console
3. Construye: `flutter build apk --release`

### 7.2 Para iOS
1. Configura el bundle ID en Xcode
2. Agrega el GoogleService-Info.plist actualizado
3. Construye: `flutter build ios --release`

### 7.3 Para Web
1. Configura hosting en Firebase
2. `flutter build web`
3. `firebase init hosting`
4. `firebase deploy`

## 🔍 Debugging y Troubleshooting

### Problemas Comunes:

1. **"Firebase not initialized"**:
   - Asegúrate de llamar `Firebase.initializeApp()` antes de `runApp()`

2. **"google-services.json not found"**:
   - Ejecuta `flutterfire configure` nuevamente
   - Verifica que el archivo esté en `android/app/`

3. **"Permission denied" en Firestore**:
   - Revisa las reglas de seguridad
   - Verifica que el usuario esté autenticado

4. **Problemas de build en iOS**:
   - Abre iOS en Xcode y limpia el build
   - Verifica que GoogleService-Info.plist esté añadido correctamente

## 📞 Soporte

Si tienes problemas:
1. Revisa la [documentación oficial de Firebase](https://firebase.google.com/docs/flutter/setup)
2. Consulta [FlutterFire](https://firebase.flutter.dev/)
3. Verifica la configuración paso a paso

## ✅ Checklist Final

- [ ] Proyecto Firebase creado
- [ ] Servicios habilitados (Auth, Firestore)
- [ ] `flutterfire configure` ejecutado
- [ ] Dependencias instaladas
- [ ] `_useFirebase = true` en ServiceLocator
- [ ] FirebaseAuthService descomentado
- [ ] Firebase inicializado en main.dart
- [ ] Reglas de seguridad configuradas
- [ ] Datos de prueba poblados
- [ ] Testing completado

¡Listo! Tu aplicación ahora debería estar funcionando con Firebase. 🎉 