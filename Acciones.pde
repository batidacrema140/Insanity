
int díaActual()
{
  return reloj / 24;
}

int horaActual()
{
  return reloj % 24;
}

boolean esDeNoche()
{
  return horaActual() >= HORA_MÍNIMA_DORMIR || horaActual() < HORA_DESPERTAR;
}

// Si la ansiedad llega a 100 se pierde la partida

void modificarAnsiedad(int cambio)
{
  ansiedad = constrain(ansiedad + cambio, 0, 100);
  
  if (ansiedad > máximaAnsiedad)
  {
    máximaAnsiedad = ansiedad;
  }
  
  if (ansiedad >= 100)
  {
    derrota = true;
  }
}

void modificarEnergía(int cambio)
{
  energía = constrain(energía + cambio, 0, 100);
}

void sumarPuntos(int categoría, int cantidad)
{
  puntos[categoría] += cantidad;
}

// Puntuación total

int puntuaciónTotal()
{
  int extra = 0;
  
  if (!derrota)
  {
    extra = (100 - ansiedad) / 5;
  }
  
  return puntos[PUNTOS_RESPONSABILIDAD] + puntos[PUNTOS_BIENESTAR] + puntos[PUNTOS_TELÉFONO] + extra;
}

// Agrega una línea al aviso que se muestra al cerrar la tarjeta

void agregarNota(String nota)
{
  if (notaAviso.length() == 0)
  {
    notaAviso = nota;
  }
    else
  {
    notaAviso = notaAviso + "\n" + nota;
  }
}

// Avanza el reloj hora por hora para no saltarse ninguna medianoche

void avanzarReloj(int horas)
{
  for (int i = 0; i < horas && !semanaTerminada && !derrota; i++)
  {
    reloj++;
    
    if (reloj >= HORAS_SEMANA)
    {
      reloj = HORAS_SEMANA;
      semanaTerminada = true;
    }
      else
    {
      if (reloj % 24 == 0)
      {
        comenzarNuevoDía();
      }
    }
  }
}

void comenzarNuevoDía()
{
  if (tareasPendientes > 0)
  {
    modificarAnsiedad(ANSIEDAD_POR_TAREA_ATRASADA * tareasPendientes);
    sumarPuntos(PUNTOS_RESPONSABILIDAD, PUNTOS_TAREA_ATRASADA * tareasPendientes);
    
    agregarNota("Tareas sin hacer: " + tareasPendientes + ". ¡Se acumulan y te pesan!");
  }
  
  tareasPendientes += 1;
}

// Guarda cómo estaba todo para poder mostrar qué cambió

void comenzarAcción()
{
  energíaAntes  = energía;
  ansiedadAntes = ansiedad;
  relojAntes    = reloj;
}

// Muestra la tarjeta y deja listo el resumen de cambios para cuando se cierre

void terminarAcción(PImage tarjeta)
{
  String resumen =
    "Energía: " + (energía - energíaAntes) +
    "   |   Ansiedad: " + (ansiedad - ansiedadAntes) +
    "   |   Tiempo: " + (reloj - relojAntes) + " h";

  avisoPendiente = resumen;

  if (notaAviso.length() > 0)
  {
    avisoPendiente = notaAviso + "\n" + resumen;
  }

  notaAviso = "";

  iniciarTarjeta(tarjeta);
}

// Gasta tiempo y cambia la energía, la ansiedad y los puntos

void realizarActividad(PImage tarjeta, int acción, int horas, int cambioEnergía, int cambioAnsiedad, int categoría, int puntosGanados)
{
  comenzarAcción();

  modificarEnergía(cambioEnergía);
  modificarAnsiedad(cambioAnsiedad);
  sumarPuntos(categoría, puntosGanados);

  últimaAcción = acción;

  avanzarReloj(horas);

  terminarAcción(tarjeta);
}

void usarCama()
{
  int hora = horaActual();

  if (hora < HORA_MÍNIMA_DORMIR && hora >= HORA_DESPERTAR)
  {
    mostrarAviso("Todavía no tienes sueño. Solo puedes dormir desde las " + HORA_MÍNIMA_DORMIR + ":00.");
  }
    else
  {
    dormir();
  }
}

// Da energía y pasa las horas hasta las 7
// Si hay insomnio, primero se pasan unas horas despierto

void dormir()
{
  int hora = horaActual();

  comenzarAcción();

  if (insomnio)
  {
    insomnio = false;

    modificarAnsiedad(ANSIEDAD_INSOMNIO);
    agregarNota("Insomnio: diste vueltas " + HORAS_INSOMNIO + " h sin poder dormir.");

    desbloquearLogro(LOGRO_INSOMNIO);

    avanzarReloj(HORAS_INSOMNIO);
    hora = horaActual();
  }

  // Si el insomnio duró hasta que amaneció no se duerme

  int horasDormidas = 0;

  if (hora >= HORA_MÍNIMA_DORMIR || hora < HORA_DESPERTAR)
  {
    horasDormidas = (HORA_DESPERTAR - hora + 24) % 24;

    boolean aTiempo = hora >= HORA_MÍNIMA_DORMIR;

    if (aTiempo)
    {
      sumarPuntos(PUNTOS_BIENESTAR, PUNTOS_DORMIR_A_TIEMPO);
    }
      else
    {
      sumarPuntos(PUNTOS_BIENESTAR, PUNTOS_DORMIR_TARDE);
    }

    if (hora >= HORA_MÍNIMA_DORMIR && hora <= HORA_MÍNIMA_DORMIR + 2)
    {
      desbloquearLogro(LOGRO_DORMIR_TEMPRANO);
    }
  }
    else
  {
    agregarNota("Ya amaneció.");
  }

  modificarEnergía(horasDormidas * ENERGÍA_POR_HORA_DE_SUEÑO);

  últimaAcción = ACCIÓN_OTRA;

  avanzarReloj(horasDormidas);

  terminarAcción(tarjetaDurmiendo);
}

// Leer antes el mismo día hace estudiar más fácil

int energíaNecesariaParaEstudiar()
{
  int energíaNecesaria = ENERGÍA_ESTUDIAR;

  if (díaÚltimaLectura == díaActual())
  {
    energíaNecesaria = ENERGÍA_ESTUDIAR_TRAS_LEER;
  }

  return energíaNecesaria;
}

void usarEscritorio()
{
  if (energía < energíaNecesariaParaEstudiar())
  {
    mostrarAviso("Estás demasiado cansado para estudiar. Lee un rato o descansa.");
  }
    else
  {
    iniciarMinijuego();
  }
}

// Rendir bien estresa menos, rendir mal estresa más, y las distracciones y estudiar sin pausa suman

void terminarEstudio()
{
  float rendimiento = rendimientoMinijuego;
  
  boolean leyóHoy = díaÚltimaLectura == díaActual();
  
  int costoEnergía = ENERGÍA_ESTUDIAR;
  int ansiedadBase = ANSIEDAD_ESTUDIAR;
  
  if (leyóHoy)
  {
    costoEnergía = ENERGÍA_ESTUDIAR_TRAS_LEER;
    ansiedadBase = ANSIEDAD_ESTUDIAR_TRAS_LEER;
  }
  
  int estrés = round(ansiedadBase * (1.5 - rendimiento));
  
  agregarNota("Rendimiento: " + round(rendimiento * 100) + " %");
  
  if (leyóHoy)
  {
    agregarNota("Haber leído hoy hizo el estudio más fácil.");
  }
  
  if (distraccionesMinijuego > 0)
  {
    estrés += distraccionesMinijuego * ANSIEDAD_POR_DISTRACCIÓN;
    
    agregarNota("Notificaciones tocadas: " + distraccionesMinijuego + ". ¡El teléfono te distrajo!");
  }
  
  if (últimaAcción == ACCIÓN_ESTUDIAR)
  {
    estrés += ANSIEDAD_ESTUDIAR_SEGUIDO;
    agregarNota("¡Estudiar sin pausa te agobia!");
  }
  
  int puntosGanados;
  
  if (rendimiento >= UMBRAL_TAREA)
  {
    if (tareasPendientes > 0)
    {
      tareasPendientes  -= 1;
      tareasCompletadas += 1;
      
      puntosGanados = PUNTOS_TAREA_COMPLETADA + round(PUNTOS_BONO_RENDIMIENTO * rendimiento);
      
      agregarNota("¡Tarea completada!");
      desbloquearLogro(LOGRO_PRIMERA_TAREA);
    }
      else
    {
      puntosGanados = PUNTOS_ESTUDIAR_ADELANTADO;
      
      agregarNota("Adelantaste trabajo para otro día.");
    }
  }
    else
  {
    puntosGanados = PUNTOS_TAREA_FALLIDA;

    if (tareasPendientes > 0)
    {
      agregarNota("La tarea no quedó bien: tendrás que repetirla.");
    }
      else
    {
      agregarNota("No salió bien, pero practicar ayuda.");
    }
  }
  
  realizarActividad(tarjetaEstudiando, ACCIÓN_ESTUDIAR, HORAS_ESTUDIAR, -costoEnergía, estrés, PUNTOS_RESPONSABILIDAD, puntosGanados);
}

void usarLibrería()
{
  díaÚltimaLectura = díaActual();
  
  lecturas += 1;
  
  if (lecturas >= 5)
  {
    desbloquearLogro(LOGRO_LECTOR);
  }
  
  realizarActividad(tarjetaLeyendo, ACCIÓN_OTRA, HORAS_LEER, -ENERGÍA_LEER, ANSIEDAD_LEER, PUNTOS_RESPONSABILIDAD, PUNTOS_LEER);
}

// Venerar a las tres completa el culto secreto

String[] textoOfrenda = {
  "Planteus acepta tu ofrenda. Sientes que sus hojas te escuchan.",
  "Una segunda Planteus susurra tu nombre entre las hojas...",
  "¡Las tres Planteus están contigo! El culto está completo."
};

void usarPlanta(int escenario, int objeto)
{
  if (!plantaUsada[escenario])
  {
    venerarPlanta(escenario, objeto);
  }
}

void venerarPlanta(int escenario, int objeto)
{
  plantaUsada[escenario] = true;
  objetoActivo[objeto]   = false;
  
  int veneradas = 0;
  
  for (int i = 0; i < plantaUsada.length; i++)
  {
    if (plantaUsada[i])
    {
      veneradas += 1;
    }
  }
  
  agregarNota(textoOfrenda[veneradas - 1]);
  
  desbloquearLogro(LOGRO_OFRENDA);
  
  int cambioAnsiedad = ANSIEDAD_PLANTA;
  int puntosGanados  = PUNTOS_PLANTA;
  
  if (veneradas == plantaUsada.length)
  {
    cambioAnsiedad += ANSIEDAD_CULTO;
    puntosGanados  += PUNTOS_CULTO;

    desbloquearLogro(LOGRO_CULTO);
  }
  
  realizarActividad(tarjetaPlanteus, ACCIÓN_OTRA, HORAS_PLANTA, 0, cambioAnsiedad, PUNTOS_BIENESTAR, puntosGanados);
}

void usarTeléfono()
{
  boolean deNoche = esDeNoche();
  
  int mínimo = HORAS_TELÉFONO_MÍNIMO;
  int máximo = HORAS_TELÉFONO_MÁXIMO;
  float probabilidadInsomnio = PROBABILIDAD_INSOMNIO_DÍA;
  
  if (deNoche)
  {
    mínimo = HORAS_TELÉFONO_NOCHE_MÍNIMO;
    máximo = HORAS_TELÉFONO_NOCHE_MÁXIMO;
    probabilidadInsomnio = PROBABILIDAD_INSOMNIO_NOCHE;
  }
  
  int horas = (int) random(mínimo, máximo + 1);
  
  int puntosGanados = PUNTOS_USAR_TELÉFONO;
  
  if (deNoche)
  {
    puntosGanados += PUNTOS_TELÉFONO_NOCHE;

    agregarNota("¡Trasnochaste con el teléfono!");
    desbloquearLogro(LOGRO_TRASNOCHADOR);
  }
  
  if (random(1) < probabilidadInsomnio)
  {
    insomnio = true;
    agregarNota("La pantalla te dejó la mente acelerada...");
  }
  
  usosTeléfono += 1;
  
  realizarActividad(tarjetaCelular, ACCIÓN_OTRA, horas, ENERGÍA_TELÉFONO, ANSIEDAD_TELÉFONO, PUNTOS_TELÉFONO, puntosGanados);
}

void usarChimenea()
{
  realizarActividad(tarjetaChimenea, ACCIÓN_OTRA, HORAS_CHIMENEA, ENERGÍA_CHIMENEA, ANSIEDAD_CHIMENEA, PUNTOS_BIENESTAR, PUNTOS_CHIMENEA);
}

void usarSofá()
{
  realizarActividad(tarjetaSofá, ACCIÓN_OTRA, HORAS_SOFÁ, ENERGÍA_SOFÁ, ANSIEDAD_SOFÁ, PUNTOS_BIENESTAR, PUNTOS_SOFÁ);
}

void usarTelevisión()
{
  realizarActividad(tarjetaTV, ACCIÓN_OTRA, HORAS_TV, ENERGÍA_TV, ANSIEDAD_TV, PUNTOS_BIENESTAR, PUNTOS_TV);
}

void usarCocinar()
{
  if (reloj - horaÚltimaComida < HORAS_ENTRE_COMIDAS)
  {
    mostrarAviso("Todavía estás lleno. Espera un poco para volver a cocinar.");
  }
    else
  {
    realizarActividad(tarjetaCocinando, ACCIÓN_OTRA, HORAS_COCINAR, ENERGÍA_COCINAR, ANSIEDAD_COCINAR, PUNTOS_BIENESTAR, PUNTOS_COCINAR);

    mostrarPlato(platoPasta, "Pasta");

    horaÚltimaComida = reloj;
  }
}

void usarNevera()
{
  if (reloj - horaÚltimaComida < HORAS_ENTRE_PICOTEOS)
  {
    mostrarAviso("Acabas de comer. Todavía no tienes hambre.");
  }
    else
  {
    // Muy temprano
    
    if (horaActual() < 5)
    {
      desbloquearLogro(LOGRO_ASALTO_NEVERA);
    }
    
    realizarActividad(tarjetaComiendo, ACCIÓN_OTRA, HORAS_NEVERA, ENERGÍA_NEVERA, ANSIEDAD_NEVERA, PUNTOS_BIENESTAR, PUNTOS_NEVERA);
    
    mostrarPlato(platoSándwich, "Sándwich de queso");
    
    horaÚltimaComida = reloj;
  }
}
