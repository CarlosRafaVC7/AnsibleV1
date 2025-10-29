#!/bin/bash
# Script de validación del proyecto SO-Ansible (Hybrid)
# Verifica que todos los componentes estén listos

echo "🧠 SO-Ansible (Hybrid) - Validación del Proyecto v1.1"
echo "=================================================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para mostrar status
show_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ $2${NC}"
    else
        echo -e "${RED}❌ $2${NC}"
    fi
}

# Verificar que estamos en el directorio correcto
if [ ! -f "ansible.cfg" ] || [ ! -f "requirements.yml" ]; then
    echo -e "${RED}❌ Error: Ejecute este script desde el directorio raíz del proyecto${NC}"
    exit 1
fi

echo -e "${YELLOW}📋 Verificando estructura del proyecto...${NC}"

# Verificar archivos principales
files=(
    "ansible.cfg"
    "requirements.yml"
    "inventory/hosts.ini"
    "playbooks/main.yml"
    "playbooks/infrastructure/esxi_create.yml"
    "playbooks/infrastructure/virtualbox_create.yml"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        show_status 0 "Archivo: $file"
    else
        show_status 1 "Archivo: $file"
    fi
done

# Verificar directorios
directories=(
    "group_vars"
    "host_vars"
    "roles/linux"
    "roles/windows"
    "roles/macos"
    "roles/infrastructure"
    "templates"
    "tests"
)

echo -e "${YELLOW}📁 Verificando directorios...${NC}"
for dir in "${directories[@]}"; do
    if [ -d "$dir" ]; then
        show_status 0 "Directorio: $dir"
    else
        show_status 1 "Directorio: $dir"
    fi
done

# Verificar roles específicos
echo -e "${YELLOW}🎭 Verificando roles...${NC}"

# Linux role
linux_tasks=("main.yml" "users.yml" "services.yml" "jobs.yml" "storage.yml" "network.yml")
for task in "${linux_tasks[@]}"; do
    if [ -f "roles/linux/tasks/$task" ]; then
        show_status 0 "Linux task: $task"
    else
        show_status 1 "Linux task: $task"
    fi
done

# Windows role
windows_tasks=("main.yml" "users.yml" "services.yml" "jobs.yml" "storage.yml" "network.yml")
for task in "${windows_tasks[@]}"; do
    if [ -f "roles/windows/tasks/$task" ]; then
        show_status 0 "Windows task: $task"
    else
        show_status 1 "Windows task: $task"
    fi
done

# macOS role
macos_tasks=("main.yml" "users.yml" "services.yml" "network.yml" "monitoring.yml" "ssh.yml")
for task in "${macos_tasks[@]}"; do
    if [ -f "roles/macos/tasks/$task" ]; then
        show_status 0 "macOS task: $task"
    else
        show_status 1 "macOS task: $task"
    fi
done

# Infrastructure role
infra_tasks=("main.yml" "esxi.yml" "virtualbox.yml" "common.yml")
for task in "${infra_tasks[@]}"; do
    if [ -f "roles/infrastructure/tasks/$task" ]; then
        show_status 0 "Infrastructure task: $task"
    else
        show_status 1 "Infrastructure task: $task"
    fi
done

# Verificar templates
echo -e "${YELLOW}📄 Verificando templates...${NC}"
templates=("netplan_config.yml.j2" "windows_ipv6_config.ps1.j2")
for template in "${templates[@]}"; do
    if [ -f "templates/$template" ]; then
        show_status 0 "Template: $template"
    else
        show_status 1 "Template: $template"
    fi
done

# Verificar tests
echo -e "${YELLOW}🧪 Verificando tests...${NC}"
tests=("validate_connectivity.yml" "validate_configuration.yml")
for test in "${tests[@]}"; do
    if [ -f "tests/$test" ]; then
        show_status 0 "Test: $test"
    else
        show_status 1 "Test: $test"
    fi
done

# Verificar group_vars
echo -e "${YELLOW}⚙️ Verificando variables de grupo...${NC}"
group_vars=("all.yml" "academico.yml" "gamer.yml" "macos_test.yml")
for var_file in "${group_vars[@]}"; do
    if [ -f "group_vars/$var_file" ]; then
        show_status 0 "Group var: $var_file"
    else
        show_status 1 "Group var: $var_file"
    fi
done

# Verificar que Ansible esté instalado
echo -e "${YELLOW}🔧 Verificando herramientas...${NC}"
if command -v ansible >/dev/null 2>&1; then
    version=$(ansible --version | head -n1)
    show_status 0 "Ansible instalado: $version"
else
    show_status 1 "Ansible no está instalado"
fi

if command -v ansible-galaxy >/dev/null 2>&1; then
    show_status 0 "ansible-galaxy disponible"
else
    show_status 1 "ansible-galaxy no disponible"
fi

# Verificar Python packages requeridos
# Detectar entorno virtual
if [ -z "$VIRTUAL_ENV" ]; then
    echo -e "${YELLOW}⚠️  No estás en un entorno virtual. Se recomienda ejecutar:${NC}"
    echo "   python3 -m venv .venv && source .venv/bin/activate"
    PYTHON_CMD="python3"
else
    echo -e "${GREEN}✅ Entorno virtual activo: $VIRTUAL_ENV${NC}"
    PYTHON_CMD="python"
fi

echo -e "${YELLOW}🐍 Verificando dependencias Python...${NC}"
# Verificar pyvmomi con su nombre de import correcto
if $PYTHON_CMD -c "import pyVmomi" 2>/dev/null; then
    show_status 0 "Python package: pyvmomi"
else
    show_status 1 "Python package: pyvmomi (pip install pyvmomi)"
fi

# Verificar pywinrm
if $PYTHON_CMD -c "import winrm" 2>/dev/null; then
    show_status 0 "Python package: pywinrm"
else
    show_status 1 "Python package: pywinrm (pip install pywinrm)"
fi

echo ""
echo -e "${YELLOW}📝 Próximos pasos recomendados:${NC}"
echo "1. Instalar collections: ansible-galaxy collection install -r requirements.yml"
echo "2. Instalar dependencias Python: pip install pyvmomi pywinrm"
echo "3. Configurar credenciales en playbooks/infrastructure/esxi_create.yml"
echo "4. Actualizar IPs en inventory/hosts.ini"
echo "5. Ejecutar: ansible-playbook tests/validate_connectivity.yml"

echo ""
echo -e "${GREEN}✅ Validación completada${NC}"