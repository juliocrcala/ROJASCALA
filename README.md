# Rojas Cala - Análisis de Normas Legales

Aplicación web para el análisis y seguimiento de normas legales peruanas, desarrollada con React, TypeScript y Supabase.

## Características

- **Gestión de Artículos**: Sistema completo para artículos normales y especiales
- **Categorización**: Organización por categorías legales y tipos de documentos
- **Búsqueda Avanzada**: Búsqueda y filtrado por múltiples criterios
- **Calendario**: Vista de normas organizadas por fecha de publicación
- **Panel de Administración**: Gestión completa de contenido, contactos y configuración
- **Sistema de Contactos**: Perfiles de especialistas legales
- **Responsive**: Diseño adaptable a todos los dispositivos

## Estructura del Proyecto

```
/
├── src/
│   ├── components/         # Componentes React
│   │   ├── AdminPanel.tsx
│   │   ├── AdminLogin.tsx
│   │   ├── ArticleForm.tsx
│   │   ├── CategoriesManager.tsx
│   │   ├── ConsultationsManager.tsx
│   │   ├── ContactsManager.tsx
│   │   ├── ErrorBoundary.tsx
│   │   └── FloatingHelpWidget.tsx
│   ├── hooks/             # React hooks personalizados
│   │   └── useAuth.ts
│   ├── lib/               # Configuración y utilidades
│   │   └── supabase.ts
│   ├── App.tsx            # Componente principal
│   ├── main.tsx           # Punto de entrada
│   └── index.css          # Estilos globales
├── supabase/
│   ├── migrations/        # Migraciones de base de datos
│   └── functions/         # Edge Functions
│       └── contact-form/
├── docs/                  # Documentación adicional
├── dist/                  # Build de producción
└── .env                   # Variables de entorno

```

## Tecnologías Utilizadas

- **Frontend**: React 18 + TypeScript
- **Estilos**: Tailwind CSS
- **Base de Datos**: Supabase (PostgreSQL)
- **Autenticación**: Supabase Auth
- **Routing**: React Router v6
- **Iconos**: Lucide React
- **Build Tool**: Vite
- **Utilidades**: date-fns para manejo de fechas

## Instalación

1. Clonar el repositorio
2. Instalar dependencias:
   ```bash
   npm install
   ```
3. Configurar variables de entorno en `.env`:
   ```
   VITE_SUPABASE_URL=tu_url_de_supabase
   VITE_SUPABASE_ANON_KEY=tu_clave_anon_de_supabase
   ```

## Desarrollo

```bash
npm run dev
```

La aplicación estará disponible en `http://localhost:5173`

## Build

```bash
npm run build
```

Los archivos compilados estarán en la carpeta `dist/`

## Base de Datos

El proyecto utiliza Supabase con las siguientes tablas principales:

- `articles`: Artículos de normas legales
- `special_articles`: Artículos especiales y análisis
- `contacts`: Información de especialistas
- `categories_config`: Configuración de categorías y tipos de documentos
- `consultations`: Sistema de consultas

### Migraciones

Las migraciones SQL están en `supabase/migrations/` y se aplican automáticamente en Supabase.

## Páginas

- **Inicio**: Vista principal con artículos recientes
- **Normas**: Filtrado por tipos de normas legales
- **Fechas**: Calendario de publicaciones
- **Categorías**: Organización por categorías legales
- **Especiales**: Artículos especiales y análisis profundos
- **Contacto**: Perfiles de especialistas
- **Admin**: Panel de administración (requiere autenticación)

## Características del Panel de Administración

- Gestión de artículos normales y especiales
- Administración de contactos con fotos
- Configuración de categorías y tipos de documentos
- Sistema de consultas
- Modo de vista previa
- Validación de enlaces oficiales

## Licencia

© 2025 Rojas Cala. Todos los derechos reservados.
