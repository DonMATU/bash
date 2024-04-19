#!/bin/bash

sName="MATU-FUZZER"
tName="matu-fuzzer"
currentVersion="1.0"

# INICIALIZACIÓN DE VARIABLES DE ACTIVADORES
type=""
discover=0




discover=0

# MANÍAS DE KIKE
# Se agrega una función para poder sacar un texto por pantalla con color y mejorar el output por pantalla
# Funciona de la siguiente forma: echo_color -(color) "(texto)"
# EJEMPLO: echo_color -amarillo "Esto es un textp amarillo"

echo_color() {
        local color=$1
        local text=$2
        case $color in
                "-amarillo") echo -e "\033[1;33m$text\033[0m" ;;
                "-azul") echo -e "\033[1;34m$text\033[0m" ;;
                "-blanco") echo -e "\033[1;97m$text\033[0m" ;;  # Blanco claro
                "-cyan") echo -e "\033[1;96m$text\033[0m" ;;  # Cyan claro
                "-gris") echo -e "\033[1;37m$text\033[0m" ;;  # Gris claro
                "-magenta") echo -e "\033[1;95m$text\033[0m" ;;  # Magenta claro
                "-rojo") echo -e "\033[1;31m$text\033[0m" ;;
                "-verde") echo -e "\033[1;32m$text\033[0m" ;;
                *) echo "Color no válido. Opciones: -amarillo, -azul, -blanco, -cyan, -gris, -magenta, -rojo, -verde" ;;
        esac
}







# Función para la optimización de las salidas de errores y mensajes por pantalla (A DESMONTAR)
msg() {

	local opc=$1
	local txt=$2

	case $opc in

		-e)
			printf "$(echo_color -rojo "[!]") ERROR: $txt"
		;;


		-i)
			printf "$(echo_color -azul "[i]") INFO: $txt"
		;;


		-m)
			printf "$(echo_color -verde "[+] MATCH: ") $txt"
		;;

		*)
		;;
	esac

}



# Función para imprimir mensajes de ayuda
print_help() {
    local help_content=""
    help_content+="\n"
    help_content+="$(echo_color -amarillo "$sName") \n"
    help_content+="\n"
    help_content+="$(echo_color -cyan "    DEFINICIÓN:") \n"
    help_content+="          matu-fuzzer es una herramienta básica para aplicar fuzzing de directorios web\n"
    help_content+="          de una forma un tanto más visual e intuitiva.\n"
    help_content+="\n"
    help_content+="\n"

    help_content+="$(echo_color -cyan "    FUNCIONAMIENTO:") \n"
    help_content+="          matu-fuzzer funciona básicamente mediante peticiones y respuestas a servicios web.\n"
    help_content+="          Se recoge un diccionario (-w) y por cada palabra o línea, se envía una petición al\n"
    help_content+="          objetivo (-t) y dependiendo del código de respuesta, se muestra la información por\n"
    help_content+="          pantalla\n"
    help_content+="\n"
    help_content+="          Por ejemplo, si un supuesto servicio serb tuviese ese árbol de directorios:\n"
    help_content+="\n"
    help_content+="                                           ┌ /admin       \n"
    help_content+="          ───── http://192.168.111.30 ─────┤              \n"
    help_content+="                                           └ /dev         \n"
    help_content+="\n"
    help_content+="          La salida por pantalla que obtendrías sería la siguiente\n"
    help_content+="\n"
    help_content+="          RESPONSE       FILE/DIR                      URL\n"
    help_content+="\n"
    help_content+="          [+] MATCH      admin                         http://192.168.111.30/admin\n"
    help_content+="          [+] MATCH      dev                           http://192.168.111.30/dev \n"
    help_content+="\n"

    help_content+="\n"

    help_content+="$(echo_color -cyan "    OPCIONES:") \n"
    help_content+="$(echo_color -magenta "           -h, -helP)")\n"
    help_content+="                  Mostrar este mensaje de ayuda. (DETIENE LA EJECUCIÓN DEL SCRIPT)\n"

    help_content+="$(echo_color -magenta "           -c)")\n"
    help_content+="                  Limpiar ventana al ejecutar el script\n"

    help_content+="$(echo_color -magenta "           -w)")\n"
    help_content+="                  Especificar la ruta COMPLETA hacia el diccionario / hordlist\n"

    help_content+="$(echo_color -magenta "           -t")\n"
    help_content+="                  Escpecificar el objetivo con el que se va a interactuar.\n"
    help_content+="                  ejemplos)\n"
    help_content+="                          http://192.168.0.1              => Protocolo HTTP\n"
    help_content+="                          https://192.168.0.1             => Protocolo HTTPS\n"
    help_content+="                          http://dominio.lan              => Con DNS (Tipo A)\n"
    help_content+="                          http://192.168.0.1:2802         => Puerto 2802 del objetivo.\n"
    help_content+="\n"

    help_content+="$(echo_color -magenta "           -f")\n"
    help_content+="                  Habilita la búsqueda de ficheros en los directorios web.\n"
    help_content+="                  En caso de que se encentre un subdirectorio en el objetivo a tratar,\n"
    help_content+="                  Se lanza una petición para intentar listar los ficheros presentes en\n"
    help_content+="                  su interior. Pero OJO, no se hace fuzzin sobre los subdirectorios encontrados\n"
    help_content+="\n"
    help_content+="                  Por ejemplo, si el árbol de directorios es el siguiente: \n"
    help_content+="\n"
    help_content+="                                                   ┌ /matrix              \n"
    help_content+="                                                   │   ├ /dom             \n"
    help_content+="                                                   │   └ users.txt\n"
    help_content+="                                                   │                      \n"
    help_content+="                  ───── http://192.168.111.30 ─────┤                      \n"
    help_content+="                                                   └ /dev                 \n"
    help_content+="                                                       └ profile.php      \n"
    help_content+="\n"
    help_content+="                  La salida que obtendríamos por pantalla sería:                                          \n"
    help_content+="                  [+] MATCH      matrix                        http://192.168.111.30/matrix               \n"
    help_content+="                                  ├ [D] dom/                   ==> http://192.168.111.30/matrix/dom/      \n"
    help_content+="                                  ├ [F] users.txt              ==> http://192.168.111.30/matrix/users.txt \n"
    help_content+="\n"
    help_content+="\n"
    help_content+="                  [+] MATCH      dev                           http://192.168.111.30/dev                  \n"
    help_content+="                                  ├ [F] profile.php            ==> http://192.168.111.30/dev/profile.php  \n"

    echo -e "$help_content" | less -r
    exit
}






# Función para ejecutar el comando
limpiarPantalla() {
	clear
#	echo "Se ha limpiado la pantalla correctamente." #<==== DEBUG: Confirmar la limpieza de la pantalla

}




# Función para procesar el archivo
procesarWordlist() {
	local file="$1"

	if [ ! -e "$file" ]; then
        	msg -e "El archivo $file no existe."
		exit 1
	fi


	# Filtrar las líneas del archivo que no comiencen con '#' y que no estén vacías
	wordlist=$file

	# Contar las líneas del wordlist
	wordlistLineas=$(wc -l $file | cut -d " " -f1)

}



# Función para introducir la IP o nombre del objetivo.
processTarget(){
	local Ltarget="$1"


	target=$Ltarget
}





ficheros_visibles(){

        local objetivo=$1

        # Mostrar los archivos visibles en el directorio web
        local listado=$(curl -sL $objetivo | grep -o '<a [^>]*href="[^"]*"[^>]*>' | sed -e 's/<a [^>]*href="\(.*\)">/\1/g' | grep -vE '^\?C=|^\s*/\s*$')

        if [ -z "$listado" ];
                then
#                        echo "INFO: No se han encontrado archivos con exceso de permisos."
#                        echo ""
			echo "1" > /dev/null
                else

#                        echo "INFO: Se han encontrado archivos los siguientes ficheros accesibles:"
#                        echo ""
                        # Por cada objeto encontrado en el objetivo, se comprueba si es un directorio (si la cadena acaba en "/") o un fichero e imprime
                        # cada una de las líneas en el formato necesario

                        for f in $listado; do

                                ultima_letra=${f: -1}
                                if [ "$ultima_letra" == "/" ];
                                        then
                                                directorios+=("$f")
                                        else
                                                archivos+=("$f")
                                fi
                        done


                        # Imprimir los directoris encontrados
                        #echo "[~] Directorios encontrados:"
                        for dir in "${directorios[@]}"; do
                                ruta="$objetivo/$dir"
                        	printf "%-15s %-30s %-${#ruta}s\n" " " "├ [D] $dir" "$(echo_color -amarillo "==>") $ruta"
			done
			unset directorios[@]


                        # Imprimir los ficheros encontrados
                        #echo "[~] Archivos encontrados:"
                        for archivo in "${archivos[@]}"; do
                                ruta="$objetivo/$archivo"
				printf "%-15s %-30s %-${#ruta}s\n" " " "├ [F] $archivo" "$(echo_color -azul "==>") $ruta"
#                                printf "%-15s %-30s %-${#ruta}s\n" " " "$(echo_color -amarillo "├") [F] $archivo" "$(echo_color -amarillo "==>") $ruta"

                        done
			unset archivos[@]

			echo ""
			echo ""
        fi

}






# Procesar los argumentos de línea de comandos
while getopts ":hcw:t:sf" opt; do
	case $opt in
        	h|help)
	        	print_help
            		exit 0
            	;;

		c)
		        limpiarPantalla
            	;;


		w)
            		procesarWordlist "$OPTARG"
            	;;


		t)
			processTarget "$OPTARG"
		;;


		s)
			save="s"
		;;


		f)
			discover=1
		;;


		\?)
		        msg -e "Opción inválida: -$OPTARG"
            		exit 1
           	;;

	        :)
		        msg -e "La opción -$OPTARG requiere un argumento."
            		exit 1
            	;;
	esac
done






# Verificar si no se ha pasado ningún parámetro
if [ $# -eq 0 ]; then
    echo_color -rojo "ERROR: NECESITARÁS ESPECIFICAR ALGÚN PARÁMETRO, ¿NO?"
    exit 1  # Salir con código de error 1
fi











cabeceraMATU() {
	echo "     __  ______  ________  __			 "
	echo "    /  |/  /   |/_  __/ / / /			 "
	echo "   / /|_/ / /| | / / / / / / 			 "
	echo "  / /  / / ___ |/ / / /_/ /  			 "
	printf " /_/  /_/_/  |_/_/  \____/   $(echo_color -amarillo "FUZZER SCRIPT 1.0")	 \n"
	echo "____________________________________________________________"
}

opciones_mostrar(){
	msg -i "Current Wordlist	=> $wordlist ($wordlistLineas words) \n"
#	msg -i "Current Target  	=> http$type://$target/$linea \n"
	msg -i "Current Target	=> $target \n"
	echo "============================================================"
	printf "%-25s %-40s %-20s\n" \
		"$(echo_color -cyan "RESPONSE")" \
	        "$(echo_color -cyan "FILE/DIR")" \
	        "$(echo_color -cyan "URL")"


	echo ""


}


cabeceraMATU
opciones_mostrar







#contador=0
while IFS= read -r linea || [[ -n "$linea" ]]; do

	# Incrementar el progreso en cada iteración del bucle
   	((progreso++))


	# Filtrar comentarios y líneas vacías
	if [[ -z "$linea" || "${linea:0:1}" == "#" ]];
		then
			continue
	fi


	# Aquí se agregaría el procesamiento necesario para cada una.
#	obj="http$type://$target/$linea"
	obj="$target/$linea"

	# Realizar solicitud HTTP
        respuesta=$(curl -sL -w "%{http_code}" "$obj" -o /dev/null)



	if [ "$respuesta" -eq 200 ];
               then

			printf "%-25s %-40s %-${longitud_obj}s\n" \
			       "$(echo_color -verde '[+] MATCH')" \
			       "$(echo_color -amarillo "$linea")" \
			       "$obj"


			if [ $discover -eq 1 ];
				then
					ficheros_visibles $obj
			fi




        fi




	# Calcular el porcentaje completado
	porcentaje=$(awk -v prog="$progreso" -v total="$wordlistLineas" 'BEGIN { printf "%.2f", prog * 100 / total }')

	# Mostrar el progreso actualizado en cada iteración del bucle

	# Obtener el ancho de la terminal
	ancho_terminal=$(tput cols)


	# Calcular la longitud de la columna $obj
	longitud_obj=$((ancho_terminal - 65)) # Ajusta este valor según sea necesario


	# Truncar la columna $obj si es necesario
	if [ ${#linea} -gt $longitud_obj ]; then
		linea_truncada="${linea:0:$longitud_obj}..."
	else
		linea_truncada="$linea"
	fi

	# Imprimir la línea con la columna truncada
	printf "Progreso: %s/%s (%s%%)     ===> %-$(($longitud_obj + 5))s\r" "$progreso" "$wordlistLineas" "$porcentaje" "$linea_truncada"





done < "$wordlist"







echo ""
echo ""
echo ""
echo "------------------------------------------------------------"



echo ""
echo ""
