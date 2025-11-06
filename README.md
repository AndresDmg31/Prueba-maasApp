  # Prueba-maasApp

  Aplicación de prueba técnica desarrollada en **Swift** para consultar información de tarjetas **TuLlave** y
  mostrar paraderos de transporte público cercanos usando el servicio **OpenTripPlanner**.

  ### Arquitectura
  VIPER

  ### Funcionalidades
  - Registro y validación de tarjetas TuLlave desde un API externo
  - Consulta de nombre, perfil y saldo de cada tarjeta
  - Almacenamiento local de tarjetas en el dispositivo
  - Eliminación y selección de múltiples tarjetas
  - Visualización de paraderos cercanos en mapa
  - Interfaz construida con UIKit

  ### Notas de Uso
  - **Para mejor funcionalidad**: Se recomienda utilizar dispositivos físicos, ya que el simulador de Xcode no
  redirige correctamente la ubicación actual
  - **Ubicación actual**: La aplicación utiliza por defecto la ubicación actual del usuario
  - **Ubicación por defecto para pruebas**: Si desea utilizar una ubicación por defecto en el Presenter de
  NearbyStop se encuentra la documentación con una ubicación por defecto en este caso Bogotá centro, puede modificar
   coordenadas para hacer pruebas

  ### Tecnologías
  Swift  · UIKit · URLSession · MapKit · UserDefaults

  ### Autor
  Andrés Martínez – iOS Developer
