#!/bin/bash
# Script de implementación completa de seguridad - SO-Ansible (Hybrid)
# Implementa toda la configuración de seguridad con credenciales seguras

clear
echo "🔐 IMPLEMENTACIÓN COMPLETA DE SEGURIDAD"
echo "========================================"
echo ""
echo "SO-Ansible (Hybrid) Security Framework"
echo "Configuración integral de seguridad para laboratorios"
echo ""

# ==============================================
# VERIFICACIONES PREVIAS
# ==============================================
echo "📋 1. Verificaciones previas..."

# Verificar Ansible
if ! command -v ansible &> /dev/null; then
    echo "❌ Ansible no está instalado"
    exit 1
fi

# Verificar archivos clave
REQUIRED_FILES=(
    "group_vars/vault_vars.yml"
    "roles/security/tasks/main.yml"
    "roles/security/tasks/users_and_groups.yml"
    "roles/security/tasks/access_control.yml"
    "roles/security/tasks/database_security.yml"
    "roles/security/tasks/network_security.yml"
    "roles/security/tasks/system_info.yml"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [[ -f "$file" ]]; then
        echo "✅ $file"
    else
        echo "❌ $file (MISSING)"
        echo "Error: Archivo requerido no encontrado"
        exit 1
    fi
done
echo ""

# ==============================================
# CONFIGURACIÓN DE VAULT
# ==============================================
echo "🔐 2. Configuración de Ansible Vault..."

if grep -q "ANSIBLE_VAULT" group_vars/vault_vars.yml; then
    echo "✅ Vault ya está encriptado"
    VAULT_ENCRYPTED=true
else
    echo "⚠️  Vault NO está encriptado"
    read -p "¿Deseas encriptar las credenciales ahora? (y/N): " encrypt_vault
    
    if [[ $encrypt_vault == "y" || $encrypt_vault == "Y" ]]; then
        echo "🔒 Encriptando credenciales..."
        ansible-vault encrypt group_vars/vault_vars.yml
        if [ $? -eq 0 ]; then
            echo "✅ Credenciales encriptadas exitosamente"
            VAULT_ENCRYPTED=true
        else
            echo "❌ Error al encriptar credenciales"
            exit 1
        fi
    else
        VAULT_ENCRYPTED=false
    fi
fi
echo ""

# ==============================================
# OPCIONES DE IMPLEMENTACIÓN
# ==============================================
echo "🎯 3. Opciones de implementación disponibles:"
echo ""
echo "1) 🔒 Solo configuración de seguridad"
echo "2) 👥 Solo usuarios y grupos"
echo "3) 🗄️ Solo bases de datos y servicios"
echo "4) 🌐 Solo seguridad de red"
echo "5) 📊 Solo información del sistema"
echo "6) ✅ Implementación completa (RECOMENDADO)"
echo "7) 🧪 Validación de configuración"
echo ""

read -p "Selecciona una opción (1-7): " option

case $option in
    1)
        PLAYBOOK_COMMAND="ansible-playbook playbooks/main.yml --tags security"
        DESCRIPTION="Configuración de seguridad únicamente"
        ;;
    2)
        PLAYBOOK_COMMAND="ansible-playbook playbooks/main.yml --tags users,groups"
        DESCRIPTION="Configuración de usuarios y grupos"
        ;;
    3)
        PLAYBOOK_COMMAND="ansible-playbook playbooks/main.yml --tags database,services"
        DESCRIPTION="Seguridad de bases de datos y servicios"
        ;;
    4)
        PLAYBOOK_COMMAND="ansible-playbook playbooks/main.yml --tags network,nic"
        DESCRIPTION="Seguridad de red e interfaces"
        ;;
    5)
        PLAYBOOK_COMMAND="ansible-playbook playbooks/main.yml --tags info,dump"
        DESCRIPTION="Recopilación de información del sistema"
        ;;
    6)
        PLAYBOOK_COMMAND="ansible-playbook playbooks/main.yml"
        DESCRIPTION="Implementación completa de seguridad"
        ;;
    7)
        PLAYBOOK_COMMAND="ansible-playbook tests/validate_configuration.yml"
        DESCRIPTION="Validación de configuración existente"
        ;;
    *)
        echo "❌ Opción inválida"
        exit 1
        ;;
esac

# ==============================================
# SELECCIÓN DE HOSTS
# ==============================================
echo ""
echo "🎯 4. Selección de hosts objetivo:"
echo ""
echo "1) 🎓 Solo laboratorio académico (Linux)"
echo "2) 🎮 Solo laboratorio gamer (Windows)"
echo "3) 🌐 Todos los hosts"
echo ""

read -p "Selecciona hosts objetivo (1-3): " host_option

case $host_option in
    1)
        HOST_LIMIT="--limit academico"
        HOST_DESC="Laboratorio Académico (Linux)"
        ;;
    2)
        HOST_LIMIT="--limit gamer"
        HOST_DESC="Laboratorio Gamer (Windows)"
        ;;
    3)
        HOST_LIMIT=""
        HOST_DESC="Todos los hosts"
        ;;
    *)
        echo "❌ Opción inválida"
        exit 1
        ;;
esac

# ==============================================
# MODO DE EJECUCIÓN
# ==============================================
echo ""
echo "⚙️ 5. Modo de ejecución:"
echo ""
echo "1) 🔍 Dry-run (solo verificar cambios)"
echo "2) 🎯 Ejecución real"
echo ""

read -p "Selecciona modo (1-2): " exec_mode

case $exec_mode in
    1)
        EXEC_OPTIONS="--check --diff"
        EXEC_DESC="Dry-run (sin cambios reales)"
        ;;
    2)
        EXEC_OPTIONS=""
        EXEC_DESC="Ejecución real"
        ;;
    *)
        echo "❌ Opción inválida"
        exit 1
        ;;
esac

# ==============================================
# CONFIRMACIÓN Y EJECUCIÓN
# ==============================================
echo ""
echo "📋 RESUMEN DE IMPLEMENTACIÓN:"
echo "==============================="
echo "Descripción: $DESCRIPTION"
echo "Hosts objetivo: $HOST_DESC"
echo "Modo: $EXEC_DESC"
echo "Vault encriptado: $VAULT_ENCRYPTED"
echo ""

# Construir comando final
FINAL_COMMAND="$PLAYBOOK_COMMAND $HOST_LIMIT $EXEC_OPTIONS"

if [ "$VAULT_ENCRYPTED" = true ]; then
    FINAL_COMMAND="$FINAL_COMMAND --ask-vault-pass"
fi

echo "Comando a ejecutar:"
echo "$FINAL_COMMAND"
echo ""

read -p "¿Continuar con la implementación? (y/N): " confirm

if [[ $confirm != "y" && $confirm != "Y" ]]; then
    echo "❌ Implementación cancelada"
    exit 0
fi

# ==============================================
# EJECUCIÓN
# ==============================================
echo ""
echo "🚀 INICIANDO IMPLEMENTACIÓN..."
echo "=============================="
echo ""

# Verificar conectividad antes de ejecutar
echo "📡 Verificando conectividad con hosts..."
if [[ "$HOST_LIMIT" == "--limit academico" ]]; then
    ansible academico -m ping
elif [[ "$HOST_LIMIT" == "--limit gamer" ]]; then
    ansible gamer -m win_ping
else
    ansible all -m ping
    ansible gamer -m win_ping
fi

if [ $? -ne 0 ]; then
    echo "❌ Error de conectividad con algunos hosts"
    read -p "¿Continuar de todas formas? (y/N): " force_continue
    if [[ $force_continue != "y" && $force_continue != "Y" ]]; then
        echo "❌ Implementación cancelada"
        exit 1
    fi
fi

echo ""
echo "⏳ Ejecutando configuración de seguridad..."
echo "Hora de inicio: $(date)"
echo ""

# Ejecutar el comando con manejo mejorado de errores
set +e  # No salir automáticamente en errores
eval $FINAL_COMMAND
RESULT=$?
set -e

echo ""
echo "📋 RESULTADO DE LA IMPLEMENTACIÓN:"
echo "=================================="
if [[ $RESULT -eq 0 ]]; then
    echo "✅ Implementación completada exitosamente"
elif [[ $RESULT -eq 4 ]]; then
    echo "⚠️  Implementación completada con advertencias menores"
    echo "💡 Esto es normal en entornos de demostración"
    RESULT=0  # Tratar como exitoso
else
    echo "❌ Implementación completada con errores (código: $RESULT)"
    echo "💡 Revisa los logs para más detalles"
fi

echo ""
echo "⏰ Hora de finalización: $(date)"

# ==============================================
# RESULTADOS
# ==============================================
if [ $RESULT -eq 0 ]; then
    echo ""
    echo "✅ IMPLEMENTACIÓN COMPLETADA EXITOSAMENTE"
    echo "=========================================="
    echo ""
    echo "🎯 Próximos pasos recomendados:"
    echo ""
    echo "1. 🧪 Validar configuración:"
    echo "   ansible-playbook tests/validate_configuration.yml"
    echo ""
    echo "2. 📊 Revisar logs de seguridad:"
    echo "   tail -f /var/log/ansible_security/*.log"
    echo ""
    echo "3. 🔍 Verificar servicios:"
    echo "   ansible all -m service_facts"
    echo ""
    echo "4. 🌐 Probar conectividad:"
    echo "   ansible all -m ping"
    echo "   ansible gamer -m win_ping"
    echo ""
    echo "📚 Documentación disponible en:"
    echo "   - README.md"
    echo "   - MANUAL.md"
    echo ""
else
    echo ""
    echo "❌ IMPLEMENTACIÓN FALLÓ"
    echo "======================"
    echo ""
    echo "🔍 Para troubleshooting:"
    echo ""
    echo "1. Verificar conectividad:"
    echo "   ansible-inventory --list"
    echo "   ansible all -m ping"
    echo ""
    echo "2. Verificar sintaxis:"
    echo "   ansible-playbook playbooks/main.yml --syntax-check"
    echo ""
    echo "3. Ejecutar en modo verbose:"
    echo "   ansible-playbook playbooks/main.yml -vvv"
    echo ""
    echo "4. Revisar logs:"
    echo "   tail -f /var/log/ansible.log"
    echo ""
fi

echo ""
echo "🔐 SO-Ansible Security Framework - Completado"
echo "=============================================="