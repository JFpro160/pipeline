# Pipeline-Base

Este repositorio contiene la base del proyecto **Pipeline** diseñado para la FPGA **Basys 3**.

## Requisitos

- **Vivado 2024.x o superior**
- **FPGA Basys 3** (Modelo: `XC7A35T-1CPG236C`)
- **Sistema Operativo**: Compatible con Linux y Windows.

## Estructura del Proyecto

```plaintext
pipeline-base
├── configs      # Configuración personalizada (ej. waveform)
├── memfiles     # Archivos de memoria para inicialización
├── scripts      # Scripts Tcl para simulación y síntesis
├── src          # Archivos fuente (diseño y simulación)
│   ├── des      # Archivos de diseño
│   └── sim      # Archivos de simulación
├── projects     # Carpeta ignorada por Git, generada por los scripts
└── .gitignore   # Archivos y carpetas ignorados por Git
```

---

## Instrucciones

### Opción 1: **Ejecutar desde Vivado GUI**

#### Cambiar el Directorio de Trabajo
1. Abre **Vivado GUI**.
2. Localiza la **Consola Tcl**:
   - La consola Tcl está en la parte inferior de la ventana principal de Vivado, etiquetada como "Tcl Console". Si no la ves, actívala desde el menú **Window > Tcl Console**.
3. Cambia al directorio raíz del proyecto usando el comando `cd`:
   ```tcl
   cd {/ruta/absoluta/a/pipeline-base}
   ```
   Por ejemplo:
   - **Linux:**
     ```tcl
     cd {/home/jose/UTEC/Ciclo 4/Arquitectura de Computadores/github/pipeline-base}
     ```
   - **Windows:**
     ```tcl
     cd {C:/Users/usuario/Documents/pipeline-base}
     ```

4. Verifica el directorio actual con:
   ```tcl
   pwd
   ```
   Esto debe devolver la ruta al directorio raíz del proyecto.

#### Ejecutar Scripts Tcl
- Para simulación:
  ```tcl
  source ./scripts/sim.tcl
  ```
- Para diseño:
  ```tcl
  source ./scripts/des.tcl
  ```

---

### Opción 2: **Ejecutar desde la Terminal**

1. Abre una terminal (Linux o Windows con Vivado en el PATH).

2. Cambia al directorio `projects` dentro del repositorio:
   ```bash
   cd /ruta/a/pipeline-base/projects
   ```

3. Ejecuta el script deseado:
   - **Simulación:**
     ```bash
     vivado -mode gui -source ../scripts/sim.tcl
     ```
   - **Diseño:**
     ```bash
     vivado -mode batch -source ../scripts/des.tcl
     ```

---

## Personalización de los Scripts

Ambos scripts aceptan argumentos opcionales para personalizar la FPGA o el módulo top.

### Sintaxis:
```bash
vivado -mode <gui/batch> -source <script.tcl> -tclargs <parte_fpga> <modulo_top>
```

### Ejemplos:
- **Simulación personalizada:**
  ```bash
  vivado -mode gui -source ../scripts/sim.tcl -tclargs xc7z010clg400-1 custom_testbench
  ```
- **Diseño personalizado:**
  ```bash
  vivado -mode batch -source ../scripts/des.tcl -tclargs xc7z010clg400-1 custom_top
  ```

---

## Notas

1. **Directorio de Trabajo:** Vivado busca archivos relativos al directorio actual. Cambia al directorio del proyecto (`pipeline-base`) antes de ejecutar cualquier script.
2. **Archivos Ignorados:** Todo el contenido de la carpeta `projects/` se genera automáticamente y está excluido del control de versiones mediante el archivo `.gitignore`.
3. **Configuración de Waveform:** El script de simulación carga automáticamente la configuración desde `configs/waveform_conf.wcfg`.
4. **Compatibilidad:** Los scripts están diseñados para ejecutarse tanto en Linux como en Windows, con ejemplos específicos para cada sistema operativo.
5. **Soporte:** Si tienes dudas, revisa los mensajes de la consola Tcl en Vivado o contacta al equipo de desarrollo.

