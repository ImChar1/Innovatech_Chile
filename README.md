# Innovatech Chile - Arquitectura de Microservicios en AWS EKS

## 📝 Descripción
Este repositorio contiene la Infraestructura como Código (IaC) y las configuraciones de despliegue automatizadas para la plataforma **Innovatech Chile**. El proyecto implementa una arquitectura elástica y escalable basada en microservicios, orquestada mediante **Amazon EKS (Elastic Kubernetes Service)** y automatizada de extremo a extremo a través de pipelines de **DevSecOps** con **GitHub Actions**.

### 🏗️ Componentes de la Arquitectura
* **Frontend:** Aplicación SPA (Vite + React) servida a través de un proxy inverso **Nginx** que expone los recursos y redirige el tráfico de las APIs.
* **Microservicio Ventas:** Backend desarrollado en **Spring Boot** para la gestión de productos y transacciones.
* **Microservicio Despacho:** Backend desarrollado en **Spring Boot** para el control y logística de envíos.
* **Capa de Persistencia:** Base de datos **MySQL** contenerizada bajo políticas estrictas de inicialización.

---

## 🗺️ Estructura del Proyecto

```text
innovatech-chile/
├── .github/workflows/    # Pipelines automatizados de CI/CD (GitHub Actions)
├── front_despacho/       # Código fuente del Frontend y configuración de Nginx (nginx.conf)
├── infra/
│   ├── k8s/              # Manifiestos YAML de Kubernetes (Deployments, Services, ConfigMaps)
│   └── terraform/        # Código de Infraestructura como Código para AWS (VPC, EKS, Subnets)
└── README.md

------------------------------------------------------------------------------------------
🚀 Requisitos Previos
Antes de iniciar, asegúrate de contar con las siguientes herramientas instaladas localmente:

Terraform CLI (Versión >= 1.0)

AWS CLI instalado.

kubectl (Línea de comandos de Kubernetes).

Llave privada SSH válida (vockey) proporcionada por el entorno de AWS.

PASOS A SEGUIR EN ORDEN PARA HACER EL DESPLIEGUE, PRIMERO NOS LOGEAMOS EN AWS

🔐 Configuración de Credenciales de AWS
Para que Terraform pueda autenticarse correctamente en los laboratorios, es necesario configurar las claves temporales activas.

Variables de Entorno en la Terminal
Cada vez que inicies un laboratorio en AWS Academy, haz clic en el botón AWS Details, copia el bloque de credenciales e inyéctalas directamente en tu terminal de VS Code

$env:AWS_ACCESS_KEY_ID="TU_ACCESS_KEY_AQUI"
$env:AWS_SECRET_ACCESS_KEY="TU_SECRET_KEY_AQUI"
$env:AWS_SESSION_TOKEN="TU_SESSION_TOKEN_COMPLETO_AQUI"
$env:AWS_DEFAULT_REGION="us-east-1"


⚙️ Guía de Uso y Despliegue Paso a Paso
Paso 1: Inicialización de la Infraestructura
Accede a la carpeta de infraestructura y aprovisiona el clúster elástico en AWS mediante Terraform:

# 1. Navegar al directorio de Terraform:
cd infra/terraform

# 2. Inicializar el proveedor y descargar módulos
terraform init

# 3. Validar los recursos que se van a construir
terraform plan

# 4. Crear la VPC, Subnets y el clúster EKS en AWS
terraform apply


Paso 2: Conexión con Kubernetes (kubectl)
Una vez que Terraform finalice con éxito, debes enlazar tu terminal local con el nuevo clúster generado en AWS:

aws eks update-kubeconfig --region us-east-1 --name innovatech-chile-cluster

Paso 3: Monitoreo y Obtención de la URL Pública
Cuando el pipeline de GitHub Actions termine de desplegar los cambios automáticamente tras el commit, ejecuta los siguientes comandos para verificar la salud del entorno y extraer el enlace de acceso:

# Verificar que todos los Pods estén en estado 1/1 Running y sin reinicios
kubectl get pods

# Obtener la dirección IP externa del balanceador de carga
kubectl get svc

En la salida del comando kubectl get svc, busca la fila de frontend y copia la dirección DNS externa que aparece bajo la columna EXTERNAL-IP.









