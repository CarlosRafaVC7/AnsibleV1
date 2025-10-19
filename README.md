# SO-Ansible (Hybrid)
Proyecto Ansible preparado para administrar 2 laboratorios:
- Académico (Linux / Ubuntu)
- Gamer (Windows Server)

Abre este proyecto desde VS Code conectado a WSL (Remote - WSL) y ejecuta playbooks desde tu terminal WSL.

Estructura principal:
- inventory/hosts.ini        -> define tus hosts (IPs y métodos de conexión)
- playbooks/*.yml           -> playbooks por funcionalidad (procesos, usuarios, jobs, almacenamiento)
- roles/*/tasks/main.yml    -> roles con tareas para Linux y Windows

Para usar (resumen):
1. Edita `inventory/hosts.ini` con las IPs reales y credenciales.
2. Desde WSL/Ubuntu abre la carpeta y ejecuta, por ejemplo:
   ansible-playbook playbooks/gestion_procesos.yml
3. Revisa la salida en consola y/o los archivos de log creados en los hosts (/var/log/ansible_monitor o C:\ansible_monitor).

Nota: Para gestionar Windows debes habilitar WinRM en la VM Windows y permitir comunicación desde tu control node.
