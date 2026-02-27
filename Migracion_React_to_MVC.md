# Plan de Acción: Migración de Funcionalidad React a ASP.NET Core MVC

El objetivo de este plan es detallar los pasos para migrar las vistas y la lógica del cliente web que actualmente está desarrollado en **React (Vite)** (dentro de la carpeta `api-backend/client`) hacia el proyecto **ASP.NET Core MVC** (`ApiClient`).

Ambos clientes consumirán la misma API backend en Node.js, pero la interfaz de usuario y las llamadas a la red se manejarán de manera centralizada en C#.

---

## 🏗️ Fase 1: Arquitectura Base y Autenticación en C#

1. **Configuración del `HttpClient` y Servicios Centrales:**
   * Crear un servicio base en `ApiClient/Services` para manejar las peticiones HTTP (GET, POST, PUT, DELETE) hacia el backend Node.js (`http://localhost:3000/api/v1/...`).
   * Configurar `Program.cs` para inyectar la URL base de la base API desde `appsettings.json`.

2. **Migración del Login (Autenticación):**
   * Migrar la lógica de `Login.jsx` a `AuthController.cs` y su vista `Login.cshtml`.
   * En C#, al recibir el JWT desde Node.js, validarlo y almacenarlo en la sesión del usuario (`ISession`) o mejor aún, mediante **Cookies de Autenticación** (`CookieAuthenticationDefaults`).
   * Implementar un mecanismo (`DelegatingHandler` o paso del token explícito) para que todos los `HttpClient` adjunten el token `Bearer` en los *Headers* de las solicitudes futuras.

3. **Layout Principal y Navegación (Sidebar):**
   * Trasladar el cascarón visual del `Dashboard.jsx` (Sidebar, Topbar) hacia el archivo `_Layout.cshtml` dentro de `Views/Shared`.
   * Sustituir los íconos de *Lucide React* por iconos vectoriales similares (como FontAwesome, Heroicons SVG puros o Bootstrap Icons).
   * Implementar el cierre de sesión destruyendo la cookie/sesión en C# y redirigiendo a la pantalla de Login.

---

## 📊 Fase 2: Migración del Dashboard (Vista Resumen)

1. **Servicio y Modelo de Dashboard:**
   * Usar el servicio ya creado `DashboardService.cs` y completar el modelo `DashboardStatsViewModel.cs` para recibir los KPIs y la lista de "Próximos Eventos".
2. **Controlador:**
   * En `DashboardController.cs`, consultar la ruta `/api/v1/dashboard/stats`, mapear el JSON al modelo `DashboardStatsViewModel` y pasárselo a la vista.
3. **Vista (View):**
   * Pasar la estructura HTML y clases Tailwind de la pestaña _Dashboard_ (del antiguo `Dashboard.jsx`) al archivo `Views/Dashboard/Index.cshtml`.
   * *Opcional:* Reemplazar los gráficos de **Recharts** por una librería cliente (ej. **Chart.js** o **ApexCharts**) inyectando la data desde el modelo de C# hacia un `<canvas>`.

---

## ⚙️ Fase 3: Migración de Módulos CRUD (Catálogos y Gestiones)

Esta fase es repetitiva pero estructurada para todos los módulos existentes (`Eventos`, `Facilitadores`, `Salones`, `Participantes`, `Inscripciones`, `Asistencia`, `Usuarios`, `Alertas`, `Configuración`).

**Por cada módulo:**

1. **Modelos (C#):**
   * Crear los ViewModels necesarios (ej. `EventoViewModel`, `EventoFormViewModel` que incluya catálogos como Salones o Facilitadores para los `select`).

2. **Servicios HTTP (C#):**
   * Crear un servicio (ej. `EventosService.cs`) encapsulando los endpoints: `GET /eventos`, `POST /eventos`, `PUT /eventos/{id}`, `DELETE /eventos/{id}`, y la obtención de catálogos (`/catalogos/tipos`, `/catalogos/modalidades`, etc.).

3. **Controladores:**
   * Crear un controlador (ej. `EventosController.cs`) con métodos:
     * `Index()`: Consulta el servicio y retorna la vista con la tabla de datos.
     * `Create() / Create(POST)`: Obtiene catálogos para llenar los dropdowns en GET, e invoca al servicio POST para guardar el dato.
     * `Edit(id) / Edit(POST)`: Obtiene datos del elemento y envía los cambios.
     * `Delete(id)`: Invoca al endpoint DELETE y redirige.

4. **Vistas (`.cshtml`):**
   * **Index.cshtml:** Migrar el HTML de la tabla o tarjetas usando *Razor* (`@foreach(var item in Model) { ... }`).
   * **_CreateOrEditModal.cshtml** (O Vistas Separadas): En C# MVC, lo ideal es usar Partial Views impulsadas por JS/HTMX para simular el comportamiento *Modal*, o bien llevar al usuario a una página entera `.cshtml` dedicada al formulario. 
   * Trasladar todas las clases Tailwind del respectivo archivo `.jsx` a la vista Razor.

---

## 🚀 Fase 4: Refinamiento, Alertas y Despliegue

1. **Feedback UI y Validaciones:**
   * Utilizar `TempData["SuccessMessage"]` o `TempData["ErrorMessage"]` y mostrarlos globalmente a través de notificaciones "Toast" (ej. SweetAlert2 o Toastr) en el `_Layout.cshtml`.
   * Añadir Data Annotations (`[Required]`, `[StringLength]`) en los Modelos de C# para aplicar validación en el servidor y validación *Client-Side* de jQuery (incluida en ASP.NET MVC).
2. **Limpieza del Proyecto React:**
   * Una vez certificada la funcionalidad total de `ApiClient`, se puede eliminar la carpeta `client` (React) dentro de `api-backend`, dejando a Node.js operando estrictamente como API pura.
3. **Pase a Producción y Servidor (IIS):**
   * Aplicar la publicación `dotnet publish` de la carpeta `ApiClient`.
   * Reflejar los bindings y proxy en IIS, configurando que el tráfico normal llegue a la aplicación .NET y el cliente ASP.NET consuma la API expuesta por PM2.
