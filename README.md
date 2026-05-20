# Innovatech_Chile
# Terraform AWS Infrastructure - Innovatech Chile

## Descripción
Infraestructura optimizada y automatizada gestionada con Terraform para desplegar la plataforma de Innovatech Chile siguiendo buenas prácticas de arquitectura y seguridad (DevSecOps):

* **VPC Personalizada:** Red aislada global para mitigar el radio de impacto de posibles ataques.
* **Separación de Entornos (Instancias EC2 independientes):** Una máquina virtual dedicada exclusivamente al Frontend y otra instancia de mayor rendimiento destinada al Backend (Microservicios + Base de datos).
* **NAT Gateway / Internet Gateway:** Configuración estricta de enrutamiento para permitir tráfico saliente seguro y control de peticiones entrantes.
* **Seguridad Perimetral Exclusiva (Security Groups):** Reglas estrictas que aíslan la base de datos y los microservicios de backend, permitiendo tráfico entrante únicamente desde el Security Group del Frontend.
* **Persistencia de Datos:** Arquitectura preparada para el acoplamiento de Docker Compose mediante volúmenes locales en el servidor de datos.

---

## 🗺️ Estructura del proyecto

```text
innovatech-chile-infra/
├── .gitignore
├── README.md
└── infra/
    ├── etapa_1/
    │   ├── main.tf
    │   └── outputs.tf
    └── etapa_2/
        ├── main.tf
        └── outputs.tf


🚀 Requisitos previos
Terraform CLI versión >= 1.0

AWS CLI instalado y configurado o variables de entorno temporales de AWS Academy.

Llave privada SSH compatible (vockey) disponible en el proveedor.


## ⚙️ Flujo de uso

1. Clona el repositorio.
2. Inicializa Terraform:

```
terraform init
```
Verifica el plan:
```
terraform plan
```
Aplica los cambios:
```
terraform apply


📦¿Qué despliega este proyecto?
Módulo de Red y Conectividad: Diseña la VPC, subredes públicas y pasarelas de red (Internet Gateway / NAT Gateway) para garantizar la alta disponibilidad y la salida segura a internet de los servidores internos.

Módulo de Cómputo y Seguridad: Despliega servidores virtuales dedicados (EC2 Linux) aprovisionando llaves SSH públicas y enlazando Security Groups herméticos que bloquean de forma nativa puertos críticos como el 3306 (MySQL) y los puertos lógicos del backend.

Interconexión Dinámica: Gestiona la transferencia de datos entre etapas mediante variables de entrada y bloques outputs que exponen las direcciones IP públicas requeridas por los pipelines de CI/CD.


🛡️ Mejores prácticas incluidas
Principio de Menor Privilegio: Los Security Groups actúan como firewalls a nivel de instancia, impidiendo que internet tenga visibilidad directa del Backend y la Base de Datos.

Infraestructura como Código (IaC): Todo el entorno es reproducible, eliminando configuraciones manuales propensas a errores humanos en la consola web.

Seguridad en el Control de Versiones: Uso estricto de .gitignore para bloquear la subida de estados locales de Terraform (.tfstate), protegiendo contraseñas o credenciales temporales del escaneo público.


🔮 Cómo extender este proyecto
Implementar un Balanceador de Carga (ALB): Distribuir el tráfico entrante del puerto 80 del frontend hacia múltiples zonas de disponibilidad.

Escalado Automático (Auto Scaling Groups): Añadir políticas basadas en consumo de CPU para incrementar dinámicamente el número de servidores EC2 ante alta demanda.

Migración a Base de Datos Gestionada (AWS RDS): Desacoplar el contenedor MySQL del EC2 de backend y migrarlo a un servicio administrado con respaldos automáticos y Multi-AZ para garantizar tolerancia a fallos.

Automatización CI/CD: Integración completa con GitHub Actions en la rama deploy utilizando la gestión nativa de Repository Secrets.

