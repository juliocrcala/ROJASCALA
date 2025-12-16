# 🚀 INSTRUCCIONES PARA CONFIGURAR SUPABASE

## ⚠️ PROBLEMA IDENTIFICADO
Las tablas no existen en tu base de datos de Supabase. Necesitas ejecutar el script SQL manualmente.

## 📋 PASOS A SEGUIR:

### 1. 🔗 Ir al Panel de Supabase
Ve a: https://supabase.com/dashboard/project/kyekcfjulzgvziqpyfod

### 2. 📊 Abrir el Editor SQL
- En el menú lateral, busca **"SQL Editor"**
- Haz clic en **"New Query"**

### 3. 📝 Ejecutar el Script
- Copia TODO el contenido del archivo `setup-database.sql`
- Pégalo en el editor SQL
- Haz clic en **"Run"** o presiona **Ctrl+Enter**

### 4. ✅ Verificar Creación
Después de ejecutar, deberías ver:
- ✅ Tabla `articles` creada
- ✅ Tabla `special_articles` creada
- ✅ Políticas RLS configuradas
- ✅ Índices creados

### 5. 🔍 Comprobar en la Interfaz
- Ve a **"Table Editor"** en el menú lateral
- Deberías ver las tablas `articles` y `special_articles`

## 🎯 DESPUÉS DE EJECUTAR EL SCRIPT:

### ✅ Podrás:
- ➕ **Crear artículos normativos** (con tipo de norma)
- ➕ **Crear artículos especiales** (solo con categoría)
- ✏️ **Editar y eliminar** ambos tipos
- 👀 **Ver todos los artículos** en el frontend

### 🔧 Si hay errores:
1. **Verifica** que estés en el proyecto correcto
2. **Revisa** que tengas permisos de administrador
3. **Contacta** si persisten los problemas

## 📞 SOPORTE
Si tienes problemas ejecutando el script, avísame y te ayudo paso a paso.