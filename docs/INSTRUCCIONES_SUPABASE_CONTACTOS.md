# 🚀 INSTRUCCIONES PARA AGREGAR TABLA DE CONTACTOS

## ⚠️ NUEVO SCRIPT REQUERIDO
Necesitas ejecutar un script adicional para crear la tabla de contactos y vincular autores.

## 📋 PASOS A SEGUIR:

### 1. 🔗 Ir al Panel de Supabase
Ve a: https://supabase.com/dashboard/project/meauxterbqshoxvctkjq

### 2. 📊 Abrir el Editor SQL
- En el menú lateral, busca **"SQL Editor"**
- Haz clic en **"New Query"**

### 3. 📝 Ejecutar el Script de Contactos
- Copia TODO el contenido del archivo `create_contacts_table.sql`
- Pégalo en el editor SQL
- Haz clic en **"Run"** o presiona **Ctrl+Enter**

### 4. ✅ Verificar Creación
Después de ejecutar, deberías ver:
- ✅ Tabla `contacts` creada
- ✅ Columnas `author_contact_id` agregadas a `articles` y `special_articles`
- ✅ Contacto por defecto de Julio Cesar Rojas Cala insertado
- ✅ Políticas RLS configuradas

## 🎯 NUEVAS FUNCIONALIDADES:

### ✅ Sistema de Contactos:
- ➕ **Crear contactos** con foto, nombre, email, LinkedIn, Instagram
- ✏️ **Editar contactos** existentes
- 🔗 **Vincular autores** con contactos existentes
- 👀 **Enlaces clickeables** desde artículos a perfiles de contacto

### ✅ Panel de Admin Mejorado:
- 📋 **Nueva pestaña "Contactos"** para gestionar autores
- 🔗 **Selector de autor** en formularios de artículos
- ✍️ **Opción de autor personalizado** sin crear contacto
- 📧 **Indicador visual** cuando un autor está vinculado

### ✅ Frontend Actualizado:
- 🔗 **Enlaces de autor** clickeables en artículos
- 📄 **Página de contacto** mejorada con múltiples contactos
- 👤 **Perfiles de autor** con redes sociales

## 🔧 DESPUÉS DE EJECUTAR EL SCRIPT:

1. **Ve al Panel de Admin** → Pestaña "Contactos"
2. **Verifica** que Julio Cesar Rojas Cala aparezca como contacto
3. **Crea artículos** y selecciona autores existentes o escribe nombres personalizados
4. **Haz clic** en nombres de autores en artículos para ir a sus perfiles

## 📞 SOPORTE
Si tienes problemas ejecutando el script, avísame y te ayudo paso a paso.