# Guía de Despliegue en IIS: Frontend (React) y Backend (Node.js)

Esta guía detalla los pasos necesarios para desplegar la aplicación web (dividida en un Frontend construido con React y un Backend construido en Node.js) en un servidor Windows utilizando **Internet Information Services (IIS)**.

---

## 🏗️ Requisitos Previos en el Servidor (Para el Administrador MTI)

Instalar los siguientes componentes en el servidor antes de proceder con el despliegue:

1.  **Internet Information Services (IIS)**
    *   Habilitado desde "Activar o desactivar las características de Windows" (o Server Manager).
    *   Habilitar los módulos básicos de servicio web.
2.  **Node.js**
    *   Descargar e instalar la versión LTS actual desde el sitio oficial de Node.js.
3.  **Módulos de IIS adicionales (CRÍTICOS para Node.js y React)**
    *   **URL Rewrite:** Necesario para que React maneje las rutas del cliente (SPA) y para actuar como proxy hacia el backend. [Descargar URL Rewrite](https://www.iis.net/downloads/microsoft/url-rewrite)
    *   **Application Request Routing (ARR) 3.0:** Necesario para que IIS funcione como un Proxy Inverso (Reverse Proxy) y envíe las peticiones API al servidor Node.js. [Descargar ARR 3.0](https://www.iis.net/downloads/microsoft/application-request-routing)
    *   ***Importante:*** Tras instalar ARR, abrir IIS > hacer clic en el Servidor > abrir **Application Request Routing Cache** > clic en **Server Proxy Settings** (panel derecho) > Marcar la casilla **Enable proxy** > Aplicar.
4.  **PM2 (Gestor de procesos para Node.js)**
    *   Instalar globalmente usando npm (desde una consola como administrador):
        ```cmd
        npm install -g pm2
        npm install -g pm2-windows-startup
        pm2-startup install
        ```

---

## 📦 1. Preparación de los Archivos (Entorno de Desarrollo)

Antes de entregar los archivos al servidor, el equipo de desarrollo debe prepararlos.

### 1.1 Backend (Node.js)
1.  Asegurarse de que el archivo `.env` o la configuración del servidor apunte a la base de datos de producción y use el puerto correcto (ej. `PORT=5000`).
2.  Entregar la carpeta completa del backend `api-backend`, **excluyendo** la carpeta `node_modules`.

### 1.2 Frontend (React / Vite)
1.  En el proyecto `client`, asegúrese de que la URL base de la API apunte a la URL de producción (ej. `https://midominio.com/api`).
2.  Ejecutar el comando de construcción:
    ```bash
    npm run build
    ```
3.  Entregar el contenido de la carpeta generada (generalmente llamada `dist` o `build`).

---

## 🚀 2. Despliegue en el Servidor

### 2.1 Despliegue del Backend (Node.js)

1.  **Crear Carpeta:** Crear una carpeta en el servidor, por ejemplo `C:\apps\SIGEM_Backend`.
2.  **Copiar Archivos:** Pegar allí los archivos del backend (sin `node_modules`).
3.  **Instalar Dependencias:**
    *   Abrir una terminal en esa carpeta y ejecutar:
        ```cmd
        npm install
        ```
4.  **Iniciar con PM2:**
    *   Ejecutar el archivo principal (ajustar `index.js` o `server.js` según corresponda):
        ```cmd
        pm2 start src/index.js --name "SIGEM_Backend"
        pm2 save
        ```
    *   El backend ahora estará corriendo en segundo plano (por ejemplo, en `http://localhost:5000`).

### 2.2 Despliegue del Frontend (React) en IIS

1.  **Crear Carpeta Base:** Crear una carpeta para el sitio web, por ejemplo: `C:\inetpub\wwwroot\SIGEM`.
2.  **Copiar Archivos:** Pegar el contenido de la carpeta `dist` (el build de React) dentro de `C:\inetpub\wwwroot\SIGEM`.
3.  **Otorgar Permisos:**
    *   Clic derecho en la carpeta `SIGEM` > Propiedades > Seguridad > Editar > Agregar.
    *   Agregar a `IIS_IUSRS` con permisos de "Lectura y ejecución".
4.  **Crear el Sitio en IIS:**
    *   Abrir el Administrador de IIS.
    *   Clic derecho en **Sitios** > **Agregar sitio web**.
    *   **Nombre:** SIGEM_Frontend
    *   **Ruta de acceso física:** `C:\inetpub\wwwroot\SIGEM`
    *   **Puerto/Binding:** Asignar el puerto deseado (ej. 80 para HTTP, o 443 con certificado para HTTPS).
5.  **Configurar Reglas de Enrutamiento (URL Rewrite) para React y la API:**
    *   Crear un archivo llamado `web.config` en la raíz de la carpeta física (`C:\inetpub\wwwroot\SIGEM`) con el siguiente contenido:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <system.webServer>
        <rewrite>
            <rules>
                <!-- Regla 1: Redirigir peticiones /api al backend Node.js -->
                <rule name="ReverseProxyToNodeAPI" stopProcessing="true">
                    <match url="^api/(.*)" />
                    <action type="Rewrite" url="http://localhost:5000/api/{R:1}" />
                </rule>

                <!-- Regla 2: React Router (Redirigir todo lo demás a index.html) -->
                <rule name="ReactRouter Routes" stopProcessing="true">
                    <match url=".*" />
                    <conditions logicalGrouping="MatchAll">
                        <add input="{REQUEST_FILENAME}" matchType="IsFile" negate="true" />
                        <add input="{REQUEST_FILENAME}" matchType="IsDirectory" negate="true" />
                        <!-- Ignorar peticiones que empiecen con /api para que las tome la Regla 1 -->
                        <add input="{REQUEST_URI}" pattern="^/api" negate="true" />
                    </conditions>
                    <action type="Rewrite" url="/index.html" />
                </rule>
            </rules>
        </rewrite>
    </system.webServer>
</configuration>
```
*(Nota: Ajustar el puerto de la Regla 1, `http://localhost:5000`, al puerto en el que esté corriendo Node.js mediante PM2).*

---

## ✅ 3. Verificación
1. **Frontend:** Abrir un navegador e ir al dominio o IP configurado en IIS. Debería cargar la interfaz de React. Navegar entre vistas para asegurar que React Router funciona (si recargas la página en `/configuracion`, no debería dar error 404).
2. **Backend:** Intentar iniciar sesión o realizar una acción que consuma la API. IIS interceptará la ruta `/api/...` y la enviará transparentemente a la aplicación Node.js corriendo en segundo plano.
