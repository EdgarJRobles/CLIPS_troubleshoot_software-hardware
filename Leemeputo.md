# CLIPS_troubleshoot_software-hardware

A continuacion se define los alcances que la aplicacion de clips va a tomar en cuenta:


-El sistema experto preguntara por los posibles sintomas de caracter fisico.
* RAM "Pantallazo azul, memoria limitada, Traza por sobrecarga de memoria"
* HDD "No formato, Particion dañada (boot dañado"no arranca", tabla principal inexistente "deban de existir la información"), No se encuentra el disco, "
* GPU "pantallazo azul, arranca OS sin video, extrema baja resolucion, pantalla recortada, imagen monocromatica o con manchas de color"
* Tarjeta de red inalambrica "No deteccion de dispositivo de red" (a considerar falla de procesador en dispositivos multi-integrados)
* Tarjeta de red alambrica "No deteccion de dispositivo de red" (a considerar falla de procesador en dispositivos multi-integrados)
* Bateria RTC "Fecha incosistente, Alerta en BIOS"
* Fuente de poder "Cables desconectados, Cables dañados, Interruptor on/off, laptop? led de carga encendido, laptop? Eliminador caliente "
* Ratón "no conectado, sensor laser? superficie no interpreta movimientos, touchpad? sensor desactivado"
* Teclado "no conectado, teclas dañadas"
* Monitor-eterno "monitor desconectado, monitor apagado"


-El sistema experto preguntara por los posibles sintomas de caracter informatico.

-La informacion se ingresara en forma de hechos para su analizis con reglas.

-Si algun hecho no dispara reglas definidas....
"mostrar que no hay informacion base sobre el fallo" 

-Si alguna regla no entrega una solucion definitiva....
"Efectuar alguna de las acciones sugeridas por el sistema experto, si el fallo persiste volve a ejecutar el sistema experto"

-¿Como hacer la base de conocimiento?

-Función preguntar
¿Que debe preguntar al inicio? <- debe existir hechos iniciales ¿Cuales? ->
* la pregunta trivial es si el equipo enciende

