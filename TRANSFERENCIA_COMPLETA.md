# 🚀 GUÍA COMPLETA DE TRANSFERENCIA - ROJAS CALA

## 📋 RESUMEN DEL PROYECTO

**Proyecto:** Sistema de Gestión de Normas Legales - Rojas Cala
**Tecnologías:** React + TypeScript + Tailwind CSS + Supabase
**Estado:** Completamente funcional con panel de administración

## 🗄️ CONFIGURACIÓN DE SUPABASE

### **Credenciales actuales:**
```
VITE_SUPABASE_URL=https://kyekcfjulzgvziqpyfod.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt5ZWtjZmp1bHpndnppcXB5Zm9kIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA1NjkzNjQsImV4cCI6MjA2NjE0NTM2NH0.UVCqAK9eodnYaVxZyrrD6n7aU5x3cNC92ypaVgM0krQ
```

### **Base de datos configurada:**
- ✅ Tabla `articles` (artículos normativos)
- ✅ Tabla `special_articles` (artículos especiales)
- ✅ Tabla `contacts` (contactos/autores)
- ✅ Tabla `consultations` (consultas de usuarios)
- ✅ Tabla `categories_config` (configuración de categorías)
- ✅ Políticas RLS configuradas
- ✅ Datos de ejemplo insertados

## 🔧 FUNCIONALIDADES IMPLEMENTADAS

### **Frontend:**
- ✅ Página principal con listado de artículos
- ✅ Sistema de búsqueda y filtros avanzados
- ✅ Páginas por categorías y tipos de normas
- ✅ Calendario de publicaciones
- ✅ Página de contactos con múltiples autores
- ✅ Artículos especiales con imágenes
- ✅ Sistema de navegación responsive
- ✅ Widget flotante de consultas

### **Panel de Administración:**
- ✅ Sistema de autenticación con contraseña
- ✅ Gestión completa de artículos normativos
- ✅ Gestión de artículos especiales
- ✅ Gestión de contactos/autores
- ✅ Gestión de consultas de usuarios
- ✅ Configuración de categorías y tipos
- ✅ Sistema de visibilidad (ocultar/mostrar artículos)
- ✅ Ordenamiento manual de contactos

### **Credenciales de Admin:**
```
Contraseña: RojasCala2025!
```

## 📁 ESTRUCTURA DEL PROYECTO

```
src/
├── components/
│   ├── AdminPanel.tsx          # Panel principal de administración
│   ├── AdminLogin.tsx          # Login del admin
│   ├── ContactsManager.tsx     # Gestión de contactos
│   ├── ConsultationsManager.tsx # Gestión de consultas
│   ├── CategoriesManager.tsx   # Gestión de categorías
│   ├── FloatingHelpWidget.tsx  # Widget de ayuda flotante
│   └── ErrorBoundary.tsx       # Manejo de errores
├── hooks/
│   └── useAuth.ts              # Hook de autenticación
├── lib/
│   └── supabase.ts             # Configuración de Supabase
└── App.tsx                     # Componente principal
```

## 🎯 PASOS PARA TRANSFERIR

### **1. Crear nuevo proyecto en tu Bolt con suscripción**
- Selecciona "React + TypeScript + Tailwind"
- Nombre: "rojas-cala-legal"

### **2. Copiar archivos principales**
- Copia todo el contenido de `src/App.tsx`
- Copia toda la carpeta `src/components/`
- Copia toda la carpeta `src/hooks/`
- Copia toda la carpeta `src/lib/`
- Copia el archivo `.env`

### **3. Instalar dependencias**
```bash
npm install @supabase/supabase-js@latest
npm install date-fns@latest
npm install react-router-dom@latest
npm install lucide-react@latest
```

### **4. Configurar variables de entorno**
Crear archivo `.env` con:
```
VITE_SUPABASE_URL=https://kyekcfjulzgvziqpyfod.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt5ZWtjZmp1bHpndnppcXB5Zm9kIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA1NjkzNjQsImV4cCI6MjA2NjE0NTM2NH0.UVCqAK9eodnYaVxZyrrD6n7aU5x3cNC92ypaVgM0krQ
```

### **5. Verificar funcionamiento**
- Ejecutar `npm run dev`
- Probar todas las páginas
- Probar el panel de admin con la contraseña
- Verificar que se conecte a Supabase

## ✅ CHECKLIST DE VERIFICACIÓN

Después de la transferencia, verifica que funcione:

### **Frontend:**
- [ ] Página principal carga correctamente
- [ ] Menú de navegación funciona
- [ ] Búsqueda y filtros funcionan
- [ ] Páginas de categorías y tipos cargan
- [ ] Calendario muestra artículos
- [ ] Página de contactos muestra información
- [ ] Widget de consultas funciona

### **Panel de Admin:**
- [ ] Login funciona con contraseña `RojasCala2025!`
- [ ] Se pueden crear artículos normativos
- [ ] Se pueden crear artículos especiales
- [ ] Se pueden gestionar contactos
- [ ] Se pueden ver consultas
- [ ] Se pueden configurar categorías

### **Base de Datos:**
- [ ] Los artículos se guardan correctamente
- [ ] Las consultas se reciben
- [ ] Los contactos se pueden editar
- [ ] Las categorías se pueden modificar

## 🆘 SOLUCIÓN DE PROBLEMAS

### **Si no se conecta a Supabase:**
1. Verificar que las variables de entorno estén correctas
2. Verificar que el archivo `.env` esté en la raíz del proyecto
3. Reiniciar el servidor de desarrollo

### **Si el admin no funciona:**
1. Verificar que la contraseña sea exactamente: `RojasCala2025!`
2. Verificar que el componente AdminPanel esté importado
3. Verificar la ruta `/admin`

### **Si faltan estilos:**
1. Verificar que Tailwind CSS esté instalado
2. Verificar que `src/index.css` tenga las directivas de Tailwind

## 📞 CONTACTO PARA SOPORTE

Si tienes problemas durante la transferencia, necesitarás:
1. Captura de pantalla del error
2. Logs de la consola del navegador
3. Descripción de qué estabas haciendo cuando ocurrió

## 🎉 ¡PROYECTO LISTO!

Una vez completada la transferencia, tendrás:
- ✅ Sistema completo de gestión de normas legales
- ✅ Panel de administración funcional
- ✅ Base de datos configurada y poblada
- ✅ Diseño responsive y profesional
- ✅ Todas las funcionalidades implementadas

**¡Tu nueva cuenta de Bolt tendrá exactamente la misma funcionalidad que tienes aquí!**