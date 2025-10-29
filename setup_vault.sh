#!/bin/bash
# Script para configurar Ansible Vault y encriptar credenciales

clear
echo "🔐 CONFIGURACIÓN DE ANSIBLE VAULT"
echo "=================================="
echo ""

# Verificar si ya existe vault encriptado
if grep -q "ANSIBLE_VAULT" group_vars/vault_vars.yml 2>/dev/null; then
    echo "✅ Vault ya está encriptado"
    echo ""
    echo "Para editar las credenciales:"
    echo "  ansible-vault edit group_vars/vault_vars.yml"
    echo ""
    echo "Para ver las credenciales:"
    echo "  ansible-vault view group_vars/vault_vars.yml"
    echo ""
else
    echo "⚠️  Vault NO está encriptado - Las credenciales están expuestas"
    echo ""
    read -p "¿Deseas encriptar las credenciales ahora? (y/N): " encrypt_now
    
    if [[ $encrypt_now == "y" || $encrypt_now == "Y" ]]; then
        echo ""
        echo "🔒 Encriptando credenciales..."
        ansible-vault encrypt group_vars/vault_vars.yml
        
        if [ $? -eq 0 ]; then
            echo "✅ Credenciales encriptadas exitosamente"
        else
            echo "❌ Error al encriptar credenciales"
            exit 1
        fi
    fi
fi

echo ""
echo "📋 COMANDOS ÚTILES:"
echo "==================="
echo ""
echo "🔧 Encriptar archivo:"
echo "   ansible-vault encrypt group_vars/vault_vars.yml"
echo ""
echo "📝 Editar credenciales:"
echo "   ansible-vault edit group_vars/vault_vars.yml"
echo ""
echo "👁️  Ver credenciales:"
echo "   ansible-vault view group_vars/vault_vars.yml"
echo ""
echo "🔓 Desencriptar archivo:"
echo "   ansible-vault decrypt group_vars/vault_vars.yml"
echo ""
echo "🎮 Ejecutar playbook con vault:"
echo "   ansible-playbook playbooks/main.yml --ask-vault-pass"
echo ""
echo "🔑 Usar archivo de contraseña:"
echo "   echo 'mi_password_vault' > .vault_pass"
echo "   chmod 600 .vault_pass"
echo "   ansible-playbook playbooks/main.yml --vault-password-file .vault_pass"
echo ""
echo "💡 IMPORTANTE:"
echo "   - Nunca commitear .vault_pass al repositorio"
echo "   - Usar contraseñas fuertes para el vault"
echo "   - Hacer backup seguro de las credenciales"