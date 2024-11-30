# ===============================================================
# Script de Automatización para Simulación en Vivado
# Pipeline-Simulation
# ===============================================================

# Obtener la ruta completa del script actual
set script_path [file normalize [info script]]
set script_dir [file dirname $script_path]

# Cambiar el directorio de trabajo al directorio del script
cd $script_dir

# Cambiar al directorio `projects`
cd ../projects

# Configuración del Proyecto
set nombre_proyecto "pipeline-simulation"
set directorio_proyecto "./$nombre_proyecto"
set parte_fpga "xc7a35tcpg236-1"
set modulo_top "testbench"
set ruta_waveform_conf "../configs/waveform_conf.wcfg"

# Mensajes iniciales
puts "=============================="
puts " Proyecto: $nombre_proyecto"
puts " FPGA Parte: $parte_fpga"
puts " Módulo Top: $modulo_top"
puts "=============================="

# Eliminar proyecto existente
if { [file exists $directorio_proyecto] } {
    puts "Eliminando proyecto existente en: $directorio_proyecto"
    file delete -force $directorio_proyecto
}

# Crear nuevo proyecto
puts "Creando nuevo proyecto en: $directorio_proyecto"
create_project $nombre_proyecto $directorio_proyecto -part $parte_fpga

# Agregar archivos de diseño
puts "Buscando archivos de diseño en ../src/des/"
set design_files [glob ../src/des/*.v]
if { [llength $design_files] == 0 } {
    puts "ERROR: No se encontraron archivos Verilog en ../src/des/"
    exit
} else {
    add_files $design_files
    puts "Archivos de diseño encontrados: $design_files"
}

# Crear o limpiar el conjunto de simulación
puts "Preparando conjunto de simulación..."
if { [llength [get_filesets sim_1]] == 0 } {
    create_fileset sim_1
    puts "Conjunto de simulación 'sim_1' creado."
} else {
    puts "Conjunto de simulación 'sim_1' encontrado. Limpiando archivos existentes..."
    set sim_files [get_files -of_objects [get_filesets sim_1]]
    foreach file $sim_files {
        remove_files $file
    }
}

# Agregar archivos de simulación
puts "Buscando archivos de simulación en ../src/sim/"
set sim_files [glob ../src/sim/*.v]
if { [llength $sim_files] == 0 } {
    puts "ERROR: No se encontraron archivos de simulación en ../src/sim/"
    exit
} else {
    puts "Archivos de simulación encontrados: $sim_files"
    add_files -fileset sim_1 $sim_files
}

# Verificar archivo de memoria
puts "Buscando archivo de memoria en ../memfiles/memfile.mem"
if { ![file exists ../memfiles/memfile.mem] } {
    puts "ERROR: No se encontró el archivo de memoria en ../memfiles/memfile.mem"
    exit
} else {
    puts "Archivo de memoria encontrado. Añadiendo a la simulación."
    add_files -fileset sim_1 ../memfiles/memfile.mem
}

# Agregar configuración de waveform
puts "Añadiendo configuración de waveform desde: $ruta_waveform_conf"
if { ![file exists $ruta_waveform_conf] } {
    puts "ERROR: No se encontró el archivo de configuración del waveform: $ruta_waveform_conf"
    exit
} else {
    add_files -fileset sim_1 $ruta_waveform_conf
    set_property xsim.view [list $ruta_waveform_conf] [get_filesets sim_1]
    puts "Configuración de waveform añadida exitosamente."
}

# Agregar archivos de constraints desde ../src/con
puts "Buscando archivos de constraints en ../src/con/"
set constraint_files [glob ../src/con/*.xdc]
if { [llength $constraint_files] == 0 } {
    puts "ERROR: No se encontraron archivos de constraints en ../src/con/"
    exit
} else {
    add_files $constraint_files
    puts "Archivos de constraints encontrados: $constraint_files"
}

# Establecer módulo top para la simulación
puts "Estableciendo módulo top para la simulación: $modulo_top"
set_property top $modulo_top [get_filesets sim_1]

# Establecer tiempo de ejecución de la simulación (10 segundos)
puts "Estableciendo tiempo de ejecución de la simulación a 10 segundos..."
set_property -name {xsim.simulate.runtime} -value {10000000000ns} -objects [get_filesets sim_1]

# Lanzar simulación
puts "Iniciando simulación..."
launch_simulation -simset sim_1
puts "Simulación completada."

# Instrucciones finales
puts "=================================================="
puts " Simulación completada con éxito:"
puts "  - Proyecto: $nombre_proyecto"
puts "  - FPGA Parte: $parte_fpga"
puts "  - Módulo Top: $modulo_top"
puts "=================================================="

