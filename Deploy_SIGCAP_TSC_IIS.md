# Guía de Compilación y Publicación: SIGCAP-TSC (ASP.NET Core 8 MVC)

**Objetivo:** Compilar y publicar la aplicación SIGCAP-TSC en un servidor Windows Server 2022 con IIS, en ambiente de **desarrollo (dev)**.

---

## 🏗️ 1. Requisitos Previos en el Servidor

### Software necesario
| Componente | Detalle |
|---|---|
| **Windows Server 2022** | Con IIS habilitado |
| **.NET 8.0 Hosting Bundle** | Descargar desde [dotnet.microsoft.com](https://dotnet.microsoft.com/download/dotnet/8.0) → sección "ASP.NET Core Runtime" → **Hosting Bundle (Windows)** |
| **IIS** | Habilitado con módulo `AspNetCoreModuleV2` (se instala automáticamente con el Hosting Bundle) |

> ⚠️ **IMPORTANTE:** Después de instalar el .NET 8 Hosting Bundle, **reiniciar IIS** ejecutando en CMD como administrador:
> ```cmd
> net stop was /y
> net start w3svc
> ```

### Verificar instalación del módulo ASP.NET Core en IIS
Abrir IIS Manager → clic en el servidor → abrir **Módulos** → verificar que aparece `AspNetCoreModuleV2`.

---

## 📦 2. Compilación y Publicación (Desde tu máquina de desarrollo)

### 2.1 Configurar la URL del API para el ambiente DEV

Editar `appsettings.json` (o crear `appsettings.Development.json`) para que apunte al backend del servidor:

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*",
  "ApiSettings": {
    "BaseUrl": "http://IP_DEL_SERVIDOR:3000/api/v1/"
  }
}
```

> 📝 Reemplazar `IP_DEL_SERVIDOR` con la IP real o `localhost` si el API Node.js corre en el mismo servidor.

### 2.2 Compilar y Publicar

Abrir una terminal en la carpeta del proyecto `sigcap-tsc` y ejecutar:

```powershell
# Publicar como self-contained para Windows x64
dotnet publish -c Release -r win-x64 --self-contained true -o ./publish
```

**Opciones explicadas:**

| Parámetro | Descripción |
|---|---|
| `-c Release` | Compilación en modo Release (optimizada) |
| `-r win-x64` | Runtime target: Windows 64-bit |
| `--self-contained true` | Incluye el runtime de .NET (no requiere .NET instalado en servidor) |
| `-o ./publish` | Carpeta de salida |

> 💡 **Alternativa: Framework-dependent** (requiere .NET 8 Runtime en el servidor pero el paquete es más pequeño):
> ```powershell
> dotnet publish -c Release -r win-x64 --self-contained false -o ./publish
> ```
> En este caso **sí necesitas** tener el .NET 8 Hosting Bundle instalado en el servidor.

### 2.3 Verificar los archivos publicados

La carpeta `./publish` debe contener:
- `SIGCAP-TSC.exe` (ejecutable principal)
- `SIGCAP-TSC.dll`
- `web.config` (generado automáticamente)
- `appsettings.json` y `appsettings.Development.json`
- `wwwroot/` (archivos estáticos: CSS, JS, imágenes)
- Demás DLLs de dependencias

---

## 🚀 3. Despliegue en el Servidor (Windows Server 2022 + IIS)

### 3.1 Copiar archivos al servidor

1. Crear la carpeta destino en el servidor:
   ```cmd
   mkdir C:\apps\SIGCAP_TSC
   ```
2. Copiar **todo el contenido** de la carpeta `./publish` a `C:\apps\SIGCAP_TSC\`.

### 3.2 Configurar permisos

1. Clic derecho en `C:\apps\SIGCAP_TSC` → **Propiedades** → **Seguridad** → **Editar** → **Agregar**.
2. Agregar al usuario `IIS_IUSRS` con permisos de **Lectura y ejecución**.
3. Agregar al usuario `IUSR` con permisos de **Lectura y ejecución**.

### 3.3 Configurar el `web.config` para ambiente DEV

Editar `C:\apps\SIGCAP_TSC\web.config` para habilitar logs de stdout (útil en desarrollo):

```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <location path="." inheritInChildApplications="false">
    <system.webServer>
      <handlers>
        <add name="aspNetCore" path="*" verb="*" modules="AspNetCoreModuleV2" resourceType="Unspecified" />
      </handlers>
      <aspNetCore processPath=".\SIGCAP-TSC.exe"
                  stdoutLogEnabled="true"
                  stdoutLogFile=".\logs\stdout"
                  hostingModel="inprocess">
        <environmentVariables>
          <environmentVariable name="ASPNETCORE_ENVIRONMENT" value="Development" />
        </environmentVariables>
      </aspNetCore>
    </system.webServer>
  </location>
</configuration>
```

> 🔑 **Puntos clave:**
> - `stdoutLogEnabled="true"` → Habilita logs de consola (crear la carpeta `logs` manualmente).
> - `ASPNETCORE_ENVIRONMENT=Development` → Activa el perfil de desarrollo (usa `appsettings.Development.json` y muestra errores detallados).
> - `hostingModel="inprocess"` → Más rápido, corre dentro del proceso de IIS.

**Crear la carpeta de logs:**
```cmd
mkdir C:\apps\SIGCAP_TSC\logs
```

### 3.4 Crear el Sitio en IIS

1. Abrir **IIS Manager** (`inetmgr`).
2. **Crear un nuevo Application Pool:**
   - Clic derecho en **Application Pools** → **Add Application Pool...**
   - **Nombre:** `SIGCAP_TSC_Pool`
   - **.NET CLR version:** `No Managed Code` ⚠️ (ASP.NET Core no usa el CLR clásico)
   - **Pipeline:** `Integrated`
   - Clic en **OK**.
3. **Crear el sitio web:**
   - Clic derecho en **Sites** → **Add Website...**
   - **Site name:** `SIGCAP_TSC_DEV`
   - **Application pool:** `SIGCAP_TSC_Pool`
   - **Physical path:** `C:\apps\SIGCAP_TSC`
   - **Binding:**
     - Type: `http`
     - IP Address: `All Unassigned`
     - Port: `8080` (o el puerto que desees para dev)
     - Host name: (dejar vacío para dev)
   - Clic en **OK**.

### 3.5 Configurar el Application Pool (Avanzado)

1. Seleccionar `SIGCAP_TSC_Pool` → **Advanced Settings...**
2. Verificar:
   - **Start Mode:** `OnDemand` (o `AlwaysRunning` si deseas que arranque con el servidor)
   - **Identity:** `ApplicationPoolIdentity` (por defecto, está bien para dev)

---

## ✅ 4. Verificación

### 4.1 Probar el sitio

1. Abrir un navegador en el servidor.
2. Navegar a: `http://localhost:8080`.
3. Debería cargar la página de login de SIGCAP-TSC (`/Auth/Login`).

### 4.2 Si hay errores

1. **Revisar los logs de stdout:**
   ```cmd
   dir C:\apps\SIGCAP_TSC\logs\
   type C:\apps\SIGCAP_TSC\logs\stdout_XXXXXXXX.log
   ```

2. **Revisar el Event Viewer:**
   - Abrir Event Viewer → Windows Logs → Application
   - Filtrar por fuente `IIS AspNetCore Module`

3. **Errores comunes:**

   | Error | Causa | Solución |
   |---|---|---|
   | **HTTP 500.30** | La app no arranca | Revisar logs stdout, verificar `appsettings.json` |
   | **HTTP 502.5** | Fallo del proceso | Falta el .NET Runtime o Hosting Bundle |
   | **HTTP 500.19** | Error en `web.config` | Verificar sintaxis XML |
   | **La API no responde** | URL del backend incorrecta | Verificar `ApiSettings:BaseUrl` en `appsettings.json` |

---

## 🔄 5. Actualización (Re-despliegue)

Para publicar una nueva versión:

1. **Compilar** nuevamente en tu máquina de desarrollo:
   ```powershell
   dotnet publish -c Release -r win-x64 --self-contained true -o ./publish
   ```

2. **Detener el sitio en IIS** antes de copiar archivos:
   - IIS Manager → Seleccionar `SIGCAP_TSC_DEV` → clic en **Stop** (panel derecho).

3. **Copiar** los archivos nuevos a `C:\apps\SIGCAP_TSC\` (sobreescribir todo excepto `appsettings.json` si tiene configuración específica del servidor).

4. **Iniciar** el sitio nuevamente:
   - IIS Manager → Seleccionar `SIGCAP_TSC_DEV` → clic en **Start**.

---

## 📋 Resumen Rápido de Comandos

```powershell
# === En tu máquina de desarrollo ===

# 1. Compilar y publicar
cd C:\Users\jhmedina\Documents\26\Proyectos\SIGEM\sigcap-tsc
dotnet publish -c Release -r win-x64 --self-contained true -o ./publish

# 2. Copiar la carpeta ./publish al servidor (usar RDP, compartir red, etc.)


# === En el servidor ===

# 3. Crear carpeta y copiar archivos
mkdir C:\apps\SIGCAP_TSC
# (pegar aquí el contenido de ./publish)

# 4. Crear carpeta de logs
mkdir C:\apps\SIGCAP_TSC\logs

# 5. Reiniciar IIS después de configurar
iisreset
```
