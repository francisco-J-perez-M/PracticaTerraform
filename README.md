# Azure Infrastructure as Code (IaC) con Terraform

Este proyecto documenta el despliegue de infraestructura en la nube de **Microsoft Azure** utilizando Terraform y aplicando buenas prácticas de arquitectura modular.

---

## Prerrequisitos e Instalación

Para ejecutar cualquiera de las prácticas, asegúrate de contar con los siguientes componentes instalados y configurados:

* **Terraform CLI** (v1.0+)
* **Azure CLI** (`az`)
* Una **suscripción activa de Azure** (Estudiantil / Pass)
* **Visual Studio Code**
* Extensión de **Terraform para Visual Studio Code**

---

## Inicio de Sesión en Azure CLI

Antes de desplegar cualquier entorno, autentícate en tu cuenta de Azure:

```powershell
az login
```

Puedes comprobar la suscripción activa con:

```powershell
az account show
```

---

## Estructura del Repositorio

```text
.
├── LAB2/                 # Práctica 2: Estructura Modular (VNet & RG)
├── tercer-programa/      # Práctica 3: Web App QA con Monitoreo
├── main.tf               # Práctica 1 / Pruebas iniciales en raíz
├── variables.tf          # Declaración de variables globales
├── providers.tf          # Configuración de proveedores de Azure
├── outputs.tf            # Salidas principales
└── README.md             # Documentación del repositorio
```

---

# Guía de Comandos y Flujo de Trabajo

## 1. Navegación al Directorio

Ingresa a la carpeta correspondiente a la práctica que deseas ejecutar.

### Lab 2

```powershell
cd LAB2
```

### Tercer Programa — QA Web App

```powershell
cd tercer-programa
```

---

## 2. Ciclo de Vida de Terraform

Sigue la siguiente secuencia para inicializar, validar, planificar y desplegar la infraestructura.

### Paso A: Inicialización

Descarga los proveedores y dependencias requeridas, como `azurerm`:

```powershell
terraform init
```

### Paso B: Validación Sintáctica

Verifica que el código HCL no contenga errores de sintaxis o referencias incorrectas:

```powershell
terraform validate
```

### Paso C: Planificación del Despliegue

Muestra una vista previa de los recursos que Terraform creará, modificará o eliminará:

```powershell
terraform plan
```

### Paso D: Aplicar Cambios

Crea o modifica la infraestructura en Azure.

Con confirmación manual:

```powershell
terraform apply
```

Despliegue automático sin solicitar confirmación:

```powershell
terraform apply -auto-approve
```

Se recomienda utilizar `terraform plan` antes de ejecutar `terraform apply` para revisar los cambios que se realizarán.

### Paso E: Destrucción de Recursos

Para eliminar todos los recursos creados por Terraform y evitar el consumo innecesario de créditos de Azure:

```powershell
terraform destroy -auto-approve
```

Este comando elimina los recursos administrados por el proyecto. Utilízalo únicamente cuando estés seguro de que ya no necesitas la infraestructura.

---

# Prácticas Incluidas

## LAB2 — Módulo Base de Red

### Recursos creados

* **Grupo de Recursos**

  * `azurerm_resource_group`
* **Red Virtual**

  * `azurerm_virtual_network`

### Conceptos utilizados

* Estructura modular de Terraform.
* Nomenclatura estandarizada mediante `locals.tf`.
* Inyección de parámetros mediante `terraform.tfvars`.
* Declaración y utilización de variables.
* Manejo de variables sensibles mediante:

```hcl
sensitive = true
```

### Objetivo

Implementar una infraestructura base en Azure utilizando Terraform, aplicando una estructura organizada y reutilizable para la creación de recursos de red.

---

# Tercer Programa — Entorno QA con Monitoreo

Esta práctica implementa un entorno **QA (Quality Assurance)** en Azure para una aplicación web Node.js, incluyendo herramientas de monitoreo y telemetría.

## Recursos creados

| Recurso                 | Nombre                                |
| ----------------------- | ------------------------------------- |
| Resource Group          | `rg-utvt-qa-mxc-001`                  |
| Log Analytics Workspace | `log-utvt-qa-mxc-001`                 |
| Application Insights    | `appi-utvt-qa-mxc-001`                |
| App Service Plan Linux  | `asp-utvt-qa-mxc-001`                 |
| Linux Web App           | `app-utvt-integradora-web-qa-mxc-001` |

### Tecnologías utilizadas

* Microsoft Azure
* Terraform
* Azure App Service
* Linux
* Node.js 20 LTS
* Application Insights
* Log Analytics

### Conceptos implementados

* Telemetría centralizada.
* Monitoreo de aplicaciones.
* Integración entre **Application Insights** y **Log Analytics**.
* Vinculación de cadenas de conexión.
* Configuración de aplicaciones web Linux.
* Políticas de seguridad HTTPS/TLS.
* Despliegue de aplicaciones Node.js 20 LTS.

---

# Flujo de Trabajo Recomendado

Para cada práctica se recomienda seguir el siguiente flujo:

```text
┌─────────────────┐
│    terraform    │
│      init       │
└────────┬────────┘
         ↓
┌─────────────────┐
│    terraform    │
│     validate    │
└────────┬────────┘
         ↓
┌─────────────────┐
│    terraform    │
│      plan       │
└────────┬────────┘
         ↓
┌─────────────────┐
│    terraform    │
│      apply      │
└────────┬────────┘
         ↓
┌─────────────────┐
│ Recursos Azure  │
│    creados      │
└─────────────────┘
```

Cuando la práctica haya terminado:

```powershell
terraform destroy -auto-approve
```

---

# Convención de Commits

En este repositorio se utiliza una convención basada en **Conventional Commits**, adaptada al español.

### Agregar cambios

```powershell
git add .
```

### Crear commit

```powershell
git commit -m "caracteristica(modulo): descripcion clara del cambio"
```

### Enviar cambios al repositorio

```powershell
git push origin main
```

---

## Tipos de Commit

### `caracteristica(lab)`

Utilizado para nuevas funcionalidades o recursos creados en Terraform.

Ejemplo:

```powershell
git commit -m "caracteristica(lab): agregar red virtual para LAB2"
```

### `tarea(config)`

Utilizado para cambios en archivos de configuración o `.gitignore`.

Ejemplo:

```powershell
git commit -m "tarea(config): actualizar variables de Azure"
```

### `documentacion(raiz)`

Utilizado para modificaciones en el `README.md` o reportes.

Ejemplo:

```powershell
git commit -m "documentacion(raiz): actualizar guia de despliegue"
```

---

# Buenas Prácticas

Para evitar problemas durante el desarrollo:

* No subir credenciales de Azure al repositorio.
* No almacenar secretos directamente en archivos `.tf`.
* Utilizar variables para los parámetros configurables.
* Utilizar `sensitive = true` para información sensible.
* Revisar siempre `terraform plan` antes de aplicar cambios.
* Utilizar `.gitignore` para archivos generados por Terraform.
* Destruir los recursos de prueba cuando ya no sean necesarios.
* Mantener separados los diferentes entornos y prácticas.
* Utilizar nombres consistentes para los recursos de Azure.

---

# Tecnologías

| Tecnología           | Uso                                    |
| -------------------- | -------------------------------------- |
| Terraform            | Infraestructura como Código            |
| Microsoft Azure      | Proveedor de infraestructura Cloud     |
| Azure CLI            | Administración de Azure desde terminal |
| HCL                  | Lenguaje utilizado por Terraform       |
| Node.js              | Aplicación web del entorno QA          |
| Application Insights | Monitoreo y telemetría                 |
| Log Analytics        | Análisis centralizado de registros     |
| Git                  | Control de versiones                   |
| Visual Studio Code   | Entorno de desarrollo                  |

---

## Autor

**Francisco Jesús Pérez Medina**

Universidad Tecnológica del Valle de Toluca (UTVT)

 
