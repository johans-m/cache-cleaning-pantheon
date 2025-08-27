#!/bin/bash

# ========================
# CONFIGURACIÓN
# ========================
spinner() {
  local pid=$!
  local delay=0.1
  local spinstr='|/-\'
  while ps -p $pid &>/dev/null; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}

# ========================
# LISTAR PROYECTOS
# ========================
echo "🔍 Consultando proyectos en Pantheon..."
(terminus site:list --format=list --field=name) >/tmp/sites.txt &
spinner
SITES=$(cat /tmp/sites.txt)

if [ -z "$SITES" ]; then
  echo "❌ No se encontraron sitios en Pantheon."
  exit 1
fi

IFS=$'\n' read -rd '' -a SITE_ARRAY <<<"$SITES"
echo ""
echo "📋 Proyectos disponibles:"
for i in "${!SITE_ARRAY[@]}"; do
  echo "$((i + 1)). ${SITE_ARRAY[$i]}"
done

read -p "👉 Ingresa el número del proyecto: " SITE_NUM
if ! [[ "$SITE_NUM" =~ ^[0-9]+$ ]] || ((SITE_NUM < 1 || SITE_NUM > ${#SITE_ARRAY[@]})); then
  echo "❌ Selección inválida"
  exit 1
fi
SELECTED_SITE="${SITE_ARRAY[$((SITE_NUM - 1))]}"

# ========================
# LISTAR ENTORNOS
# ========================
ENV_OPTIONS=("dev" "test" "live" "Otros multidev")

echo ""
echo "📋 Entornos:"
for i in "${!ENV_OPTIONS[@]}"; do
  echo "$((i + 1)). ${ENV_OPTIONS[$i]}"
done

read -p "👉 Ingresa el número del entorno: " ENV_NUM
if ! [[ "$ENV_NUM" =~ ^[0-9]+$ ]] || ((ENV_NUM < 1 || ENV_NUM > ${#ENV_OPTIONS[@]})); then
  echo "❌ Selección inválida"
  exit 1
fi
SELECTED_ENV="${ENV_OPTIONS[$((ENV_NUM - 1))]}"

# ========================
# MULTIDEVS SI SE NECESITA
# ========================
if [ "$SELECTED_ENV" == "Otros multidev" ]; then
  echo ""
  echo "🔍 Consultando multidevs para $SELECTED_SITE..."
  (terminus multidev:list "$SELECTED_SITE" --format=list --field=id | grep -v -E 'dev|test|live') >/tmp/multidevs.txt &
  spinner
  MULTIDEVS=$(cat /tmp/multidevs.txt)

  if [ -z "$MULTIDEVS" ]; then
    echo "⚠️ No hay multidevs adicionales en este sitio."
    exit 0
  fi

  IFS=$'\n' read -rd '' -a MULTI_ARRAY <<<"$MULTIDEVS"
  echo ""
  echo "📋 Multidevs:"
  for i in "${!MULTI_ARRAY[@]}"; do
    echo "$((i + 1)). ${MULTI_ARRAY[$i]}"
  done

  read -p "👉 Ingresa el número del multidev: " MULTI_NUM
  if ! [[ "$MULTI_NUM" =~ ^[0-9]+$ ]] || ((MULTI_NUM < 1 || MULTI_NUM > ${#MULTI_ARRAY[@]})); then
    echo "❌ Selección inválida"
    exit 1
  fi
  SELECTED_ENV="${MULTI_ARRAY[$((MULTI_NUM - 1))]}"
fi

# ========================
# LIMPIAR CACHÉ
# ========================
echo ""
echo "🧹 Limpiando caché para $SELECTED_SITE.$SELECTED_ENV..."
OUTPUT=$(terminus env:clear-cache "$SELECTED_SITE.$SELECTED_ENV" 2>&1)
echo "🔹 Respuesta de Terminus:"
echo "$OUTPUT"
echo "🎉 Caché limpiada con éxito."
