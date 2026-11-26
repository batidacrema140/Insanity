
// Establece la sección actual a partida y deja todo como al principio de la semana

void iniciarPartida()
{
  energía  = 95;
  ansiedad = 15;
  
  reloj = 8;
  
  tareasPendientes  = TAREAS_INICIALES;
  tareasCompletadas = 0;
  
  díaÚltimaLectura = -1;
  últimaAcción     = ACCIÓN_NINGUNA;
  horaÚltimaComida = -100;
  usosTeléfono     = 0;
  máximaAnsiedad   = ansiedad;
  
  plantaUsada = new boolean[3];
  puntos      = new int[3];
  
  insomnio        = false;
  semanaTerminada = false;
  derrota         = false;
  finalIniciado   = false;
  enTransición    = false;
  minijuegoActivo = false;
  
  últimoMinijuego = -1;
  
  aviso          = "";
  avisoPendiente = "";
  notaAviso      = "";
  
  direcciónPersonaje = 6;
  
  reiniciarLogrosPartida();
  
  iniciarHabitación();
  iniciarPersonaje(ANCHO / 2, 820);
  iniciarTarjeta(tarjetaCómic);
  
  secciónActual = 1;
}

// Ciclo principal de la partida

void administrarPartida()
{
  background(fondoEscenario);
  
  if (estáActivaTarjeta)
  {
    mostrarTarjeta();
  }
    else
  {
    administrarJuego();
  }
  
  mostrarLogroNuevo();
}

// Lo que se ve cuando no hay una tarjeta

void administrarJuego()
{
  if (semanaTerminada || derrota)
  {
    mostrarFinal();
  }
    else
  {
    if (minijuegoActivo)
    {
      administrarMinijuego();
    }
      else
    {
      administrarEscenario();
      
      mostrarEtiquetaObjeto();
      
      mostrarBarras();
      mostrarReloj();
      mostrarTareas();
      
      mostrarAvisoActual();
      mostrarTransición();
    }
  }
}

void administrarEscenario()
{
  actualizarObjetos();
  
  dibujarObjetos(false);
  
  moverPersonaje();
  mostrarPersonaje();
  
  dibujarObjetos(true);
  
  mostrarSalidas();
  
  comprobarSalidas();
}

// Acciones si se presiona algún elemento

void administrarClicksPartida()
{
  if (estáActivaTarjeta)
  {
    intentarCerrarTarjeta();
  }
    else
  {
    administrarClicksJuego();
  }
}

// Clicks cuando no hay una tarjeta

void administrarClicksJuego()
{
  if (semanaTerminada || derrota)
  {
    if (cronómetro() > 8)
    {
      iniciarMenú();
    }
  }
    else
  {
    if (minijuegoActivo)
    {
      administrarClicksMinijuego();
    }
      else
    {
      if (!enTransición)
      {
        administrarClicksObjeto();
      }
    }
  }
}

// Hay que estar cerca del objeto para usarlo

void administrarClicksObjeto()
{
  if (objetoEnfocado >= 0 && !estáCercaDeObjeto(objetoEnfocado))
  {
    mostrarAviso("Acércate más para usar: " + objetoNombre[objetoEnfocado]);
  }
    else
  {
    switch (escenarioActual)
    {
      case 0:
        administrarClicksHabitación();
      break;
      
      case 1:
        administrarClicksSala();
      break;
      
      case 2:
        administrarClicksCocina();
      break;
    }
  }
}
