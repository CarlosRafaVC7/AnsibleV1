#!/bin/bash
# Quick test script - SO-Ansible (Hybrid)
# Prueba rápida de todo el proyecto

clear
echo "🚀 INICIANDO PRUEBA COMPLETA DEL PROYECTO"
echo "=========================================="
echo ""

# Verificar Ansible
echo "📋 1. Verificando Ansible..."
if ! command -v ansible &> /dev/null; then
    echo "❌ Ansible no está instalado"
    exit 1
fi
ansible_version=$(ansible --version | head -1)
echo "✅ $ansible_version"
echo ""

# Verificar archivos de configuración
echo "📋 2. Verificando archivos del proyecto..."
files_to_check=(
    "ansible.cfg"
    "inventory/hosts.ini"
    "playbooks/main.yml"
    "roles/linux/tasks/main.yml"
    "roles/windows/tasks/main.yml"
    "roles/security/tasks/main.yml"
    "tests/validate_configuration.yml"
)

for file in "${files_to_check[@]}"; do
    if [[ -f "$file" ]]; then
        echo "✅ $file"
    else
        echo "❌ $file (MISSING)"
    fi
done
echo ""

# Test de conectividad
echo "📋 3. Test de conectividad..."
echo "Probando ping a todos los hosts..."
ansible all -m ping -f 10 | head -20
echo ""

# Test específico Windows
echo "📋 4. Test específico Windows..."
echo "Probando WinRM a host gamer..."
ansible gamer -m win_ping | head -10
echo ""

# Mostrar estructura del proyecto
echo "📋 5. Estructura del proyecto:"
tree -I '__pycache__|*.pyc' . | head -30
echo ""

# Comandos disponibles
echo "🎯 COMANDOS DISPONIBLES PARA PROBAR:"
echo "===================================="
echo ""
echo "🔧 CONFIGURACIÓN COMPLETA:"
echo "   ansible-playbook playbooks/main.yml"
echo ""
echo "🧪 VALIDACIÓN:"
echo "   ansible-playbook tests/validate_configuration.yml"
echo ""
echo "🔒 SOLO SEGURIDAD:"
echo "   ansible-playbook playbooks/main.yml --tags security"
echo ""
echo "🎮 SOLO WINDOWS:"
echo "   ansible-playbook playbooks/main.yml --limit gamer"
echo ""
echo "🎓 SOLO LINUX:"
echo "   ansible-playbook playbooks/main.yml --limit academico"
echo ""
echo "🚨 TROUBLESHOOTING:"
echo "   ansible-inventory --list"
echo "   ansible all -m setup | head -50"
echo "   ansible-config dump | grep -i timeout"
echo ""
echo "💡 TIPS:"
echo "   - Usa --check para dry-run"
echo "   - Usa --diff para ver cambios"
echo "   - Usa -v, -vv, -vvv para más detalle"
echo "   - Usa --limit hostname para host específico"
echo ""
echo "✅ PROYECTO LISTO PARA USAR"
echo "========================="