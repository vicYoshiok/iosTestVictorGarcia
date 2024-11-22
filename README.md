# Examen iOs victor garcia
Prueba de conocimientos iOS y swift 


## Descripción



Este proyecto es una aplicación para gestionar las ubicaciones de los usuarios en tiempo real usando Firebase y MapKit en iOS. 
Permite a los usuarios subir y consultar imágenes relacionadas con sus ubicaciones. 
También consume un servicio de peliculas y muestra lo obtenidop en una tabla, al pulsar una celda muestra los detalles.


## Características

- Funciones de geolocalización con MapKit y Firebase
- Subida de imágenes a Firebase Storage

## Requisitos

Lista de los requisitos necesarios para ejecutar el proyecto:

- **Xcode** versión 12 o superior
- **iOS 14** o superior
- **CocoaPods** o **Swift Package Manager** para dependencias
- **Firebase SDK** (Firebase Authentication, Firestore, Storage)

## Preguntas adicionales de la prueba
- ¿que es el ARC? y en que casos se usa Strong, weak y unknowed
  EL ARC (Automatic reference counting) es un mecanismo automatico para administrar la memoria, administrando a su vez el ciclo de vida de los objetos de una aplicación.
  El ARC va sumando 1 a un contador acorde al tipo de referencia que el objeto tenga (Strong weak o unknowed)
  strong: suma uno al contador y mientras este se mantenga el contado no baja
  weak: no suma al contador al ser opcional permite que al liberarse sea automaticamente nil
  unknowed: parecidas a las weak pero no pueden ser nulas
  
- Explica el ciclo de vida de una aplicación:
  el ciclo de vida es el siguiente:
  inactiva --> activa --> suspendida o en tarea de segundo plano --> terminada
  cuando esta activa se ejecutan metodos en el appdelegate o scenedelegate como applicationDidBecomeActive() y sceneDidBecomeActive(_:)
  cuando esta en bacground se ejecutan metodos como applicationDidEnterBackground() 
  Cuando la app está en segundo plano y no está realizando ninguna tarea activa, se suspende. si regresa a primer plano se ejecutan metodos como willenterIntheForeground()
  terminate es el estado de finalización se ejecutan metodos como applicationWillTerminate()

  -Explica el ciclo de vida de un controlador
  init para iniciarlo y viewDidLoad()    para la configuracion inicial, despues se ejecutan viewWillAppear() justo antes de aparecer y viewDidAppear() despues de que aparece para cargar datos y animaciones depende de lo que necesites
  posteriormente al desaparecer se ejecutan viewWillDisappear() y viewDidDisappear( ) antes y despues de desaparecer donde puedes realizar acciones como guardar datos o limpiar objetos
  cuando un controlador apare nuevamente en primer plano, el viewdidload no se ejecuta de nuevo, unicamente los metodos appear
  
  
