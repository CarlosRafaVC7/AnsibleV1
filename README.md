# SO-Ansible (Hybrid)
Proyecto Ansible preparado para administrar 2 laboratorios:
- Académico 
- Gamer 

Abrimos este proyecto desde VS Code conectado a WSL (Remote - WSL) y ejecutamos los playbookss desde la terminal WSL.

Estructura principal:
- inventory/hosts.ini        -> define los hosts (IPs)
- playbooks/*.yml           -> playbooks por funcionalidad. Usaremos el main para ejecutar todos.
- roles/*/tasks/main.yml    -> roles con tareas para Linux y Windows

Para usar:
1. Modificamos `inventory/hosts.ini` con las IPs del esxi.
2. Desde WSL/Ubuntu abre la carpeta y ejecutaamos, por ejemplo:
   ansible-playbook playbooks/gestion_procesos.yml
3. Revisa la salida en consola y/o los archivos de log creados en los hosts (/var/log/ansible_monitor o C:\ansible_monitor).

Nota: Para gestionar Windows debemos habilitar WinRM en la VM Windows y permitir comunicación desde mi control node.
