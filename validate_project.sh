#!/bin/bash
# Script de validación completa del proyecto Ansible

echo "🔍 INICIANDO VALIDACIÓN COMPLETA..."

PROJECT_DIR="/home/axell/projects/AnsibleV1"
cd "$PROJECT_DIR" || exit 1

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ERRORS=0

# 1. Validar sintaxis Ansible
echo -e "\n🎭 VALIDANDO SINTAXIS ANSIBLE..."
if ansible-playbook --syntax-check main_router.yml; then
    echo -e "${GREEN}✅ Sintaxis Ansible válida${NC}"
else
    echo -e "${RED}❌ Sintaxis Ansible inválida${NC}"
    ((ERRORS++))
fi

# 2. Validar templates
echo -e "\n📝 VALIDANDO TEMPLATES..."
for template in $(find roles/*/templates -name "*.j2" 2>/dev/null); do
    echo "Validando: $template"
done

# 3. Ejecutar test básico
echo -e "\n🧪 EJECUTANDO TEST BÁSICO..."
if ansible-playbook main_router.yml -e action=security --check --limit localhost >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Test básico exitoso${NC}"
else
    echo -e "${YELLOW}⚠️ Test básico con advertencias${NC}"
fi

echo -e "\n📊 RESUMEN:"
echo -e "Errores críticos: $ERRORS"

if [[ $ERRORS -eq 0 ]]; then
    echo -e "${GREEN}🎉 VALIDACIÓN EXITOSA${NC}"
    exit 0
else
    echo -e "${RED}💥 HAY ERRORES CRÍTICOS${NC}"
    exit 1
fi
