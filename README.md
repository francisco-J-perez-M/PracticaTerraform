# Azure Infrastructure as Code (IaC) con Terraform

Este proyecto documenta el despliegue de infraestructura en la nube de **Microsoft Azure** utilizando Terraform y aplicando buenas prácticas de arquitectura modular y patrones de seguridad enterprise.

---

## Prerrequisitos e Instalación

Para ejecutar cualquiera de las prácticas, asegúrate de contar con los siguientes componentes instalados y configurados:

- **Terraform CLI** (v1.0+)
- **Azure CLI** (`az`)
- Una **suscripción activa de Azure** (Estudiantil / Pass)
- **Visual Studio Code**
- Extensión de **Terraform para Visual Studio Code**

---

## Inicio de Sesión en Azure CLI

Antes de desplegar cualquier entorno, autentícate en tu cuenta de Azure:

```powershell
az login
Puedes comprobar la suscripción activa con:PowerShellaz account show
Estructura del RepositorioPlaintext.
├── LAB2/                 # Práctica 2: Estructura Modular (VNet & RG)
├── tercer-programa/      # Práctica 3: Web App QA con Monitoreo
├── Terraform4/           # Práctica 4: Landing Zone Well-Architected (PaaS Privado, Endpoints & Bastion)
├── main.tf               # Práctica 1 / Pruebas iniciales en raíz
├── variables.tf          # Declaración de variables globales
├── providers.tf          # Configuración de proveedores de Azure
├── outputs.tf            # Salidas principales
├── .gitignore            # Archivos excluidos de Git
└── README.md             # Documentación del repositorio
Guía de Comandos y Flujo de TrabajoNavegación al DirectorioIngresa a la carpeta correspondiente a la práctica que deseas ejecutar.Lab 2PowerShellcd LAB2
Tercer Programa — QA Web AppPowerShellcd tercer-programa
Práctica 4 — Landing Zone & Well-ArchitectedPowerShellcd Terraform4
2. Ciclo de Vida de TerraformSigue la siguiente secuencia para inicializar, validar, planificar y desplegar la infraestructura.Paso A: InicializaciónDescarga los proveedores y dependencias requeridas, como azurerm:PowerShellterraform init
Paso B: Validación SintácticaVerifica que el código HCL no contenga errores de sintaxis o referencias incorrectas:PowerShellterraform validate
Paso C: Planificación del DespliegueMuestra una vista previa de los recursos que Terraform creará, modificará o eliminará:PowerShellterraform plan
Paso D: Aplicar CambiosCrea o modifica la infraestructura en Azure.Con confirmación manual:PowerShellterraform apply
Despliegue automático sin solicitar confirmación:PowerShellterraform apply -auto-approve
Se recomienda utilizar terraform plan antes de ejecutar terraform apply para revisar los cambios que se realizarán.Paso E: Destrucción de RecursosPara eliminar todos los recursos creados por Terraform y evitar el consumo innecesario de créditos de Azure:PowerShellterraform destroy -auto-approve
Este comando elimina los recursos administrados por el proyecto. Utilízalo únicamente cuando estés seguro de que ya no necesitas la infraestructura.Prácticas IncluidasLAB2 — Módulo Base de RedRecursos creadosGrupo de Recursosazurerm_resource_groupRed Virtualazurerm_virtual_networkConceptos utilizadosEstructura modular de Terraform.Nomenclatura estandarizada mediante locals.tf.Inyección de parámetros mediante terraform.tfvars.Declaración y utilización de variables.Manejo de variables sensibles mediante:Terraformsensitive = true
ObjetivoImplementar una infraestructura base en Azure utilizando Terraform, aplicando una estructura organizada y reutilizable para la creación de recursos de red.Tercer Programa — Entorno QA con MonitoreoEsta práctica implementa un entorno QA (Quality Assurance) en Azure para una aplicación web Node.js, incluyendo herramientas de monitoreo y telemetría.Recursos creadosRecursoNombreResource Grouprg-utvt-qa-mxc-001Log Analytics Workspacelog-utvt-qa-mxc-001Application Insightsappi-utvt-qa-mxc-001App Service Plan Linuxasp-utvt-qa-mxc-001Linux Web Appapp-utvt-integradora-web-qa-mxc-001Tecnologías utilizadasMicrosoft AzureTerraformAzure App ServiceLinuxNode.js 20 LTSApplication InsightsLog AnalyticsConceptos implementadosTelemetría centralizada.Monitoreo de aplicaciones.Integración entre Application Insights y Log Analytics.Vinculación de cadenas de conexión.Configuración de aplicaciones web Linux.Políticas de seguridad HTTPS/TLS.Despliegue de aplicaciones Node.js 20 LTS.Terraform4 — Landing Zone Well-Architected (PaaS Privado, Endpoints & Bastion)Esta práctica implementa una arquitectura Landing Zone bajo el marco de Azure Well-Architected Framework, aislando el tráfico PaaS de la red pública e implementando acceso remoto seguro a través de bastiones de salto.Recursos creadosRecursoNombre / TipoSubred / ConfiguraciónVirtual Networkvnet-lz-prod (10.0.0.0/16)5 Subredes dedicadas (snet-app, snet-db, snet-vm, snet-endpoints, AzureBastionSubnet)App Service Linuxapp-lz-prod-* (B1)VNet Swift Integration en snet-app (10.0.1.0/24)Worker Linux VMvm-worker-prod (Standard_B2ats_v2)Interfaz en snet-vm (10.0.3.0/24)PostgreSQL Serverpsql-lz-prod-* (Flexible B1ms)Acceso público deshabilitadoStorage Accountstlzprod* (Blob Standard LRS)Acceso público deshabilitadoPrivate Endpointspe-postgresql, pe-blobIPs en snet-db y snet-endpointsPrivate DNS Zonesprivatelink.postgres..., privatelink.blob...Enlazadas a vnet-lz-prodAzure Bastion Hostbastion-lz-prodIP Pública dedicada en AzureBastionSubnetConceptos e innovaciones implementadasAislamiento de red (PaaS Privado): Bloqueo total de tráfico público hacia la base de datos PostgreSQL y la cuenta de almacenamiento Blob.Private Link & Private DNS: Resolución e interconexión privada mediante Private Endpoints e integración con zonas DNS privadas.Acceso seguro (Zero Public IP para Cómputo): Administración SSH hacia la Worker VM a través de Azure Bastion en el puerto 22 sin exponer direcciones públicas en la VM.Identidad Administrada (Managed Identity): Asignación de identidades del sistema (System-Assigned Managed Identity) en App Service y Worker VM para autenticación segura en Microsoft Entra ID.Flujo de Trabajo RecomendadoPara cada práctica se recomienda seguir el siguiente flujo:Plaintext┌─────────────────┐
│    terraform    │
│      init       │
└────────┬────────┘
         ↓
┌─────────────────┐
│    terraform    │
│    validate     │
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
│     creados     │
└─────────────────┘
Cuando la práctica haya terminado:PowerShellterraform destroy -auto-approve