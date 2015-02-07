tiempobus-ubuntusdk
===================

Aplicación TiempoBus para Ubuntu SDK

Versión preliminar de TiempoBus realizada con la nueva SDK de Ubuntu.
https://launchpad.net/tiempobus
https://github.com/alberapps/tiempobus-ubuntusdk

Aunque actualmente no hay móviles con Ubuntu Touch, las aplicaciones desarrolladas mediante la SDK, se pueden usar desde cualquier dispositivo con Ubuntu instalado. Como la versión de escritorio.

La aplicación se encuentra en desarrollo, aunque las funciones básicas ya están disponibles.

Funciones (por ahora):

    Búsqueda con número de parada
    Gestión de favoritos (Añadir, modificar, borrar)
    Buscador de líneas. (La lista de líneas es fija, pero las listas de paradas ya se cargan de forma dinámica)


* El resto de funciones de la versión para Android se irán añadiendo poco a poco.

La versión sirve tanto para 32 como para 64 bits.

Método de instalación:

Instalación mediante PPA

Añadir el nuevo repositorio:

    sudo add-apt-repository ppa:alberapps/ppa 
    sudo apt-get update
    sudo apt-get install tiempobus

ACTUALIZACIÓN: Incluir el repositorio de desarrollo de Ubuntu SDK para disponer de las versiones mas recientes. Ya que la versión que hay en los repositorios es algo antigua.: "sudo add-apt-repository ppa:ubuntu-sdk-team/ppa"

* Recuerdo que es una versión en desarrollo, por lo que pueden encontrarse funciones a medio implementar o con errores.
* Cualquier comentario, sugerencia o error detectado puede dejarse como comentario a esta entrada o remitirla por email.
* Por ahora no está disponible en el Ubuntu Software Center


Aplicación de código abierto, con licencia GPLv3 (http://www.gnu.org/licenses/gpl.html). El código fuente está disponible en: https://launchpad.net/tiempobus y https://github.com/alberapps/tiempobus-ubuntusdk Cualquier uso de la aplicación y su código fuente, debe respetar las condiciones descritas en la licencia.
