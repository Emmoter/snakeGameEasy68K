*-----------------------------------------------------------
* Title      : SNAKE GAME
* Written by : Emilio Molina & David Rubio
*-----------------------------------------------------------
    ORG    $1000
RANGO1   EQU 79
***************** Este bloque es solo para probar el generador de números aleatorios
***************** Hacemos llamadas a la subrutina con RANGO=79 y presentamos el resultado
***************** obtenido  
RANGO2   EQU 59
***************** Este bloque es solo para probar el generador de números aleatorios
***************** Hacemos llamadas a la subrutina con RANGO=59 y presentamos el resultado
***************** obtenido 
* ///////////////////////////////////////////////////////////////////////
* ////////////////EMPIEZA EL PROGRAMA//////////////////////
START
    MOVE.L #71,D0 #Usamos este task para iniciar el sonido que sonnará de fondo en la pantalla de inicio.
    MOVE.L #WELCOME,A1
    MOVE.L #$2,D1 #Le damos el valor $2 al sonido en la etiqueta WELCOME.
    TRAP #15 
    MOVE.L #76,D0 #Paramos el sonido para que se puedan escuchar los siguientes con el task 76
    MOVE.L #0,D2 #Cuando asignamos un 0 a D2 solo se reproduce una vez el sonido.
    TRAP #15
    JMP PANTALLAINICIO
START1 
    MOVE.L #76,D0 #Paramos todos los sonidos con el task 76 dándole el valor 3 a D2.
    MOVE.L #3,D2
    TRAP #15
    MOVE.L #0,D1
    MOVE.L #0,D0   
    JMP MENU
START2
    MOVE.B #33,D0
    MOVE.L #640*$10000+520,D1
    TRAP #15   
    MOVE.L #0,PUNTUACION
    MOVE.L #MATRIZ,A3 #aquí empieza nuestra matriz   VALOR SERPIENTE= #45, VALOR FRUTA=#50
    MOVE.L #SERPX,A2 #X
    MOVE.L #SERPY,A4 #Y
    MOVE.L #RANGO1,A5
    MOVE.W #1,SERPX
    MOVE.W #1,SERPY
    MOVE.L #1,D6 #contador longitud
    MOVE.L #0,D1 #iniciamos a 0 D1 (D1.W=LX)
    MOVE.L #0,D2 #inciamos a 0 D2 (UY)
    MOVE.L #0,D3 #iniciamos a 0 D3 (RX)
    MOVE.L #0,D4 #inciamos a 0 D4 (LY)  
    MOVE.W #0,D5 #coordenada x matriz.
    SWAP D5
    MOVE.W #0,D5 #coordenada y matriz.
    SWAP D5
    JSR INIRND  ;Inicializa la semilla (SOLO SE LLAMA UNA VEZ POR EJECUCIÓN DE PROGRAMA)
    JSR PUNTOS # Inicia el marcador de puntuacion
    JMP GENERA_BORDES_SUP_INF #genera los bordes en matriz
* ///////////////////////////////////////////////////////////////////////    
SNAKE
    JSR GENERA_SERPIENTE #genera serpiente en matriz
    JSR GENERA_FRUTA #genera la fruta en matriz
PROGRAMA  
    **Este es el bloque principal del programa en sí. Dependiendo de los valores que tenemos en la matriz, saltará a crear borde, serpiente, fruta o fondo.
    CMP.W #30,(A3) #El valor asignado a los bordes es 30. En la dirección de memoria donde haya un 30, será un borde.
    BEQ BORDE
    CMP.W #45,(A3) #El valor asignado a la serpiente es el 45.En la dirección de memoria de la matriz donde haya un 45,pertenecerá a la serpiente.
    BEQ SERPIENTE
    CMP.W #50,(A3) #El valor asignado a la fruta es el 50.En la dirección de memoria de la matriz donde haya un 50, aparecerá una fruta.
    BEQ FRUTA
    CMP.W #$FFFF,(A3) #El valor asignado al fondo es el $FFFF.En la dirección de memoria de la matriz donde haya un $FFFF, será fondo.
    BEQ FONDO
VUELTA *Esta subrutina se usa para barrer una fila entera
    ADD #2,A3
    ADD #1,D5 #sumamos 1 a la X
    CMP #80,D5
    BEQ AUX_SIG
    JMP PROGRAMA
AUX_SIG *Esta subrutina se usa para que cuando vuelta ha acabado la fila, sume uno al valor de la columna
    MOVE.W #0,D5
    SWAP D5
    ADD #1,D5 #sumamos 1 a la Y
    CMP #60,D5
    BEQ SIGUE
    SWAP D5
    JMP PROGRAMA
SIGUE
    JSR INICIA_TIEMPO #Saltamos a la subrutina que inicia el tiempo
    JSR TIEMPO #Saltamos al bucle que calcula el tiempo que el usuario posee y lo muestra en pantalla.
    MOVE.L #80,D0
    MOVE.L #$00FFFFFF,D1 # ponemos en blanco el color del pen
    MOVE.L #81,D0
    MOVE.L #$0000FF00,D1  #ponemos en blanco el color de relleno     
    TRAP #15
    JSR TECLADO #Salta a la subrutina que lee del teclado para saber qué dirección lleva la serpiente.
    CMP.W #$27,D1 #Como la cabeza se encuentra en la posición (0,0), solo damos la opción al usuario de moverse para abajo o para la derecha al principio.Para ello usamos los CMP con los valores ASCII.
    BEQ BUCLEDER
    CMP.W #$28,D1
    BEQ BUCLEABAJO
    JMP SIGUE
* ///////////////////////////////////////////////////////////////////////
* ///////////////////////////////////////////////////////////////////////
PANTALLAINICIO     
**En esta subrutina creamos la pantalla que aparece nada más iniciar el programa.
    MOVE.L #EMPEZAR,A1  #La operación de mover el valor de las etiquetas a A1 para su posterior muestreo en pantalla o lectura se realizará repetidas veces a lo largo de los bloques de menú y pantalla de inicio.
    MOVE.L #95,D0
    MOVE.W #220,D1  #Con estas cuatro instrucciones usamos el task 95. Éste se usa para escribir en pantalla la frase almacenada en A1 en las coordanadas X e Y correspondientes.Por ello,movemos los valores que necesitamos a D1 (columna) y D2 (fila).
    MOVE.W #200,D2
    TRAP #15    
    MOVE.L #7,D0 #Como queremos que el usuario pulse alguna tecla para comenzar, usamos el task 7 para poner a 1 D1 en el momento en el que el usuario pulse. Así pues, comparamos después D1 con #1 para saltar al siguiente bloque.
    TRAP #15
    CMP.B #1,D1
    BEQ START1
    MOVE.L #23,D0 #Introducimos varios delays en este bloque para conseguir el efecto parpadeante.
    MOVE.L #200,D1
    TRAP #15
    MOVE.L #7,D0
    TRAP #15
    CMP.B #1,D1 #Como se puede observar, se disponen de muchos CMP para detectar el momento justo de pulsación.
    BEQ START1
    JMP AUXINICIO
AUXINICIO
**Auxiliar creada para conseguir el efecto parpadeante.
    MOVE.B #33,D0 #Refrescamos la pantalla para posteriormente volver a poner la frase (parpadea).
    MOVE.L #640*$10000+480,D1 #Asignamos tamaño a la pantalla.
    TRAP #15
    MOVE.L #7,D0 #Repetimos las mismas operaciones que realizamos en PANTALLADEINICIO.
    TRAP #15
    CMP.B #1,D1
    BEQ START1
    MOVE.L #23,D0
    MOVE.L #40,D1
    TRAP #15
    MOVE.L #7,D0
    TRAP #15
    CMP.B #1,D1
    BEQ START1
    JMP PANTALLAINICIO
* ///////////////////////////////////////////////////////////////////////
* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
MENU
    MOVEM.L D0-D1,-(A7) #Guardamos los valores de los registros que necesitamos en la pila.
    
    MOVE.L #21,D0 #Ponemos el puntero de color negro.
    MOVE.L #$00000000,D1
    TRAP #15   
    MOVE.L #5,D0 #Esta operación es necesaria para limpiar la última tecla detectada por el task 5, la cual es guardada en D1. Como necesitamos tener D1 limpio, quitamos esa tecla.
    TRAP #15
    CLR.L D1    
    MOVE.L #71,D0
    MOVE.L #MUSICAMENU,A1 #Activamos el sonido correspondiente al menú con el task 71. A esta música se le asigna el valor #$5.
    MOVE.B #$5,D1
    TRAP #15   
    MOVE.L #76,D0 
    MOVE.L #1,D2 #Ponemos la música en bucle asignándole el valor 1 a D2.Así sonará mientras estemos en el menú.
    TRAP #15   
    MOVE.L #11,D0
    MOVE.W #$FF00,D1 #Con estas tres instrucciones y usando el task 11, ponemos a negro la pantalla. Teniendo el valor #$FF00 en D1 conseguimos este efecto.
    TRAP #15
    CLR D0 #Limpiamos por si acaso los registros que vamos a utilizar a continuación, ya que los hemos estado usando en .W y nunca se sabe si esto puede dar problemas en un futuro.
    CLR D1    
    MOVE.L #80,D0
    MOVE.L #$00FFFFFF,D1  #Puntero a color blanco.
    MOVE.L #81,D0
    MOVE.L #$0000FF00,D1 #Color de relleno a "LIME".   
    MOVE.L #21,D0
    MOVE.L #$01200005,D2 #Gracias a estas tres instrucciones y usando el task 21, podemos cambiar el tipo de letra, su tamaño y su color introduciéndolos en D2 en Hexadecimal.
    TRAP #15    
    MOVE.L #TITULO,A1  #Mostramos la frase almacenada en la etiqueta TITULO.
    MOVE.L #95,D0
    MOVE.W #265,D1
    MOVE.W #50,D2
    TRAP #15    
    **Volvemos a cambiar el color para escribir en pantalla para los modos de juego.
    MOVE.L #80,D0
    MOVE.L #$00FFFF00,D1 
    MOVE.L #81,D0
    MOVE.L #$00FFFF00,D1    
    **Usamos de nuevo el task 21 para cambiar el tipo de letra, su tamañp y color empleado en los modos de juego.
    MOVE.L #21,D0
    MOVE.L #$01090103,D2
    TRAP #15
    **Cada modo de juego aparece debajo del anterior en la pantalla para que el usuario elija entre uno de ellos. Cada frase tiene sus coordenadas específicas en la pantalla (Explicado en PANTALLADEINICIO).).
    MOVE.L #MODONORMAL,A1   
    MOVE.L #95,D0
    MOVE.W #250,D1
    MOVE.W #200,D2
    TRAP #15
    MOVE.L #MODORAPIDO,A1    
    MOVE.L #95,D0
    MOVE.W #250,D1
    MOVE.W #250,D2
    TRAP #15
    MOVE.L #MODOSKIN,A1    
    MOVE.L #95,D0
    MOVE.W #250,D1
    MOVE.W #300,D2
    TRAP #15   
    MOVE.L #MODOEXTREMO,A1    
    MOVE.L #95,D0
    MOVE.W #250,D1
    MOVE.W #350,D2
    TRAP #15   
    MOVE.L #PULSA,A1    
    MOVE.L #95,D0
    MOVE.W #250,D1
    MOVE.W #150,D2
    TRAP #15
    CLR.L D1
    MOVEM.L (A7)+,D0-D1 #Sacamos los valores anteriores de la pila.
LEER   
**Con esta subrutina dentro del menú conseguimos leer lo que el usuario introduce mediante el teclado. Así, sabemos que modo ha elegido.
    MOVE.L #21,D0
    MOVE.L #$00000000,D1 #Como el task 5 muestra en pantalla una barra baja indicando donde tiene que escribir el usuario, ponemos el color a negro para que no se vea lo que escriba.
    TRAP #15     
    MOVE.L #5,D0 #Con este task 5, el programa espera hasta que el usuario introduce un valor ASCII mediante el teclado. 
    TRAP #15    
    MOVE.B D1,MODO
    CMP.B #$31,MODO #Con estos 4 CMP consecutivos conseguimos saber qué modo ha elegido el usuario. Tenemos que comparar con el valor ASCII que tienen los números.
    BEQ MODONORM #Salta a modo normal.
    CMP.B #$32,MODO
    BEQ MODOHARD #Salta a modo difícil.
    CMP.B #$33,MODO
    BEQ MODOPIEL #Salta a modo piel.
    CMP.B #$34,MODO
    BEQ MODOEXTREM #Salta a modo extremo.
    JMP LEER #Si el usuario no se ha decidido o ha pulsado una tecla incorrecta, el bucle vuelve a empezar hasta recibir una orden correcta.
    **Ahora vienen los modos. Explicaremos el primero y los demás son exactamente iguales,ya que estos bloques solo se usan para dar valores al tiempo y a la velocidad que cada modo posee.
MODONORM
    MOVE.L #76,D0 #Paramos todos los sonidos activos con el task 76 y asignándole un 3 a D2. Lo repetimos para cada modo.
    MOVE.L #3,D2
    TRAP #15
    
    MOVE.L #6000,TIEMPOJUEGO #El usuario contará con 60 segundos para comerse la fruta. Para ello, movemos el valor 6000 (centésimas de segundo) a TIEMPODEJUEGO (etiqueta que guarda el tiempo disponible).

    MOVE.L #10,CONTADORDELAY #Valor de la velocidad a la que va la serpiente.
    JMP START2 #Saltamos al programa propiamente dicho, al que genera la matriz y, posteriormente, los demás elementos y permite jugar. (Se explicará a continuación)
MODOHARD
    MOVE.L #76,D0
    MOVE.L #3,D2
    TRAP #15
    MOVE.L #6000,TIEMPOJUEGO
    MOVE.L #10,CONTADORDELAY
    JMP START2
MODOPIEL
    MOVE.L #76,D0
    MOVE.L #3,D2
    TRAP #15
    MOVE.L #6000,TIEMPOJUEGO
    MOVE.L #8,CONTADORDELAY #Este modo tendrá una velocidad superior.

    JMP START2
MODOEXTREM  
    MOVE.L #76,D0
    MOVE.L #3,D2
    TRAP #15
    MOVE.L #6000,TIEMPOJUEGO
    MOVE.L #8,CONTADORDELAY #Este modo tendrá una velocidad superior.
    JMP START2
* ///////////////////////////////////////////////////////////////////////
* ///////////////////////////////////////////////////////////////////////
*Estas dos rutinas se encargan de la generación y comprobación del tiempo de juego
INICIA_TIEMPO
**Esta subrutina se encarga de generar el tiempo, usando el tiempo del sistema y la cantidad de tiempo que queremos que tenga el usuario.
    MOVEM.L D0-D1,-(A7)
    MOVE.L #0,D1
    MOVE.L #0,D0
    MOVE.L #8,D0 #Este task 8 escribe en D1 el tiempo del sistema desde la medianoche en centésimas de segundo.
    TRAP #15
    ADD.L TIEMPOJUEGO,D1 #Sumamos el valor que tenemos almacenado en TIEMPODEJUEGO (el valor del tiempo disponible) a D1
    MOVE.L D1,ENDTIME #Movemos todo a la etiqueta ENDTIME para tenerlo almacenado.
    MOVEM.L (A7)+,D0-D1
    RTS  
COMPRUEBA_TIEMPO
**Esta subrutina se encarga de comprobar si se ha agotado el tiempo del usuario.Si es así, salta al final programado para este caso.
    MOVEM.L D0-D1,-(A7)
    MOVE.L #0,D1
    MOVE.L #8,D0
    TRAP #15
    MOVE.L ENDTIME,D2 #Sacamos el valor que tenemos para compararlo con el del sistema.
    CMP.L D2,D1 #En el caso de que se haya agotado el tiempo, gracias a BHI saltaremos al final.
    BHI FINAL2
    MOVEM.L (A7)+,D0-D1
    RTS
* ///////////////////////////////////////////////////////////////////////
* ///////////////////////////////////////////////////////////////////////
*AQUI EMPIEZA TODO LO QUE CONCIERNE A LA RUTINA DE CRECIMIENTO       
AUX_MODOHARD  
    CMP.L #6,CONTADORDELAY #comparamos con el valor mínimo del delay del modo
    BEQ CRECER2 # si es igual lo dejamos como está
    SUB.L #1,CONTADORDELAY # si no, le restamos 1
    JMP CRECER2
AUX_MODOEXTREM
    CMP.L #1,CONTADORDELAY 
    BEQ AUX_TIMEEX
    SUB.L #1,CONTADORDELAY
AUX_TIMEEX
    CMP.L #2000,TIEMPOJUEGO # en este modo además del delay, haremos lo mismo con el tiempo del usuario para comerse la fruta
    BEQ CRECER2
    SUB.L #500,TIEMPOJUEGO
    JMP CRECER2
AUX_MODOPIEL
    MOVE D7,D5 # no movemos las coordenadas x e y completamente
    JMP VOLVERPIEL
CRECER
    MOVEM.L D0-D1/A1,-(A7) 
    MOVE.L #70,D0 
    MOVE.L #COMER,A1
    TRAP #15 # reproducimos el sonido de comer fruta
    MOVEM.L (A7)+,D0-D1/A1
    ADD.L #1,PUNTUACION #sumamos 1 a la puntuacion
    JSR PUNTOS #actualizamos la puntuacion en pantalla 
    CMP.B #$32,MODO #comprobamos el modo en el que estamos y dependiendo de este aumentamos delay o no, etc...
    BEQ AUX_MODOHARD
    CMP.B #$34,MODO
    BEQ AUX_MODOEXTREM
CRECER2
    JSR INICIA_TIEMPO  # actualizamos el tiempo para que se resetee con la nueva fruta
    JSR GENERA_FRUTA #generamos una nueva fruta aleatoriamente
    MOVE.W D6,-(A7) #guardamos el contador de longitud en la pila
    MOVE.L #SERPX,A2 #movemos la direccion de las X a A2
    MOVE.L #SERPY,A4 #movemos la direccion de las Y a A4
BUCL_CRECER
    
    CMP.W #0,D6 #comprobamos si la lontigud es 0 (ya ha acabado)
    BEQ AUX_CRECER
    MOVE.W (A2),D7 #movemos la componente X de la posicion de SERPX al auxiliar D7
    SWAP D7
    MOVE.W (A4),D7 #movemos la componente Y de la posicion de SERPY al auxiliar D7
    SWAP D7
    MOVE.W D5,(A2)+ #guardamos la X de la  nueva cabeza en la primera posicion de SERPX
    SWAP D5
    MOVE.W D5,(A4)+ #guardamos la Y de la  nueva cabeza en la primera posicion de SERPX
    SWAP D5
    CMP.B #$33,MODO
    BEQ AUX_MODOPIEL
    MOVE.L D7,D5 #guardamos el auxiliar D7 en D5 para que sea desplazado en la siguiente ejecución
VOLVERPIEL
    SUB #1,D6 #restamos 1 al contador de lontigud
    JMP BUCL_CRECER #volvemos al bucle
AUX_CRECER  
    MOVE.W D7,(A2) #guardamos la X de la ultima posicion de serpiente
    SWAP D7
    MOVE.W D7,(A4) #guardamos la Y de la ultima posicion de serpiente
    SWAP D7
    MOVE.W (A7)+,D6   #sacamos el contador de lontigud de la pila  
    ADD.W #1,D6 #lo aumentamos en 1
    MOVE.L #SERPX,A2 #movemos la direccion donde esta la X de cabeza a A2
    MOVE.L #SERPY,A4 #movemos la direccion donde esta la Y de cabeza a A2
    MOVE.W (A2),D5 #movemos la X de cabeza a D5
    SWAP D5
    MOVE.W (A4),D5 #movemos la Y de cabeza a D5
    SWAP D5
    MOVE.L #80,D0
    MOVE.L #$0000FF00,D1 # ponemos en blanco el verde del pen
    MOVE.L #81,D0
    MOVE.L #$0000FF00,D1  #ponemos en blanco el verde de relleno     
    TRAP #15    
    JSR COORDENADAS_A_DIRECCION #obtenemos la posicion de memoria de la nueva cabeza
    MOVE.W #45,(A1) #ponemos valor de serpiente
    JSR COORDENADAS_A_PIXEL #obtenemos los valores de pixel en D1-D4
    JSR DIBUJAR #dibujamos la nueva cabeza
    RTS
* ///////////////////////////////////////////////////////////////////////
* ///////////////////////////////////////////////////////////////////////
SUBRUTINA_CUERPO
    MOVE.W D6,-(A7) #guardamos el contador de lontigud en la pila
BUCL
    SUB #1,D6 #restamos 1 al contador de lontigud
    CMP.W #0,D6 #comprobamos si es 0
    BEQ AUX_COLA #si es 0, saltamos al siguiente bucle
    ADD.W #2,A2 #apuntamos a la siguiente direccion de SERPX
    ADD.W #2,A4 #apuntamos a la siguiente direccion de SERPY
    MOVE.W D7,-(A7) #GUARDAMOS LA X en la pila
    SWAP D7
    MOVE.W D7,-(A7) #GUARDAMOS LA Y en la pila
    SWAP D7
    CLR D7
    MOVE.W (A2),D7 #movemos la nueva X a D7
    SWAP D7
    MOVE.W (A4),D7 #movemos la nueva Y a D7
    SWAP D7
    MOVE.W (A7),(A4) #copiamos la X guardada en la pila a la posicion de SERPX
    MOVE.W (A7)+,D5 #sacamos este valor a D5, para poder saltar a las rutinas de coordenadas a direccion y a pixel 
    SWAP D5
    MOVE.W (A7),(A2) #copiamos la Y guardada en la pila a la posicion de SERPY

    MOVE.W (A7)+,D5 #sacamos este valor a D5
    JSR COORDENADAS_A_DIRECCION #sacamos la direccion
    MOVE.W #45,(A1) #ponemos valor de serpiente en ella
    JSR COORDENADAS_A_PIXEL #obtenemos valores D1-D4 para dibujar
    JSR DIBUJAR #dibujamos
    JMP BUCL 
AUX_COLA
    MOVE.W (A7)+,D6 #sacamos el contador de lontigud original
    MOVE.L #SERPX,A2 
    MOVE.L #SERPY,A4
    RTS
*\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\   
BUCLEDER
    MOVE.W (A2),D5 #movemos la X de cabeza a D5
    ADD.W #1,D5 #sumamos 1
    SWAP D5
    MOVE.W (A4),D5 #movemos la Y de cabeza a D5
    SWAP D5
    JSR COORDENADAS_A_DIRECCION #sacamos direccion
    CMP.W #45,(A1) #comprobamos si hay serpiente
    BEQ FINAL  #si hay, perdemos
    CMP #30,(A1) #comprobamos si hay muro
    BEQ FINAL #si hay, perdemos
    CMP.W #50,(A1) #comprueba si hay fruta
    BEQ AUX_DER2
AUX_DER    
    MOVE.W #45,(A1)   #pone serpiente en esa direccion
    MOVE.W SERPX,D7 #movemos X de cabeza a auxiliar D7
    SWAP D7
    MOVE.W SERPY,D7 #movemos Y de cabeza a auxiliar D7
    SWAP D7    
    MOVE.W D5, (A2) #actualizamos SERPX con nuevo valor de cabeza
    SWAP D5
    MOVE.W D5,(A4) #actualizamos SERPY con nuevo valor de cabeza
    SWAP D5
    JSR COORDENADAS_A_PIXEL #obtenemos D1-D4
    JSR DIBUJAR #dibujamos nueva cabeza       
CUERPODER
    JSR SUBRUTINA_CUERPO 
    JMP COLADER
COLADER
    JSR BORRA #borramos ultima posicion
    JSR COMPRUEBA_TIEMPO #comprobamos si no ha agotado tiempo
    JSR TIEMPO #actualizamos el marcador de tiempo
      
    JSR TECLADO #leemos teclado
    CMP.W #$28,D1 #comprobamos si ha pulsado tecla de otro movimiento
    BEQ BUCLEABAJO
    CMP.W #$26,D1
    BEQ BUCLEARRIBA
    JMP BUCLEDER
AUX_DER2
    JSR CRECER
    JMP BUCLEDER
* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
BUCLEIZQ
**Los bucles de movimientos son muy similares al de BUCLEDER, el cual ya está comentado.
    MOVE.W (A2),D5 #Si vamos a movernos hacia la izquierda, ponemos el valor donde estamos (Coordenada Y e X) en D5 (MSB Y, LSB X)
    SUB.W #1,D5 #Restamos uno. Si estamos en la posición (2,1) pasamos a la (1,1) ya que nos desplazamos hacia la izquierda. 
    SWAP D5
    MOVE.W (A4),D5
    SWAP D5
    JSR COORDENADAS_A_DIRECCION
    CMP.W #45,(A1)
    BEQ FINAL  
    CMP #30,(A1)
    BEQ FINAL
    CMP.W #50,(A1)
    BEQ AUX_IZQ2
AUX_IZQ    
    MOVE.W #45,(A1)   
    MOVE.W SERPX,D7
    SWAP D7
    MOVE.W SERPY,D7
    SWAP D7   
    MOVE.W D5, (A2)
    SWAP D5
    MOVE.W D5,(A4)
    SWAP D5
    JSR COORDENADAS_A_PIXEL
    JSR DIBUJAR   
CUERPOIZQ
    JSR SUBRUTINA_CUERPO
    JMP COLAIZQ
COLAIZQ
    JSR BORRA  
    JSR COMPRUEBA_TIEMPO     
    JSR TIEMPO    
    JSR TECLADO
    CMP.W #$28,D1
    BEQ BUCLEABAJO
    CMP.W #$26,D1
    BEQ BUCLEARRIBA
    JMP BUCLEIZQ
AUX_IZQ2
    JSR CRECER
    JMP BUCLEIZQ
* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
BUCLEABAJO
    MOVE.W (A2),D5
    SWAP D5
    MOVE.W (A4),D5
    ADD.W #1,D5
    SWAP D5
    JSR COORDENADAS_A_DIRECCION
    CMP.W #45,(A1)
    BEQ FINAL  
    CMP #30,(A1)
    BEQ FINAL
    CMP.W #50,(A1)
    BEQ AUX_ABA2
AUX_ABA    
    MOVE.W #45,(A1)  
    MOVE.W SERPX,D7
    SWAP D7
    MOVE.W SERPY,D7
    SWAP D7   
    MOVE.W D5,(A2)
    SWAP D5
    MOVE.W D5,(A4)
    SWAP D5
    JSR COORDENADAS_A_PIXEL
    JSR DIBUJAR 
CUERPOABA
    JSR SUBRUTINA_CUERPO
    JMP COLAABA
COLAABA
    JSR BORRA
    JSR COMPRUEBA_TIEMPO   
    JSR TIEMPO  
    JSR TECLADO
    CMP.W #$25,D1
    BEQ BUCLEIZQ
    CMP.W #$27,D1
    BEQ BUCLEDER
    JMP BUCLEABAJO
AUX_ABA2
    JSR CRECER
    JMP BUCLEABAJO   
 * ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
BUCLEARRIBA
    MOVE.W (A2),D5
    SWAP D5
    MOVE.W (A4),D5
    SUB.W #1,D5
    SWAP D5
    JSR COORDENADAS_A_DIRECCION
    CMP.W #45,(A1)
    BEQ FINAL  
    CMP #30,(A1)
    BEQ FINAL
    CMP.W #50,(A1)
    BEQ AUX_ARR2
AUX_ARR    
    MOVE.W #45,(A1)   
    MOVE.W SERPX,D7
    SWAP D7
    MOVE.W SERPY,D7
    SWAP D7    
    MOVE.W D5,(A2)
    SWAP D5
    MOVE.W D5,(A4)
    SWAP D5
    JSR COORDENADAS_A_PIXEL
    JSR DIBUJAR 
CUERPOARR
    JSR SUBRUTINA_CUERPO
    JMP COLAARR
COLAARR
    JSR BORRA   
    JSR COMPRUEBA_TIEMPO 
    JSR TIEMPO
    JSR TECLADO
    CMP.W #$25,D1
    BEQ BUCLEIZQ
    CMP.W #$27,D1
    BEQ BUCLEDER
    JMP BUCLEARRIBA
AUX_ARR2
    JSR CRECER
    JMP BUCLEARRIBA
* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
FRUTA *Esta subrutina pinta fruta
    MOVE.L #80,D0
    MOVE.L #$00FF00FF,D1 # ponemos en morado el color del pen
    MOVE.L #81,D0
    MOVE.L #$00FF00FF,D1  #ponemos en morado el color de relleno     
    TRAP #15   
    JSR COORDENADAS_A_PIXEL
    MOVE.L #88,D0
    TRAP #15  
    JMP VUELTA 
* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
SERPIENTE *Esta subrutina pinta el primer valor de serpiente
    MOVE.L #80,D0
    MOVE.L #$00FFFFFF,D1 # ponemos en blanco el color del pen
    MOVE.L #81,D0
    MOVE.L #$0000FF00,D1  #ponemos en verde el color de relleno     
    TRAP #15
    JSR COORDENADAS_A_PIXEL 
    MOVE.L #87,D0
    TRAP #15
    JMP VUELTA
 * ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
FONDO *esta subrutina pinta el fondo
    MOVE.L #80,D0
    MOVE.L #$00FFFFFF,D1 # ponemos en blanco el color del pen
    MOVE.L #81,D0
    MOVE.L #$00FFFFFF,D1  #ponemos en blanco el color de relleno     
    TRAP #15
    JSR COORDENADAS_A_PIXEL
    MOVE.L #87,D0
    TRAP #15  
    JMP VUELTA   
* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
BORDE *Esta subrutina se encarga de pintar los bordes
    MOVE.L #80,D0
    MOVE.L #$00FFFFFF,D1 # ponemos en blanco el color del pen
    MOVE.L #81,D0
    MOVE.L #$000000FF,D1  #ponemos en rojo el color de relleno     
    TRAP #15
    JSR COORDENADAS_A_PIXEL 
    MOVE.L #87,D0
    TRAP #15
    JMP VUELTA
* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
GENERA_SERPIENTE *Esta subrutina crea el primer valor de serpiente (la cabeza) en la posicion (1,1)
    MOVE.L D5,-(A7)
    CLR.L D5
    MOVE.W #1,D5 #1 en la X
    SWAP D5
    MOVE.W #1,D5 #1 en la Y
    SWAP D5
    MOVE.W D5,(A2)
    SWAP D5
    MOVE.W D5,(A4)
    SWAP D5
    JSR COORDENADAS_A_DIRECCION
    MOVE #45,(A1) #ponemos valor de serpiente en la memoria
    MOVE.L #0,A1
    CLR.L D5
    MOVE.L (A7)+,D5
    RTS
* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
GENERA_BORDES_SUP_INF *Esta subrutina es la que se encarga de generar los bordes
    JMP BORDE_SUP_INF
GENERA_BORDES_LAT   
    JMP BORDE_LAT
BORDE_SUP_INF *Empieza barriendo los bordes superiores e inferiores (Primero hace la primera fila(donde y=0)
    JSR COORDENADAS_A_DIRECCION     
    MOVE.W #30,(A1) #pone valor de borde en memoria
    ADD #1,D5 #pasa a siguiente direccion
    CMP #80,D5 #compara con el final de la fila
    BEQ VUELTA_1
    JMP BORDE_SUP_INF
VUELTA_1 *si llega al final de la fila
    SWAP D5
    CMP #59,D5 *compara si el valor de y es 59(ultima fila)
    BEQ AUX #si la y vale 59, significa que hemos recorrido los dos bordes horizontales y saltamos
    MOVE.W #59,D5 *Si no es así, ponemos en y el valor 59 (ya que hemos barrido la fila para y=0 previamente
    SWAP D5
    MOVE.W #0,D5 #ponemos a 0 la X
    JMP GENERA_BORDES_SUP_INF *repetimos
AUX
    MOVE.L #0,D5 #ponemos las coordenadas a 0
    MOVE.L #0,A1
    JMP GENERA_BORDES_LAT
BORDE_LAT *el primer barrido hace todas las y para x=0, el segundo para x=79
    JSR COORDENADAS_A_DIRECCION
    MOVE.W #30,(A1) #ponemos en la direccion valor de borde
    SWAP D5
    ADD #1,D5 #sumamos 1 a la y
    CMP #60,D5 #comparamos con valor final de columna
    BEQ VUELTA_2
    SWAP D5
    JMP BORDE_LAT
VUELTA_2 *cuando acabamos la columna saltamos aqui   
    MOVE.W #0,D5 *ponemos la y a 0
    SWAP D5
    CMP #79,D5 *comprobamos el valor de X(primer barrido x=0, segundo x=79)
    BEQ AUX2 *Si vale 79, hemos acabado
    MOVE.W #79,D5 *Si no, ponemos el valor de X=79 (ultima columna) y repetimos
    JMP GENERA_BORDES_LAT
AUX2 * Al acabar, reseteamos y volvemos
    MOVE.L #0,D5
    MOVE.L #0,A1
    JMP SNAKE
* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
*Este bloque fue facilitado por el profesorado así que no vamos a entrar en detalles.
*Basicamente llamamos al bucle dos veces, una con rango 79 (para las X) y otra con rango 59 (para las Y) y guardamos esas posiciones en D5
GENERA_FRUTA
        MOVE.L D5,-(A7)
        MOVE.L D7,-(A7)
        MOVE.L #RANGO1,A5     
OTRO 
        MOVE.L A5,D0
        JSR LAB_RND
        MOVE.W D0,D5
        CMP #RANGO2,A5
        BEQ AUX_SALIR
        MOVE.L #RANGO2,A5
        SWAP D5
        JMP OTRO   
INIRND                *Esta subrutina inicializa la semilla (variable PRNL) a partir del reloj
        MOVE.L  #8,D0
        TRAP    #15
        MOVE.L D1,PRNL *En D1 obtenemos las centesimas de segundo desde media noche que asignamos a PRNL
        RTS       
LAB_RND MOVEM.L D1-D3,-(A7) ;guarda registros utilizados
 
        MOVE.L D0,D1
        ADD.L #1,D1       * calculamos el rango para un valor más (luego lo eliminamos)
        MOVE.L #$FFFF,D0
        DIVU D1,D0        * obtiene el factor de escala rango
        AND.L #$FFFF,D0   * elimina resto
        ADD.L #1,D0       * sumamos 1 al factor de escala para eliminar el posible valor de más
        MOVE.L D0,D3      * pasamos factor de escala a D3
       
        MOVE.L  PRNL,D0         * get current seed longword
        MOVEQ           #$AF-$100,d1            * set EOR value
        MOVEQ           #19,d2                  * do this 19 times
Ninc0
        ADD.L           d0,d0                           * shift left 1 bit
        BCC.S           Ninc1                           * if bit not set skip feedback
 
        EOR.B           D1,D0                           * do Galois LFSR feedback
Ninc1
        SUBQ #1,D2
        BNE             Ninc0                   * loop
 
        MOVE.L  D0,PRNL         * save back to seed longword
       
        SWAP D0          ;Obtiene la palabra alta
        AND.L #$FFFF,D0  ;Se queda con esa palabra 0-65535
       
        DIVU D3,D0       ;aplicamos factor de escala    
        AND.L #$FFFF,D0  ;Se queda solo con el cociente (solo 16 bits)
        MOVEM.L (A7)+,D1-D3
        RTS
AUX_SALIR
    SWAP D5
    JSR COORDENADAS_A_DIRECCION
    CMP #45,(A1)
    BEQ AUX_FRUTA2
    CMP #30,(A1)
    BEQ AUX_FRUTA2
    MOVE.W #50,(A1)
    MOVE.L #80,D0
    MOVE.L #$00FF00FF,D1 # ponemos en blanco el color del pen
    MOVE.L #81,D0
    MOVE.L #$00FF00FF,D1  #ponemos en blanco el color de relleno     
    TRAP #15
    JSR COORDENADAS_A_PIXEL
    MOVE.L #88,D0 #pintamos fruta circular
    TRAP #15
    CLR.L D5
    MOVE.L (A7)+,D7
    MOVE.L (A7)+,D5
    RTS
AUX_FRUTA2
    MOVE.L #0,D5
    MOVE.L #RANGO1,A5
    JMP OTRO 
* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
COORDENADAS_A_DIRECCION
    MOVE.L D6,-(A7) #guardamos el registro de lontigud
    MOVE.L D5,-(A7) #guardamos las coordenadas en la pila
    MOVE.W D5,-(A7) #guardamos las x en la pila
    MOVE.W #0,D2
    MOVE.W #0,D6
    CLR.W D5
    SWAP D5
    MOVE.W D5,D6 #registro auxiliar para guardar las y
    MULU #$A0,D5 #multiplicamos las y por 80 (por cada fila)
    ADD D5,D2
    CLR.W D5
    MOVE.W (A7)+,D5 #sacamos la coordenada X a D5
    MULU #2,D5  #Necesitas multiplicar por 2 porque necesitas tamaño W ya que nuestra matriz es de tamaño W.
    ADD #MATRIZ,D5 #Sumas el valor de la etiqueta Matriz (donde se encuentra el principio de nuestra matriz).
    MOVE.L D5,A1 #Mueves el valor que tenemos de la dirección a A1, el registro donde se almacenará el valor definitivo de la dirección.
    ADD D2,A1 #Sumamos el valor de D2 y con esto conseguimos el valor de la dirección que necesitamos.
    MOVE.L #0,D6
    MOVE.L #0,D2
    MOVE.L (A7)+,D5
    MOVE.L (A7)+,D6
    RTS
* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
COORDENADAS_A_PIXEL *Esta subrutina se encarga de apartir de las coordenadas X e Y obtener las posiciones D1-D4 para dibujar
    MOVE.W D5,D1 #movemos coordenada x a D1
    MULU #8,D1
    MOVE.W D5,D3 #movemos coordenada x a D3
    ADD #1,D3
    MULU #8,D3
    SWAP D5 #cambiamos para usar coordenada y
    MOVE.W D5,D2 #movemos coordenada y a D2
    MULU #8, D2
    MOVE.W D5,D4 #movemos coordenada y a D4
    ADD #1,D4
    MULU #8,D4
    SWAP D5    #volvemos a girar D5 para tener primero coordenada x   
    RTS
* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
TECLADO
    CLR D1    
LECTURA
    MOVE.L #19,D0 #Leemos lo que el usuario introduce mediante el teclado.
    TRAP #15 
    JSR DELAY #Introducimos un DELAY para leerlo.
    RTS   
* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
DELAY *Introduce un retraso
    MOVEM.L D0-D2,-(A7)
    MOVE.L CONTADORDELAY,D2
    MOVE.L #23,D0
    MOVE.L D2,D1
    TRAP #15
    MOVEM.L (A7)+, D0-D2
    RTS
* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
DIBUJAR 
    MOVE.L #87,D0 #El task 87 se encarga de dibujar un cuadradito usando los valores que hay en D1,D2,D3,D4. Esta subrutina la llamamos para dibujar en pantalla una vez tenemos los píxeles adecuados en los registros.
    TRAP #15
    RTS
* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
BORRA *Esta subrutina se encarga de borrar las partes de la serpiente que ya no pertenecen a la misma.Borra las coordenadas de paso de la serpiente que deben volver a ser fondo.
    MOVE.L D5,-(A7)
    MOVE.L D7,D5 #Almacenamos en D5 los valores de las coordenadas X e Y.
    JSR COORDENADAS_A_DIRECCION
    MOVE.W #$FFFF,(A1)
    MOVE.L #80,D0
    MOVE.L #$00FFFFFF,D1 # ponemos en blanco el color del pen
    MOVE.L #81,D0
    MOVE.L #$00FFFFFF,D1  #ponemos en blanco el color de relleno 
    TRAP #15    
    JSR COORDENADAS_A_PIXEL
    JSR DIBUJAR
    MOVE.L #80,D0
    MOVE.L #$00FFFFFF,D1 # ponemos en blanco el color del pen
    MOVE.L #81,D0
    MOVE.L #$0000FF00,D1  #ponemos en LIME el color de relleno     
    TRAP #15
    MOVE.L (A7)+,D5
    RTS
* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
* /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
PUNTOS *Esta subrutina se encarga de gestionar el marcador de puntuación
    MOVEM.L D0-D1/A1,-(A7)  
    MOVE.L #21,D0 #Con estas siete instrucciones, ponemos el color a blanco y el tipo de letra normal con color de relleno negro.
    MOVE.L #0,D2
    MOVE.L #$00FFFFFF,D1
    TRAP #15
    MOVE.L #81,D0
    MOVE.L #$00000000,D1
    TRAP #15
    CLR D0
    CLR D1
    MOVE.L #11,D0 #Movemos el cursos a donde lo necesitamos para escribir la puntuación del usuario.
    MOVE.L #$2521,D1
    TRAP #15    
    MOVE.L #14,D0
    MOVE.L #MOSTRARPUNTUACION,A1
    TRAP #15    
    MOVE.L #3,D0 #Mostramos la puntuación que lleva el usuario con el task 3.
    MOVE.L PUNTUACION,D1
    TRAP #15           
    MOVEM.L (A7)+,D0-D1/A1
    RTS
* ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
TIEMPO *Esta subrutina se encarga de gestionar el marcador de tiempo
    MOVEM.L D0-D2/A1,-(A7)
**Con estas siete instrucciones, ponemos el color a blanco y el tipo de letra normal con color de relleno negro.
    MOVE.L #21,D0
    MOVE.L #0,D2
    MOVE.L #$00FFFFFF,D1
    TRAP #15
    MOVE.L #81,D0
    MOVE.L #$00000000,D1
    TRAP #15
    CLR D0
    CLR D1
    MOVE.L #11,D0 #Movemos el cursos a donde lo necesitamos para escribir.
    MOVE.L #$0521,D1
    TRAP #15         
    MOVE.L #8,D0 #Sacamos el tiempo del sistema como hemos mencionado antes usando el task 8.
    TRAP #15    
    MOVE.L ENDTIME,D2 #Movemos el valor del tiempo total a D2
    SUB.L D1,D2 #Al realizar esta resta, obtendremos en D2 el valor el tiempo que le queda al usuario para jugar.
    MOVE.L D2,D1
    DIVU #100,D1 #Divimos por 100 ya que el resutado nos viene en centésimas de segundo.
    SWAP D1 #Con estas 3 instrucciones consecutivas (SWAP CRL SWAP) borramos el signo de la resta. Es decir, al realizar la resta se pone FFFF en los 2 bytes más significativos de D1 y hay que borrarlo.
    CLR.W D1
    SWAP D1
    CMP.L #9,D1 #Comparamos con 9 ya que este sistema muestra bien los números hasta el 10, pero a partir del 10, muestra 90,80,70... así que hay que modificar el bloque.
    BLE AUX_TIEMPO #Saltamos al bloque modificado para mostrar 9,8,7,6,5,4,3,2,1,0.
VOLVER_TIEMPO
    MOVE.L #3,D0 #Muestra el tiempo.
    TRAP #15    
    MOVE.L #80,D0
    MOVE.L #$00FFFFFF,D1 # ponemos en blanco el color del pen
    MOVE.L #81,D0
    MOVE.L #$0000FF00,D1  #ponemos en LIME el color de relleno     
    TRAP #15        
    MOVEM.L (A7)+,D0-D2/A1
    RTS
AUX_TIEMPO
**Esta subrutina muestra los números entre 10 y 0 de forma adecuada.
    MOVE.L D1,D2
    MOVE.L #0,D1
    MOVE.L #3,D0 #Primero mostramos un 0 para después poner el número real. Es decir, ponemos 0 y luego con las instrucciones siguientes el 9 para que quede 09.
    TRAP #15
    MOVE.L #11,D0
    MOVE.L #$0621,D1 #Desplazamos el cursor una unidad a la derecha.
    TRAP #15   
    MOVE.L D2,D1
    JMP VOLVER_TIEMPO
* ///////////////////////////////////////////////////////////////////////
* ///////////////////////////////////////////////////////////////////////
**En estos dos bloques FINAL y FINAL2, se creará la pantalla de GAMEOVER que aparecerá cuando el usuario pierda.
FINAL2
**Este final ocurrirá cuando se acabe el tiempo de juego.
    MOVE.L #11,D0 #Ponemos la pantalla a negro como hemos mencionado antes, asignándole el valor hexadecimal #$FF00 a D1 y usando el task 11
    MOVE.W #$FF00,D1
    TRAP #15   
    MOVE.L #70,D0 #Activamos el sonido que debe sonar cuando se agota el tiempo de juego, almacenado en la etiqueta NOTIME.
    MOVE.L #NOTIME,A1
    TRAP #15   
    MOVE.L #23,D0 
    MOVE.L #200,D1
    TRAP #15
    MOVE.L #76,D0 #Paramos el sonido activo.
    MOVE.L #3,D2
    TRAP #15     
FINAL 
    MOVE.L #76,D0 #Paramos todos los sonidos.
    MOVE.L #3,D2
    TRAP #15
    MOVE.L #11,D0 #Ponemos la pantalla a negro para mostrar posteriormente las frases que queremos mostrar.
    MOVE.W #$FF00,D1
    TRAP #15   
    MOVE.L #70,D0 #Activamos el sonido de GAME OVER, almacenado en la etiqueta YOULOSE.
    MOVE.L #YOULOSE,A1
    TRAP #15    
    MOVE.B #33,D0
    MOVE.L #640*$10000+480,D1 #Con estas tres instrucciones asignamos el tamaño que queremos a la pantalla de nuevo.
    TRAP #15   
    MOVE.L #21,D0 #Ponemos el color del pen y de relleno por defecto (escribe en blanco $00FFFFFF y el fondo negro $00000000) usando el task 21 Y 81.
    MOVE.L #$00FFFFFF,D1
    MOVE.L #$0000000,D2
    TRAP #15
    MOVE.L #81,D0
    MOVE.L #$00000000,D1
    TRAP #15
** Otra vez movemos los valores de las direcciones de memoria donde se encuentran las frases que queremos escribir en pantalla a A1 para mostrarlas en las coordenadas asignadas con el task 95. 
    MOVE.L #GAMEOVER,A1    
    MOVE.L #95,D0
    MOVE.W #280,D1
    MOVE.W #240,D2
    TRAP #15 
    MOVE.L #TRYAGAIN,A1    
    MOVE.L #95,D0
    MOVE.W #200,D1
    MOVE.W #260,D2
    TRAP #15
    CLR D1
    CLR D0  
    MOVE.L #11,D0 #Como lo que queremos mostrar en pantalla ahora es un número que puede variar, no podemos usar el task 95.Sin embargo, usaremos el 11 para poner el cursor donde queremos y escribir.
    MOVE.W #$2715,D1 #Asignamos columna ($27) y fila ($15) al registro D1. Ahí es donde se coloca nuestro cursor.
    TRAP #15      
    MOVE.L #3,D0 #Con estas tres instrucciones mostramos la puntuación obtenida en el juego.
    MOVE.L PUNTUACION,D1 #El detalle de esta instrucción es la carencia de # antes de la etiqueta. Esto se debe a que queremos el valor almacenado, no su dirección.
    TRAP #15
    JSR REINICIO #Saltamos a una subrutina que reinicia los valores que se usan para generar la matriz y los demás elementos. Es necesario porque si el usuario quiere intentarlo de nuevo, se deben limpiar los valores antiguos.
    JMP RETRY #Saltamos a la subrutina que permite que el usuario pruebe de nuevo.
* ////////////////////////////////////////////////////////////////////////////////////////////////////////
* ////////////SUBRUTINA ENCARGADA DE LIMPIAR LA MATRIZ PARA PODER JUGAR DE NUEVO//////////////////////////
REINICIO 
**Limpia los registros para el reinicio de la matriz.
    MOVEM.L A5-A6,-(A7)
    MOVE.L #0,A5 
    MOVE.L #0,A6
    MOVE.L #MATRIZ,A6
    ADD.L A6,A5 #guardamos en A5 el final de la matriz como auxiliar
    ADD.L #9600,A5 #sumamos 9600 ya que es el valor total de matriz, (80*60 posiciones) * 2 (tamaño .w)
BUCLE_REINICIO
    MOVE.W #$FFFF,(A6) #vaciamos la matriz
    ADD #2,A6 #apuntamos a la siguiente posicion de matriz
    CMP.L A6,A5 #comparamos con el final de matriz
    BEQ SALIR_REI #si es el final, salimos de la subrutina
    JMP BUCLE_REINICIO
SALIR_REI
    MOVEM.L (A7)+,A5-A6
    RTS
* ///////////////////////////////////////////////////////////////////////
* ///////////////////////////////////////////////////////////////////////
RETRY  
**Esta subrutina se encarga de darle la oportunidad de probar otra vez al usuario.
    MOVE.L #11,D0
    MOVE.W #$0000,D1 #Colocamos el cursor en la posición (0,0) con estas tres instrucciones y el task 11.
    TRAP #15
    MOVE.L #21,D0
    MOVE.L #$00000000,D1 #Como ya hemos comentado antes, el task 5 genera una barra baja para que el usuario escriba en ella. Para ocultarla, cambiamos el color del pen a negro.
    TRAP #15  
    MOVE.L #5,D0 #Esperamos a que el usuario pulse con el task 5.   
    TRAP #15    
    CMP.L #$52,D1 #Comparamos con el valor $52-R y el $72-r para saber si el usuario quiere comenzar de nuevo.
    BEQ START1
    CMP.L #$72,D1
    BEQ START1 #Saltamos al principio del programa
    BNE RETRY 
* /////////////////////////////////////////////////////////////////////// 
    *ETIQUETAS
SERPX DS.W 1000 #Almacén de las X.
SERPY DS.W 1000 #Almacén de las Y.
MATRIZ DS.W 80*60  #Matriz
PRNL    DS.L 1
CONTADORDELAY DS.L 4 #Velocidad de nuestra serpiente.
GAMEOVER DC.B 'GAME OVER',0
MOSTRARPUNTUACION DC.B 'SCORE ',0
PUNTUACION DS.L 4 #Puntuación obtenida por el usuario.
TRYAGAIN DC.B 'PRESS R TWICE TO TRY AGAIN ',0
MODONORMAL DC.B 'NORMAL MODE (1) ',0
MODORAPIDO DC.B 'FLEETING MODE (2) ',0
MODOSKIN DC.B 'SHED MODE (3) ',0
TITULO DC.B 'SNAKE',0
PULSA DC.B 'SELECT ONE MODE: ',0
MODOEXTREMO DC.B 'EXTREME MODE (4) ',0
EMPEZAR DC.B 'PRESS ANY KEY TO START ',0
WELCOME DC.B '240210_shahabazkhan_welcome-to-the-game_mp3cut_net.wav',0 #Las siguientes etiquetas se corresponden a los audios empleados en el programa.
COMER DC.B '186376_pasalo92_comer_mp3cut_net_.wav',0
YOULOSE DC.B '178875__rocotilos__you-lose-evil.wav',0
SILENCIO DC.B '201883_parcodeisuoni_silence.wav',0
MUSICAMENU DC.B '384308_frankum_epic-chorus-song-no-flangerfx-probl (1).wav',0
NOTIME DC.B 'ail.wav',0 
MODO DS.W 1 #Modo de juego (1,2,3,4)
ENDTIME DS.L 1 #Tiempo final de juego
TIEMPOJUEGO DS.W 1 #Tiempo que tiene el jugador para comer la fruta
* ///////////////////////////////////////////////////////////////////////    
    END START







    


















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
