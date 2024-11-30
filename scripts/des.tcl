# ========================================================================
# Script de Automatización para Generar Bitstream en Vivado
# Basys3 (parte: xc7a35tcpg236-1)
# ========================================================================

# 1. Configuración Inicial
# Obtener la ruta completa del script actual
set script_path [file normalize [info script]]
set script_dir [file dirname $script_path]

# Cambiar el directorio de trabajo al directorio del script
cd $script_dir

# Cambiar al directorio `projects`
cd ../projects

set nombre_proyecto "pipeline-design"
set directorio_proyecto "./design_project"
set parte_fpga "xc7a35tcpg236-1"
set modulo_top "top"

# 2. Permitir valores personalizados como argumentos
# Uso: vivado -mode batch -source script.tcl -tclargs <parte_fpga> <modulo_top>
if { [llength $argv] >= 1 } {
    set parte_fpga [lindex $argv 0]
}
if { [llength $argv] >= 2 } {
    set modulo_top [lindex $argv 1]
}

puts "=============================="
puts " Proyecto: $nombre_proyecto"
puts " FPGA Parte: $parte_fpga"
puts " Módulo Top: $modulo_top"
puts "=============================="

# 3. Verificar y limpiar directorio de proyecto
if { [file exists $directorio_proyecto] } {
    puts "Eliminando proyecto existente en: $directorio_proyecto"
    file delete -force $directorio_proyecto
}

puts "Creando nuevo proyecto en: $directorio_proyecto"

# 4. Crear Proyecto
create_project $nombre_proyecto $directorio_proyecto -part $parte_fpga

# 5. Agregar Archivos de Diseño
puts "Buscando archivos de diseño en ../src/des/"
set design_files [glob ../src/des/*.v]
if { [llength $design_files] == 0 } {
    puts "ERROR: No se encontraron archivos Verilog en ../src/des/"
    exit
} else {
    add_files $design_files
    puts "Archivos de diseño encontrados: $design_files"
}

# 6. Agregar archivos de constraints desde ../src/con
puts "Buscando archivos de constraints en ../src/con/"
set constraint_files [glob ../src/con/*.xdc]
if { [llength $constraint_files] == 0 } {
    puts "ERROR: No se encontraron archivos de constraints en ../src/con/"
    exit
} else {
    add_files $constraint_files
    puts "Archivos de constraints encontrados: $constraint_files"
}

# 7. Establecer el Módulo Top
puts "Estableciendo módulo top: $modulo_top"
set_property top $modulo_top [current_fileset]

# 8. Lanzar Síntesis
puts "Iniciando síntesis..."
launch_runs synth_1
wait_on_run synth_1
puts "Síntesis completada."

# 9. Lanzar Implementación
puts "Iniciando implementación..."
launch_runs impl_1
wait_on_run impl_1
puts "Implementación completada."

# 10. Generar Bitstream
puts "Generando bitstream..."
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
puts "Bitstream generado exitosamente."

# 11. Instrucciones Finales
puts "=================================================="
puts " Proyecto completado:"
puts "  - Directorio del Proyecto: $directorio_proyecto"
puts "  - Bitstream generado listo para usar."
puts "=================================================="

