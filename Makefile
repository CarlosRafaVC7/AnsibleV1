# =============================================================================
# ANSIBLE SECURITY FRAMEWORK - MAKEFILE
# =============================================================================

# Variables
PLAYBOOK = main_router.yml
INVENTORY = inventory/hosts.ini

# Colores
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m

.PHONY: help syntax check security hardening monitoring all clean

help: ## Mostrar ayuda
	@echo "🎯 ANSIBLE SECURITY FRAMEWORK"
	@echo "================================"
	@echo ""
	@echo "Comandos disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}'

syntax: ## Verificar sintaxis del playbook
	@echo "🔍 Verificando sintaxis..."
	@ansible-playbook $(PLAYBOOK) --syntax-check
	@echo "$(GREEN)✅ Sintaxis correcta$(NC)"

check: ## Dry-run del framework completo
	@echo "🧪 Ejecutando dry-run (sin cambios)..."
	@ansible-playbook $(PLAYBOOK) -e action=security --check

security: ## Ejecutar rol de seguridad
	@echo "🔐 Ejecutando configuración de seguridad..."
	@sudo ansible-playbook $(PLAYBOOK) -e action=security --ask-become-pass

hardening: ## Ejecutar rol de hardening
	@echo "🛡️ Ejecutando hardening del sistema..."
	@sudo ansible-playbook $(PLAYBOOK) -e action=hardening --ask-become-pass

monitoring: ## Ejecutar rol de monitoreo
	@echo "📊 Ejecutando configuración de monitoreo..."
	@sudo ansible-playbook $(PLAYBOOK) -e action=monitoring --ask-become-pass

reporting: ## Generar reportes
	@echo "📋 Generando reportes de seguridad..."
	@sudo ansible-playbook $(PLAYBOOK) -e action=reporting --ask-become-pass

all: syntax security hardening monitoring ## Ejecutar todo el framework
	@echo "$(GREEN)🎉 Framework completamente desplegado$(NC)"

clean: ## Limpiar logs y archivos temporales
	@echo "🧹 Limpiando archivos temporales..."
	@sudo rm -rf /tmp/ansible-*
	@sudo find /var/log/ansible_security/ -name "*.log" -mtime +30 -delete 2>/dev/null || true
	@echo "$(GREEN)✅ Limpieza completada$(NC)"

debug: ## Ejecutar con verbose máximo
	@echo "🐛 Ejecutando en modo debug..."
	@sudo ansible-playbook $(PLAYBOOK) -e action=security --ask-become-pass -vvv

list-tasks: ## Listar todas las tareas disponibles
	@echo "📋 Tareas disponibles en el playbook:"
	@ansible-playbook $(PLAYBOOK) --list-tasks

validate: ## Validar configuración
	@echo "✅ Validando configuración del framework..."
	@ansible-inventory --list -i $(INVENTORY)
	@ansible-playbook $(PLAYBOOK) --syntax-check
	@echo "$(GREEN)✅ Validación completada$(NC)"