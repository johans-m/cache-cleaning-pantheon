# 🧹 Script para Limpiar Caché en Pantheon con Terminus

Este script permite seleccionar un **sitio y entorno** de Pantheon para **limpiar su caché** usando la CLI de [Terminus](https://pantheon.io/docs/terminus).

Incluye:
- Menú para elegir entornos comunes (**dev, test, live**)  
- Opción de **otros multidevs** (solo se consulta si se selecciona esa opción, para optimizar velocidad)
- Spinner mientras carga información
- Validaciones para evitar errores de selección

---

## 🔧 Requisitos

- Tener instalado **Terminus**:  
  [Guía oficial](https://pantheon.io/docs/terminus/install)
- Estar autenticado en Pantheon:
  ```bash
  terminus auth:login --machine-token=TOKEN
  ```
- Tener acceso al sitio que deseas administrar.

---

## ▶️ Uso

1. Clona este repositorio o copia el script.  
2. Hazlo ejecutable:
   ```bash
   chmod +x limpiar-cache.sh
   ```
3. Ejecuta el script:
   ```bash
   ./limpiar-cache.sh
   ```

---

## 📜 Ejemplo de Ejecución

```bash
1. dev
2. test
3. live
4. Otros multidev
👉 Ingresa el número del entorno: 1

🧹 Limpiando caché para happycinnamon.dev...
🔹 Respuesta de Terminus:
 [notice] Caches cleared on dev.
🎉 Caché limpiada con éxito.
```

Si eliges **Otros multidev**, verás algo como:

```bash
🔍 Consultando multidevs para happycinnamon...
📋 Multidevs:
1. feature-landing
2. bugfix-header

👉 Ingresa el número del multidev: 1

🧹 Limpiando caché para happycinnamon.feature-landing...
🎉 Caché limpiada con éxito.
```

---

## 🛠️ Variables Clave en el Script

| Variable           | Descripción |
|--------------------|-------------|
| `ENV_OPTIONS`      | Lista estática de entornos (`dev`, `test`, `live`, `Otros multidev`) |
| `SELECTED_SITE`    | Nombre del sitio en Pantheon |
| `MULTIDEVS`        | Lista dinámica de multidevs (solo se consulta si se selecciona "Otros multidev") |
| `spinner`          | Función que muestra un spinner mientras se ejecuta Terminus |

---


## Image
<img width="557" height="398" alt="image" src="https://github.com/user-attachments/assets/de5b1997-fed2-477e-b034-f15052c138cc" />

---
## 🚀 Mejoras Futuras
- No sé, no pensé que llegaría tan lejos  

---


💡 Este script está pensado para equipos que gestionan varios sitios en Pantheon y necesitan limpiar caché rápido sin entrar a la interfaz web.
