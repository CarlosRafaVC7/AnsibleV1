# MANUAL (para tu entrega)

## Objetivo
Automatizar y documentar tareas administrativas esenciales en los laboratorios Académico (Linux) y Gamer (Windows)
para garantizar estabilidad y rendimiento.

## Contenidos y por qué son importantes
1) Gestión de procesos y servicios
   - Linux: 'ps aux', 'top', 'systemctl' permiten detectar procesos que consumen CPU/mem y servicios que deben estar activos.
   - Windows: 'Get-Service' y 'Get-Process' permiten el mismo objetivo en el ecosistema Windows.
   - Por qué importa: si un proceso consume demasiada CPU o memoria, los usuarios experimentarán lentitud; si un servicio crítico está detenido,
     ciertas funcionalidades dejarán de estar disponibles.

2) Administración de usuarios, permisos y políticas
   - Crear cuentas controladas (lab_student, gameruser) evita que los usuarios utilicen cuentas administrativas para tareas diarias.
   - Manejar permisos en carpetas compartidas evita pérdida/modificación accidental de datos.

3) Automatización de tareas (cron / Scheduled Tasks)
   - Permite recolectar métricas (memoria, disco) de forma periódica para detectar tendencias antes de que surjan fallos.
   - Ejemplo: registrar df -h y free -h en logs para revisar crecimiento de uso de disco/ram.

4) Administración del almacenamiento y sistemas de archivos
   - df -h / Get-PSDrive: detectan discos llenos o particiones con poco espacio.
   - Crear puntos de montaje (/mnt/lab_storage) o carpetas (D:\lab_storage) para separar datos de usuario de datos del sistema.

## Recomendación de despliegue
- Mantén un solo proyecto con plays comunes y plays por grupo (como aquí).
- Actualiza inventory/hosts.ini con IPs fijas o reservas DHCP para mayor control.
- Habilita WinRM en la VM Windows antes de ejecutar playbooks contra Windows.

## Comandos útiles (desde WSL)
- ansible all -m ping
- ansible-playbook playbooks/gestion_procesos.yml
- ansible-playbook playbooks/administracion_usuarios.yml
