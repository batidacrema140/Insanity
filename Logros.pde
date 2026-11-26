
// Los logros conseguidos

int LOGRO_PRIMERA_TAREA   =  0;
int LOGRO_CERO_PENDIENTES =  1;
int LOGRO_EXPLORADOR      =  2;
int LOGRO_DORMIR_TEMPRANO =  3;
int LOGRO_LECTOR          =  4;
int LOGRO_OFRENDA         =  5;
int LOGRO_CULTO           =  6;
int LOGRO_CALCULISTA      =  7;
int LOGRO_ORTÓGRAFO       =  8;
int LOGRO_MEMORIA         =  9;
int LOGRO_ENFOQUE         = 10;
int LOGRO_MODO_AVIÓN      = 11;
int LOGRO_NOTIFICADO      = 12;
int LOGRO_DESINTOXICACIÓN = 13;
int LOGRO_TRASNOCHADOR    = 14;
int LOGRO_INSOMNIO        = 15;
int LOGRO_ASALTO_NEVERA   = 16;
int LOGRO_AL_BORDE        = 17;
int LOGRO_ZEN             = 18;
int LOGRO_FINAL_BUENO     = 19;
int LOGRO_FINAL_NORMAL    = 20;
int LOGRO_FINAL_MALO      = 21;
int LOGRO_COLAPSO         = 22;
int LOGRO_ENSUEÑO         = 23;

void definirLogro(int logro, String nombre, String descripción, boolean secreto)
{
  logroNombre[logro]      = nombre;
  logroDescripción[logro] = descripción;
  logroSecreto[logro]     = secreto;
}

void iniciarLogros()
{
  definirLogro(LOGRO_PRIMERA_TAREA,   "Primera tarea",        "Completa tu primera tarea.", false);
  definirLogro(LOGRO_CERO_PENDIENTES, "Cero pendientes",      "Termina la semana sin ninguna tarea pendiente.", false);
  definirLogro(LOGRO_EXPLORADOR,      "Explorador",           "Visita la habitación, la sala y la cocina.", false);
  definirLogro(LOGRO_DORMIR_TEMPRANO, "A dormir temprano",    "Acuéstate entre las 20:00 y las 22:00.", false);
  definirLogro(LOGRO_LECTOR,          "Ratón de biblioteca",  "Lee 5 veces en una misma semana.", false);
  definirLogro(LOGRO_OFRENDA,         "Primera ofrenda",      "Venera a una Planteus.", false);
  definirLogro(LOGRO_CULTO,           "El culto de Planteus", "Venera a las tres Planteus en una misma semana.", true);
  definirLogro(LOGRO_CALCULISTA,      "Calculadora humana",   "Saca 100 % en una tarea de cálculo.", false);
  definirLogro(LOGRO_ORTÓGRAFO,       "Ortografía impecable", "Saca 100 % en una tarea de ortografía.", false);
  definirLogro(LOGRO_MEMORIA,         "Memoria de elefante",  "Saca 100 % en una tarea de memoria.", false);
  definirLogro(LOGRO_ENFOQUE,         "Mente enfocada",       "Saca 100 % en una tarea de concentración.", false);
  definirLogro(LOGRO_MODO_AVIÓN,      "Modo avión",           "Completa una tarea ignorando al menos 3 notificaciones.", false);
  definirLogro(LOGRO_NOTIFICADO,      "Adicto a los avisos",  "Toca 5 notificaciones en una misma semana.", false);
  definirLogro(LOGRO_DESINTOXICACIÓN, "Desintoxicación",      "Termina la semana sin usar el teléfono ni una vez.", false);
  definirLogro(LOGRO_TRASNOCHADOR,    "Trasnochador",         "Usa el teléfono de noche.", false);
  definirLogro(LOGRO_INSOMNIO,        "Ojos como platos",     "Sufre insomnio por culpa de la pantalla.", false);
  definirLogro(LOGRO_ASALTO_NEVERA,   "Asalto a la nevera",   "Abre la nevera de madrugada.", true);
  definirLogro(LOGRO_AL_BORDE,        "Al borde del abismo",  "Llega a 90 de ansiedad y aun así termina la semana.", true);
  definirLogro(LOGRO_ZEN,             "Zen total",            "Termina la semana con 20 de ansiedad o menos.", false);
  definirLogro(LOGRO_FINAL_BUENO,     "Final bueno",          "Consigue el mejor final.", false);
  definirLogro(LOGRO_FINAL_NORMAL,    "Final normal",         "Consigue el final normal.", false);
  definirLogro(LOGRO_FINAL_MALO,      "Final malo",           "Consigue el peor final sin que te gane la ansiedad.", false);
  definirLogro(LOGRO_COLAPSO,         "Colapso",              "Deja que tu ansiedad llegue a 100.", false);
  definirLogro(LOGRO_ENSUEÑO,         "Semana de ensueño",    "Consigue una puntuación casi perfecta.", true);
}

// Borra lo que se haya conseguido en la partida anterior

void reiniciarLogrosPartida()
{
  logroEnPartida = new boolean[TOTAL_LOGROS];

  lecturas              = 0;
  notificacionesTocadas = 0;

  logrosEnCola = 0;
  logroVisible = -1;

  escenarioVisitado = new boolean[3];
  escenarioVisitado[ESCENARIO_HABITACIÓN] = true;
}

void desbloquearLogro(int logro)
{
  if (!logroEnPartida[logro])
  {
    logroEnPartida[logro] = true;
    
    if (!logroDesbloqueado[logro])
    {
      logroDesbloqueado[logro] = true;
    }
    
    colaLogros[logrosEnCola] = logro;
    logrosEnCola++;
  }
}

void registrarVisita(int escenario)
{
  escenarioVisitado[escenario] = true;
  
  if (escenarioVisitado[ESCENARIO_HABITACIÓN] && escenarioVisitado[ESCENARIO_SALA] && escenarioVisitado[ESCENARIO_COCINA])
  {
    desbloquearLogro(LOGRO_EXPLORADOR);
  }
}

void registrarNotificaciónTocada()
{
  notificacionesTocadas += 1;
  
  if (notificacionesTocadas >= 5)
  {
    desbloquearLogro(LOGRO_NOTIFICADO);
  }
}

// Logros que dependen de cómo salió un minijuego

void registrarLogrosMinijuego()
{
  if (rendimientoMinijuego >= 0.999)
  {
    if (tipoMinijuego == MINIJUEGO_CÁLCULO)
    {
      desbloquearLogro(LOGRO_CALCULISTA);
    }
    
    if (tipoMinijuego == MINIJUEGO_ORTOGRAFÍA)
    {
      desbloquearLogro(LOGRO_ORTÓGRAFO);
    }
    
    if (tipoMinijuego == MINIJUEGO_MEMORIA)
    {
      desbloquearLogro(LOGRO_MEMORIA);
    }
    
    if (tipoMinijuego == MINIJUEGO_ORDEN)
    {
      desbloquearLogro(LOGRO_ENFOQUE);
    }
  }
  
  if (rendimientoMinijuego >= UMBRAL_TAREA && distraccionesMinijuego == 0 && notificacionesIgnoradas >= 3)
  {
    desbloquearLogro(LOGRO_MODO_AVIÓN);
  }
}

// Logros que se deciden al terminar la semana

void evaluarLogrosFinales()
{
  if (derrota)
  {
    desbloquearLogro(LOGRO_COLAPSO);
  }
    else
  {
    evaluarLogrosDeSemanaCompleta();
  }
}

void evaluarLogrosDeSemanaCompleta()
{
  int total = puntuaciónTotal();
  
  if (tareasPendientes == 0)
  {
    desbloquearLogro(LOGRO_CERO_PENDIENTES);
  }
  
  if (usosTeléfono == 0)
  {
    desbloquearLogro(LOGRO_DESINTOXICACIÓN);
  }
  
  if (máximaAnsiedad >= 90)
  {
    desbloquearLogro(LOGRO_AL_BORDE);
  }
  
  if (ansiedad <= 20)
  {
    desbloquearLogro(LOGRO_ZEN);
  }
  
  if (total >= PUNTUACIÓN_PERFECCIONISTA)
  {
    desbloquearLogro(LOGRO_ENSUEÑO);
  }
  
  int resultado = resultadoFinal();
  
  if (resultado == RESULTADO_BUENO)
  {
    desbloquearLogro(LOGRO_FINAL_BUENO);
  }
  
  if (resultado == RESULTADO_NORMAL)
  {
    desbloquearLogro(LOGRO_FINAL_NORMAL);
  }
  
  if (resultado == RESULTADO_MALO)
  {
    desbloquearLogro(LOGRO_FINAL_MALO);
  }
}

int cantidadLogrosDesbloqueados()
{
  int cantidad = 0;
  
  for (int i = 0; i < TOTAL_LOGROS; i++)
  {
    if (logroDesbloqueado[i])
    {
      cantidad += 1;
    }
  }
  
  return cantidad;
}

// Muestra de uno en uno los logros que se acaban de conseguir

void mostrarLogroNuevo()
{
  if (logroVisible < 0 && logrosEnCola > 0)
  {
    logroVisible       = colaLogros[0];
    inicioLogroVisible = millis();
    
    for (int i = 1; i < logrosEnCola; i++)
    {
      colaLogros[i - 1] = colaLogros[i];
    }
    
    logrosEnCola--;
  }
  
  if (logroVisible >= 0)
  {
    float edad = (millis() - inicioLogroVisible) / 1000;
    
    if (edad > 3.4)
    {
      logroVisible = -1;
    }
      else
    {
      dibujarLogroNuevo(edad);
    }
  }
}

void dibujarLogroNuevo(float edad)
{
  // Sube al aparecer y baja al despedirse
  
  float apareciendo  = constrain(edad / 0.4, 0, 1);
  float despidiéndose = constrain((3.4 - edad) / 0.4, 0, 1);
  
  float visible = apareciendo;
  
  if (despidiéndose < apareciendo)
  {
    visible = despidiéndose;
  }
  
  float x = ANCHO / 2 - 380;
  float y = ALTO + 20 - 170 * visible;
  
  fill(255, 205, 60, 240);
  rect(x - 5, y - 5, 770, 140, 30);
  
  fill(45, 28, 60, 250);
  rect(x, y, 760, 130, 26);
  
  fill(255, 205, 60);
  ellipse(x + 70, y + 65, 88, 88);
  
  fill(255, 205, 60);
  escribir("¡Logro desbloqueado!", x + 140, y + 30, 22, LEFT);
  
  fill(255);
  escribir(logroNombre[logroVisible], x + 140, y + 68, 38, LEFT);
  
  fill(210);
  escribir(logroDescripción[logroVisible], x + 140, y + 105, 20, LEFT);
}

void iniciarLogrosPantalla()
{
  secciónActual = 3;
}

void administrarLogros()
{
  background(fondoMenú);
  
  fill(10, 5, 20, 210);
  rect(0, 0, ANCHO, ALTO);
  
  fill(255);
  escribir("Logros", ANCHO / 2, 70, 60, CENTER);
  
  fill(210);
  escribir(cantidadLogrosDesbloqueados() + " de " + TOTAL_LOGROS + " desbloqueados", ANCHO / 2, 125, 28, CENTER);
  
  for (int i = 0; i < TOTAL_LOGROS; i++)
  {
    dibujarCasillaLogro(i, 50 + (i % 4) * 460, 160 + (i / 4) * 132);
  }
  
  dibujarBotón("Volver al menú", ANCHO / 2 - 170, 975, 340, 70, 30, 110, 70, 140);
}

void dibujarCasillaLogro(int logro, float x, float y)
{
  boolean conseguido = logroDesbloqueado[logro];
  boolean oculto     = !conseguido && logroSecreto[logro];
  
  int fondoCasilla  = color(40, 28, 52, 225);
  int colorMedalla  = color(80, 65, 95);
  int brilloNombre  = 150;
  int brilloTexto   = 120;
  
  if (conseguido)
  {
    fondoCasilla  = color(95, 65, 120, 240);
    colorMedalla  = color(255, 205, 60);
    brilloNombre  = 255;
    brilloTexto   = 225;
  }
  
  String nombre      = logroNombre[logro];
  String descripción = logroDescripción[logro];
  
  if (oculto)
  {
    nombre      = "???";
    descripción = "Logro secreto: ¡descúbrelo jugando!";
  }
  
  fill(fondoCasilla);
  rect(x, y, 440, 118, 24);
  
  fill(colorMedalla);
  ellipse(x + 55, y + 59, 68, 68);
  
  fill(brilloNombre);
  escribir(nombre, x + 110, y + 28, 26, LEFT);
  
  if (conseguido && logroSecreto[logro])
  {
    fill(255, 205, 60);
    escribir("secreto", x + 425, y + 14, 16, RIGHT);
  }
  
  fill(brilloTexto);
  
  textAlign(LEFT, TOP);
  textSize(19);
  text(descripción, x + 110, y + 52, 315, 60);
}

void administrarClicksLogros()
{
  if (estáRatónSobreRectángulo(ANCHO / 2 - 170, 975, 340, 70))
  {
    iniciarMenú();
  }
}
