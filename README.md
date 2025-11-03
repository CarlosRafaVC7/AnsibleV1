# Automatización de Laboratorios con Ansible

## Descripción General del Proyecto
Este proyecto implementa la automatización de tareas administrativas para dos entornos de laboratorio diferentes:
- **Laboratorio Académico**: Basado en Linux Mint, enfocado en actividades educativas y desarrollo.
- **Laboratorio de Juegos**: Basado en Windows, optimizado para gaming y rendimiento.

## Arquitectura del Sistema
### 1. Estructura del Proyecto
```
ansible-project/
├── inventory/
│   └── hosts.ini          # Inventario de máquinas
├── playbooks/
│   └── main.yml          # Playbook principal
└── roles/
    ├── linux/            # Roles para Linux Mint
    │   ├── users        # Gestión de usuarios
    │   ├── services     # Procesos y servicios
    │   ├── jobs         # Tareas automatizadas
    │   └── storage      # Gestión de almacenamiento
    └── windows/          # Roles para Windows
        ├── users        # Gestión de usuarios Windows
        ├── services     # Servicios Windows
        ├── jobs         # Tareas programadas
        └── storage      # Gestión de discos
```

### 2. Componentes Principales
- **Inventario**: Define los hosts y sus grupos (académico y gamer)
- **Playbook Principal**: Orquesta la ejecución de roles
- **Roles**: Tareas específicas para cada sistema operativo

## Requisitos del Sistema
### Para el Control Node (donde se ejecuta Ansible)
- Ansible 2.16.3 o superior
- Python 3.x
- SSH cliente
- WSL o Linux
- Módulo pywinrm para Windows

### Para Nodos Linux (Mint)
- SSH Server habilitado
- Python 3.x
- Usuario con privilegios sudo

### Para Nodos Windows
- WinRM habilitado
- PowerShell 3.0 o superior
- Puerto 5985 accesible (WinRM-HTTP)

## Funcionalidades Implementadas

### 1. Gestión de Procesos y Servicios
- Monitoreo de recursos
- Control de servicios
- Análisis de rendimiento

### 2. Administración de Usuarios
- Creación de cuentas
- Gestión de permisos
- Políticas de seguridad

### 3. Automatización de Tareas
- Respaldos programados
- Monitoreo automático
- Logs de rendimiento

### 4. Gestión de Almacenamiento
- Control de espacio en disco
- Organización de archivos
- Puntos de montaje

## Flujo de Trabajo
1. **Preparación**
   - Verificar conectividad de red
   - Configurar SSH/WinRM
   - Validar credenciales

2. **Ejecución**
   ```bash
   # Verificar sintaxis
   ansible-playbook -i inventory/hosts.ini playbooks/main.yml --syntax-check

   # Simulación (dry-run)
   ansible-playbook -i inventory/hosts.ini playbooks/main.yml --check

   # Ejecución real
   ansible-playbook -i inventory/hosts.ini playbooks/main.yml
   ```

3. **Verificación**
   - Comprobar usuarios creados
   - Verificar servicios activos
   - Validar tareas programadas
   - Revisar espacio en disco

## Resultados Esperados

### En Laboratorio Académico (Linux)
1. **Usuarios y Permisos**
   - Usuario lab_student creado
   - Permisos sudo configurados
   - Carpetas compartidas establecidas

2. **Procesos y Servicios**
   - Servicios críticos activos
   - Monitoreo de recursos configurado
   - Logs de rendimiento activos

3. **Tareas Automatizadas**
   - Respaldos programados
   - Monitoreo periódico
   - Logs de sistema configurados

4. **Almacenamiento**
   - Puntos de montaje creados
   - Espacio monitoreado
   - Estructura de directorios organizada

### En Laboratorio de Juegos (Windows)
1. **Usuarios y Permisos**
   - Usuario LabStudent creado
   - Permisos de administrador asignados
   - ACLs configuradas

2. **Procesos y Servicios**
   - Servicios Windows optimizados
   - Monitoreo de rendimiento activo
   - WinRM configurado

3. **Tareas Programadas**
   - Respaldos automáticos
   - Monitoreo de recursos
   - Logs de rendimiento

4. **Almacenamiento**
   - Discos organizados
   - Carpetas de juegos estructuradas
   - Espacio monitoreado

## Beneficios del Sistema
1. **Automatización Completa**
   - Reducción de errores humanos
   - Configuración consistente
   - Despliegue rápido

2. **Mantenimiento Simplificado**
   - Monitoreo automatizado
   - Respaldos programados
   - Gestión centralizada

3. **Escalabilidad**
   - Fácil añadir nuevos hosts
   - Roles reutilizables
   - Configuración modular

4. **Seguridad**
   - Gestión consistente de usuarios
   - Permisos estandarizados
   - Logs centralizados

## Mantenimiento y Monitoreo
- Revisión periódica de logs
- Verificación de respaldos
- Monitoreo de recursos
- Actualización de configuraciones

## Conclusión
Este sistema proporciona una solución completa y automatizada para la gestión de ambos laboratorios, garantizando:
- Estabilidad operativa
- Rendimiento optimizado
- Mantenimiento simplificado
- Gestión eficiente de recursos

La automatización con Ansible asegura consistencia en las configuraciones y reduce significativamente el tiempo de administración manual, permitiendo que los administradores se enfoquen en tareas más estratégicas.
