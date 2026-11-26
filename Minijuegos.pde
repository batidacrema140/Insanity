
int MINIJUEGO_CÁLCULO    = 0;
int MINIJUEGO_ORTOGRAFÍA = 1;
int MINIJUEGO_MEMORIA    = 2;
int MINIJUEGO_ORDEN      = 3;
int TOTAL_MINIJUEGOS     = 4;

int FASE_INTRO     = 0;
int FASE_JUEGO     = 1;
int FASE_RESULTADO = 2;

String[] nombreMinijuego = { "Cálculo", "Ortografía", "Memoria", "Concentración" };

String[] instrucciónMinijuego = {
  "Resuelve cada operación antes de que se acabe el tiempo.",
  "Elige la palabra que está bien escrita.",
  "Encuentra todas las parejas antes de que se acabe el tiempo.",
  "Toca los números en orden, del 1 en adelante, lo más rápido que puedas."
};

float PANEL_X     = 260;
float PANEL_Y     = 260;
float PANEL_ANCHO = 1400;
float PANEL_ALTO  = 700;

// Notificación del teléfono

float NOTIF_X     = 1380;
float NOTIF_Y     = 110;
float NOTIF_ANCHO = 480;
float NOTIF_ALTO  = 110;

String[] textosNotificación = {
  "¿Vienes a jugar? Te estamos esperando.",
  "Tu amigo te etiquetó en una foto.",
  "¡Mira este video! Es graciosísimo.",
  "Alguien comentó tu publicación.",
  "Oferta del día: ¡solo por hoy!",
  "Tienes 12 notificaciones nuevas.",
  "Grupo de clase: ¿alguien entendió la tarea?",
  "Vuelve a la app: ¡te extrañamos!"
};

// Preguntas de opción múltiple

float OPCIÓN_ANCHO = 580;
float OPCIÓN_ALTO  = 110;

float CARTA_ANCHO      = 140;
float CARTA_ALTO       = 120;
float CARTA_SEPARACIÓN = 20;

int[][] colorSímbolo = {
  { 235,  90,  90 }, { 90, 170, 235 }, { 250, 200,  70 }, { 110, 210, 120 }, { 200, 120, 230 },
  { 250, 150,  70 }, { 90, 220, 210 }, { 240, 120, 170 }, { 150, 150, 240 }, { 200, 220,  90 }
};

float RADIO_NÚMERO = 38;

// Palabras para el reto de ortografía

String[][] palabras = {
  { "excepción",       "exepción",       "exceción",       "excepsión"      },
  { "extraordinario",  "estraordinario", "extraodinario",  "extrordinario"  },
  { "bienvenido",      "bienbenido",     "vienvenido",     "bienvennido"    },
  { "ansiedad",        "anciedad",       "ansiedat",       "ansidedad"      },
  { "hábito",          "ábito",          "hábitto",        "hávito"         },
  { "exhausto",        "exausto",        "exhaucto",       "eshausto"       },
  { "dificultad",      "dificultat",     "dificulltad",    "dificutlad"     },
  { "responsabilidad", "responsavilidad", "resposabilidad", "responsabilidat" },
  { "concentración",   "consentración",  "concentrasión",  "concentracion"  },
  { "habitación",      "abitación",      "habitasión",     "habitacion"     },
  { "televisión",      "televición",     "telebisión",     "televisíon"     },
  { "colegio",         "colejio",        "coleggio",       "colegío"        },
  { "examen",          "exámen",         "eksamen",        "examén"         },
  { "ejercicio",       "ejersicio",      "egercicio",      "ejerccicio"     },
  { "biblioteca",      "bibloteca",      "biblioteka",     "bibliotecca"    },
  { "cuaderno",        "cuadreno",       "cuaderrno",      "cuadernno"      },
  { "descansar",       "descanzar",      "desscansar",     "deskansar"      },
  { "teléfono",        "telefóno",       "teléphono",      "teléfonno"      },
  { "pantalla",        "pantaya",        "pantala",        "panttalla"      },
  { "notificación",    "notifición",     "notificasión",   "notificacion"   },
  { "dibujo",          "divujo",         "dibuxo",         "dibuho"         }
};

// ========================
// | Inicio y preparación |
// ========================

float tiempoFase()
{
  return (millis() - inicioFase) / 1000;
}

// Empieza la tarea

void iniciarMinijuego()
{
  minijuegoActivo = true;
  
  dificultadMinijuego   = constrain(díaActual(), 0, 4);
  factorTiempoMinijuego = 1 - 0.08 * dificultadMinijuego;
  
  tipoMinijuego = (int) random(TOTAL_MINIJUEGOS);
  
  if (tipoMinijuego == últimoMinijuego)
  {
    tipoMinijuego = (tipoMinijuego + 1 + (int) random(TOTAL_MINIJUEGOS - 1)) % TOTAL_MINIJUEGOS;
  }
  
  últimoMinijuego = tipoMinijuego;
  
  distraccionesMinijuego  = 0;
  notificacionesIgnoradas = 0;
  rendimientoMinijuego    = 0;
  
  hayNotificación = false;
  
  faseMinijuego = FASE_INTRO;
  inicioFase    = millis();
}

void comenzarJuego()
{
  if (tipoMinijuego == MINIJUEGO_CÁLCULO || tipoMinijuego == MINIJUEGO_ORTOGRAFÍA)
  {
    prepararPreguntas();
  }
  
  if (tipoMinijuego == MINIJUEGO_MEMORIA)
  {
    prepararMemoria();
  }
  
  if (tipoMinijuego == MINIJUEGO_ORDEN)
  {
    prepararOrden();
  }
  
  faseMinijuego = FASE_JUEGO;
  inicioFase    = millis();
  
  programarNotificación();
}

// Mezcla un arreglo de enteros

void mezclar(int[] lista)
{
  for (int i = lista.length - 1; i > 0; i--)
  {
    int j = (int) random(i + 1);
    
    int guardado = lista[i];
    lista[i]     = lista[j];
    lista[j]     = guardado;
  }
}

void prepararPreguntas()
{
  totalPreguntas    = 5 + dificultadMinijuego / 2;
  preguntaActual    = 0;
  aciertosPreguntas = 0;
  
  tiempoPregunta = TIEMPO_ORTOGRAFÍA * factorTiempoMinijuego;
  
  if (tipoMinijuego == MINIJUEGO_CÁLCULO)
  {
    tiempoPregunta = TIEMPO_CÁLCULO * factorTiempoMinijuego;
  }
  
  ortografíaUsada = new boolean[palabras.length];
  
  generarPregunta();
}

void generarPregunta()
{
  if (tipoMinijuego == MINIJUEGO_CÁLCULO)
  {
    generarPreguntaCálculo();
  }
    else
  {
    generarPreguntaOrtografía();
  }

  enRespuesta     = false;
  respuestaElegida = -1;
  inicioPregunta  = millis();
}

// Suma, resta o multiplicación

void generarPreguntaCálculo()
{
  int d = dificultadMinijuego;
  
  int operación = (int) random(3);
  
  int a;
  int b;
  int resultado;
  
  String símbolo;
  
  if (operación == 0)
  {
    a = (int) random(12 + 8 * d, 40 + 15 * d);
    b = (int) random(11 + 6 * d, 35 + 12 * d);
    
    resultado = a + b;
    símbolo   = "+";
  }
    else
  {
    if (operación == 1)
    {
      a = (int) random(40 + 10 * d, 95 + 10 * d);
      b = (int) random(11 + 4 * d, a - 9);
      
      resultado = a - b;
      símbolo   = "-";
    }
      else
    {
      a = (int) random(4 + d / 2, 10 + d / 2);
      b = (int) random(4 + d / 2, 10 + d / 2);
      
      resultado = a * b;
      símbolo   = "×";
    }
  }
  
  textoPregunta = a + " " + símbolo + " " + b + " = ?";
  
  // Tres respuestas falsas cercanas a la correcta
  
  int[] saltos = { -10, -2, -1, 1, 2, 10 };
  
  mezclar(saltos);
  
  respuestaCorrecta = (int) random(4);
  
  int siguiente = 0;
  
  for (int i = 0; i < 4; i++)
  {
    if (i == respuestaCorrecta)
    {
      opcionesPregunta[i] = "" + resultado;
    }
      else
    {
      opcionesPregunta[i] = "" + (resultado + saltos[siguiente]);
      siguiente += 1;
    }
  }
}

void generarPreguntaOrtografía()
{
  int índice;
  
  do
  {
    índice = (int) random(palabras.length);
  }
  while (ortografíaUsada[índice]);
  
  ortografíaUsada[índice] = true;
  
  textoPregunta = "¿Cuál está bien escrita?";
  
  respuestaCorrecta = (int) random(4);
  
  int siguiente = 1;
  
  for (int i = 0; i < 4; i++)
  {
    if (i == respuestaCorrecta)
    {
      opcionesPregunta[i] = palabras[índice][0];
    }
      else
    {
      opcionesPregunta[i] = palabras[índice][siguiente];
      siguiente += 1;
    }
  }
}

void prepararMemoria()
{
  totalPares = 6 + 2 * (dificultadMinijuego / 2);
  
  columnasMemoria = 4;
  
  if (totalPares == 10)
  {
    columnasMemoria = 5;
  }
  
  filasMemoria    = totalPares * 2 / columnasMemoria;
  
  int cartas = totalPares * 2;
  
  cartaSímbolo    = new int[cartas];
  cartaVolteada   = new boolean[cartas];
  cartaEmparejada = new boolean[cartas];
  
  for (int i = 0; i < cartas; i++)
  {
    cartaSímbolo[i] = i / 2;
  }
  
  mezclar(cartaSímbolo);
  
  primeraCarta     = -1;
  segundaCarta     = -1;
  paresEncontrados =  0;
  
  tiempoLímiteFase = totalPares * TIEMPO_POR_PAR * factorTiempoMinijuego;
}

float cartaX(int carta)
{
  float ancho = columnasMemoria * CARTA_ANCHO + (columnasMemoria - 1) * CARTA_SEPARACIÓN;
  
  return ANCHO / 2 - ancho / 2 + (carta % columnasMemoria) * (CARTA_ANCHO + CARTA_SEPARACIÓN);
}

float cartaY(int carta)
{
  float alto = filasMemoria * CARTA_ALTO + (filasMemoria - 1) * CARTA_SEPARACIÓN;
  
  return 655 - alto / 2 + (carta / columnasMemoria) * (CARTA_ALTO + CARTA_SEPARACIÓN);
}

void prepararOrden()
{
  totalNúmeros    = 8 + dificultadMinijuego;
  siguienteNúmero = 0;
  
  númeroX = new float[totalNúmeros];
  númeroY = new float[totalNúmeros];
  
  for (int i = 0; i < totalNúmeros; i++)
  {
    boolean libre;
    int intentos = 0;
    
    // Busca un lugar que no se encime con los anteriores
    
    do
    {
      númeroX[i] = random(360, 1560);
      númeroY[i] = random(410, 910);
      
      libre = true;
      
      for (int j = 0; j < i; j++)
      {
        float dx = númeroX[i] - númeroX[j];
        float dy = númeroY[i] - númeroY[j];
        
        if (dx * dx + dy * dy < 100 * 100)
        {
          libre = false;
        }
      }
      
      intentos += 1;
    }
    while (!libre && intentos < 300);
  }
  
  inicioError      = -10000;
  tiempoLímiteFase = totalNúmeros * TIEMPO_POR_NÚMERO * factorTiempoMinijuego;
}

void programarNotificación()
{
  próximaNotificación = millis() + 1000 * random(3.5, 7) * factorTiempoMinijuego;
}

void actualizarNotificaciones()
{
  if (!hayNotificación)
  {
    if (millis() >= próximaNotificación)
    {
      hayNotificación    = true;
      inicioNotificación = millis();
      textoNotificación  = textosNotificación[(int) random(textosNotificación.length)];
    }
  }
    else
  {
    if ((millis() - inicioNotificación) / 1000 > 3)
    {
      hayNotificación = false;
      notificacionesIgnoradas += 1;
      
      programarNotificación();
    }
  }
}

// Tocar una notificación te distrae

boolean tocarNotificación()
{
  boolean tocada = false;
  
  if (hayNotificación && estáRatónSobreRectángulo(NOTIF_X, NOTIF_Y, NOTIF_ANCHO, NOTIF_ALTO))
  {
    hayNotificación = false;
    distraccionesMinijuego += 1;
    
    registrarNotificaciónTocada();
    penalizarTiempo(2);
    programarNotificación();
    
    tocada = true;
  }
  
  return tocada;
}

void penalizarTiempo(float segundos)
{
  if (tipoMinijuego == MINIJUEGO_CÁLCULO || tipoMinijuego == MINIJUEGO_ORTOGRAFÍA)
  {
    inicioPregunta -= 1000 * segundos;
  }
    else
  {
    inicioFase -= 1000 * segundos;
  }
}

// =======================
// | Lógica de cada reto |
// =======================

void actualizarMinijuego()
{
  if (faseMinijuego == FASE_JUEGO)
  {
    actualizarNotificaciones();
    
    if (tipoMinijuego == MINIJUEGO_CÁLCULO || tipoMinijuego == MINIJUEGO_ORTOGRAFÍA)
    {
      actualizarPreguntas();
    }
    
    if (tipoMinijuego == MINIJUEGO_MEMORIA)
    {
      actualizarMemoria();
    }
    
    if (tipoMinijuego == MINIJUEGO_ORDEN)
    {
      actualizarOrden();
    }
  }
}

float tiempoRestantePregunta()
{
  return tiempoPregunta - (millis() - inicioPregunta) / 1000;
}

void actualizarPreguntas()
{
  if (enRespuesta)
  {
    if ((millis() - inicioRespuesta) / 1000 >= 0.8)
    {
      siguientePregunta();
    }
  }
    else
  {
    if (tiempoRestantePregunta() <= 0)
    {
      responderPregunta(-1);
    }
  }
}

// opción = -1 significa que se acabó el tiempo

void responderPregunta(int opción)
{
  if (!enRespuesta)
  {
    respuestaElegida = opción;
    enRespuesta      = true;
    inicioRespuesta  = millis();
    
    if (opción == respuestaCorrecta)
    {
      aciertosPreguntas += 1;
    }
  }
}

void siguientePregunta()
{
  preguntaActual += 1;
  
  if (preguntaActual >= totalPreguntas)
  {
    terminarMinijuego();
  }
    else
  {
    generarPregunta();
  }
}

void actualizarMemoria()
{
  // Con dos cartas descubiertas, espera un momento y las deja o las voltea de nuevo
  
  if (segundaCarta >= 0 && (millis() - inicioComparación) / 1000 >= 0.7)
  {
    if (cartaSímbolo[primeraCarta] == cartaSímbolo[segundaCarta])
    {
      cartaEmparejada[primeraCarta] = true;
      cartaEmparejada[segundaCarta] = true;
      
      paresEncontrados += 1;
    }
      else
    {
      cartaVolteada[primeraCarta] = false;
      cartaVolteada[segundaCarta] = false;
    }
    
    primeraCarta = -1;
    segundaCarta = -1;
  }

  if (paresEncontrados >= totalPares || tiempoFase() >= tiempoLímiteFase)
  {
    terminarMinijuego();
  }
}

void voltearCarta(int carta)
{
  if (segundaCarta < 0 && !cartaVolteada[carta] && !cartaEmparejada[carta])
  {
    cartaVolteada[carta] = true;
    
    if (primeraCarta < 0)
    {
      primeraCarta = carta;
    }
      else
    {
      segundaCarta      = carta;
      inicioComparación = millis();
    }
  }
}

void actualizarOrden()
{
  if (tiempoFase() >= tiempoLímiteFase)
  {
    terminarMinijuego();
  }
}

// Número tocado

void tocarNúmero(int número)
{
  if (número == siguienteNúmero)
  {
    siguienteNúmero += 1;
    
    if (siguienteNúmero >= totalNúmeros)
    {
      terminarMinijuego();
    }
  }
    else
  {
    if (número > siguienteNúmero)
    {
      inicioError = millis();
      penalizarTiempo(1.5);
    }
  }
}

// Calcula el rendimiento y muestra los resultados

void terminarMinijuego()
{
  if (tipoMinijuego == MINIJUEGO_CÁLCULO || tipoMinijuego == MINIJUEGO_ORTOGRAFÍA)
  {
    rendimientoMinijuego = aciertosPreguntas / (float) totalPreguntas;
  }
  
  if (tipoMinijuego == MINIJUEGO_MEMORIA)
  {
    rendimientoMinijuego = paresEncontrados / (float) totalPares;
  }
  
  if (tipoMinijuego == MINIJUEGO_ORDEN)
  {
    rendimientoMinijuego = siguienteNúmero / (float) totalNúmeros;
  }
  
  rendimientoMinijuego = constrain(rendimientoMinijuego, 0, 1);
  
  hayNotificación = false;
  
  faseMinijuego = FASE_RESULTADO;
  inicioFase    = millis();
  
  registrarLogrosMinijuego();
}

void cerrarMinijuego()
{
  minijuegoActivo = false;
  
  terminarEstudio();
}

// Cada una devuelve lo que hay bajo el puntero o -1 si no hay nada

int opciónBajoRatón()
{
  int opción = -1;
  
  for (int i = 3; i >= 0; i--)
  {
    if (estáRatónSobreRectángulo(opciónX(i), opciónY(i), OPCIÓN_ANCHO, OPCIÓN_ALTO))
    {
      opción = i;
    }
  }
  
  return opción;
}

int cartaBajoRatón()
{
  int carta = -1;
  
  for (int i = cartaSímbolo.length - 1; i >= 0; i--)
  {
    if (estáRatónSobreRectángulo(cartaX(i), cartaY(i), CARTA_ANCHO, CARTA_ALTO))
    {
      carta = i;
    }
  }
  
  return carta;
}

// Si hay varios números encimados, gana el de número más alto

int númeroBajoRatón()
{
  int número = -1;
  
  for (int i = siguienteNúmero; i < totalNúmeros; i++)
  {
    float dx = mouseX - númeroX[i];
    float dy = mouseY - númeroY[i];
    
    if (dx * dx + dy * dy <= RADIO_NÚMERO * RADIO_NÚMERO)
    {
      número = i;
    }
  }
  
  return número;
}

void administrarClicksMinijuego()
{
  // Se guarda la fase porque un click puede cambiarla
  
  int fase = faseMinijuego;
  
  if (fase == FASE_INTRO && tiempoFase() > 0.4)
  {
    comenzarJuego();
  }
  
  if (fase == FASE_JUEGO)
  {
    administrarClicksReto();
  }
  
  if (fase == FASE_RESULTADO && tiempoFase() > 0.6)
  {
    cerrarMinijuego();
  }
}

// Una notificación puede tapar parte de la pantalla

void administrarClicksReto()
{
  if (!tocarNotificación())
  {
    if (tipoMinijuego == MINIJUEGO_CÁLCULO || tipoMinijuego == MINIJUEGO_ORTOGRAFÍA)
    {
      int opción = opciónBajoRatón();

      if (opción >= 0)
      {
        responderPregunta(opción);
      }
    }
    
    if (tipoMinijuego == MINIJUEGO_MEMORIA)
    {
      int carta = cartaBajoRatón();
      
      if (carta >= 0)
      {
        voltearCarta(carta);
      }
    }
    
    if (tipoMinijuego == MINIJUEGO_ORDEN)
    {
      int número = númeroBajoRatón();
      
      if (número >= 0)
      {
        tocarNúmero(número);
      }
    }
  }
}

// ==========
// | Dibujo |
// ==========

void administrarMinijuego()
{
  actualizarMinijuego();
  dibujarMinijuego();
}

void dibujarMinijuego()
{
  // El cuarto se ve oscurecido detrás
  
  fill(0, 170);
  rect(0, 0, ANCHO, ALTO);
  
  mostrarBarras();
  mostrarReloj();
  
  dibujarPanel(PANEL_X, PANEL_Y, PANEL_ANCHO, PANEL_ALTO);
  
  if (faseMinijuego == FASE_INTRO)
  {
    dibujarIntroMinijuego();
  }
  
  if (faseMinijuego == FASE_JUEGO)
  {
    dibujarJuego();
    dibujarNotificación();
  }
  
  if (faseMinijuego == FASE_RESULTADO)
  {
    dibujarResultadoMinijuego();
  }
}

void dibujarIntroMinijuego()
{
  float centro = PANEL_X + PANEL_ANCHO / 2;
  
  fill(255);
  escribir("Tarea de " + nombreMinijuego[tipoMinijuego], centro, 360, 72, CENTER);
  
  fill(220);
  escribir(instrucciónMinijuego[tipoMinijuego], centro, 460, 32, CENTER);
  
  fill(210);
  escribir("Dificultad (" + nombreDía[dificultadMinijuego] + ")", centro, 560, 28, CENTER);
  
  for (int i = 0; i < 5; i++)
  {
    fill(80, 65, 95);
    
    if (i <= dificultadMinijuego)
    {
      fill(255, 205, 60);
    }
    
    ellipse(centro - 120 + i * 60, 620, 40, 40);
  }
  
  fill(255, 160, 140);
  escribir("Ojo: las notificaciones del teléfono te distraen. ¡Ignóralas!", centro, 730, 28, CENTER);
  
  fill(255);
  escribir("Haz click para empezar", centro, 860, 36, CENTER);
}

void dibujarJuego()
{
  if (tipoMinijuego == MINIJUEGO_CÁLCULO || tipoMinijuego == MINIJUEGO_ORTOGRAFÍA)
  {
    dibujarPreguntas();
  }
  
  if (tipoMinijuego == MINIJUEGO_MEMORIA)
  {
    dibujarMemoria();
  }
  
  if (tipoMinijuego == MINIJUEGO_ORDEN)
  {
    dibujarOrden();
  }
}

// Barra de tiempo

void dibujarBarraTiempo(float fracciónRestante)
{
  fracciónRestante = constrain(fracciónRestante, 0, 1);
  
  fill(60, 40, 70);
  rect(360, 330, 1200, 22, 11);
  
  if (fracciónRestante > 0.5)
  {
    fill(90, 200, 110);
  }
    else
  {
    if (fracciónRestante > 0.25)
    {
      fill(230, 200, 70);
    }
      else
    {
      fill(220, 80, 80);
    }
  }
  
  rect(360, 330, 1200 * fracciónRestante, 22, 11);
}

float opciónX(int opción)
{
  return 360 + (opción % 2) * (OPCIÓN_ANCHO + 40);
}

float opciónY(int opción)
{
  return 560 + (opción / 2) * (OPCIÓN_ALTO + 30);
}

void dibujarPreguntas()
{
  fill(255);
  escribir("Tarea de " + nombreMinijuego[tipoMinijuego] + "  —  Pregunta " + (preguntaActual + 1) + " de " + totalPreguntas, ANCHO / 2, 295, 28, CENTER);
  
  if (enRespuesta)
  {
    dibujarBarraTiempo(0);
  }
    else
  {
    dibujarBarraTiempo(tiempoRestantePregunta() / tiempoPregunta);
  }
  
  fill(255);
  escribir(textoPregunta, ANCHO / 2, 450, 76, CENTER);
  
  for (int i = 0; i < 4; i++)
  {
    int rojo  = 95;
    int verde = 70;
    int azul  = 140;
    
    if (enRespuesta && i == respuestaCorrecta)
    {
      rojo = 60; verde = 150; azul = 90;
    }
      else
    {
      if (enRespuesta && i == respuestaElegida)
      {
        rojo = 170; verde = 60; azul = 70;
      }
    }
    
    dibujarBotón(opcionesPregunta[i], opciónX(i), opciónY(i), OPCIÓN_ANCHO, OPCIÓN_ALTO, 48, rojo, verde, azul);
  }
}

void dibujarMemoria()
{
  fill(255);
  escribir("Tarea de Memoria  —  Parejas: " + paresEncontrados + " de " + totalPares, ANCHO / 2, 295, 28, CENTER);
  
  dibujarBarraTiempo(1 - tiempoFase() / tiempoLímiteFase);
  
  for (int i = 0; i < cartaSímbolo.length; i++)
  {
    float x = cartaX(i);
    float y = cartaY(i);
    
    if (cartaEmparejada[i])
    {
      fill(200, 235, 200);
    }
      else
    {
      if (cartaVolteada[i])
      {
        fill(245, 240, 230);
      }
        else
      {
        fill(110, 80, 150);
        
        if (estáRatónSobreRectángulo(x, y, CARTA_ANCHO, CARTA_ALTO))
        {
          fill(140, 105, 185);
        }
      }
    }
    
    rect(x, y, CARTA_ANCHO, CARTA_ALTO, 18);
    
    if (cartaVolteada[i] || cartaEmparejada[i])
    {
      dibujarSímbolo(cartaSímbolo[i], x + CARTA_ANCHO / 2, y + CARTA_ALTO / 2, 38);
    }
      else
    {
      fill(200, 175, 230);
      escribir("?", x + CARTA_ANCHO / 2, y + CARTA_ALTO / 2, 56, CENTER);
    }
  }
}

// Símbolo centrado con radio r

void dibujarSímbolo(int símbolo, float x, float y, float r)
{
  fill(colorSímbolo[símbolo][0], colorSímbolo[símbolo][1], colorSímbolo[símbolo][2]);
  
  switch (símbolo)
  {
    case 0:
      ellipse(x, y, 2 * r, 2 * r);
    break;
    
    case 1:
      rect(x - r, y - r, 2 * r, 2 * r, 8);
    break;
    
    case 2:
      triangle(x, y - r, x + r, y + r, x - r, y + r);
    break;
    
    case 3:
      ellipse(x, y, 2 * r * 1.3, r * 1.2);
    break;
    
    case 4:
      triangle(x, y - r, x + r, y, x, y + r);
      triangle(x, y - r, x - r, y, x, y + r);
    break;
    
    case 5:
      rect(x - r, y - r / 3, 2 * r, 2 * r / 3);
      rect(x - r / 3, y - r, 2 * r / 3, 2 * r);
    break;
    
    case 6:
      ellipse(x, y, 2 * r, 2 * r);
      fill(245, 240, 230);
      ellipse(x, y, r, r);
    break;
    
    case 7:
      rect(x - r, y - r, r * 0.5, 2 * r);
      rect(x - r * 0.25, y - r, r * 0.5, 2 * r);
      rect(x + r * 0.5, y - r, r * 0.5, 2 * r);
    break;
    
    case 8:
      rect(x - r, y - r, 2 * r, 2 * r, 8);
      fill(245, 240, 230);
      rect(x - r / 2, y - r / 2, r, r);
    break;
    
    case 9:
      ellipse(x - r / 2, y, r * 1.3, r * 1.3);
      ellipse(x + r / 2, y, r * 1.3, r * 1.3);
    break;
  }
}

void dibujarOrden()
{
  fill(255);
  int mostrado = siguienteNúmero + 1;
  
  if (mostrado > totalNúmeros)
  {
    mostrado = totalNúmeros;
  }
  
  escribir("Tarea de Concentración  —  Siguiente: " + mostrado + " de " + totalNúmeros, ANCHO / 2, 295, 28, CENTER);
  
  dibujarBarraTiempo(1 - tiempoFase() / tiempoLímiteFase);
  
  for (int i = 0; i < totalNúmeros; i++)
  {
    if (i < siguienteNúmero)
    {
      fill(60, 45, 75);
      ellipse(númeroX[i], númeroY[i], 2 * RADIO_NÚMERO * 0.5, 2 * RADIO_NÚMERO * 0.5);
    }
      else
    {
      float dx = mouseX - númeroX[i];
      float dy = mouseY - númeroY[i];
      
      fill(135, 95, 190);
      
      if (dx * dx + dy * dy <= RADIO_NÚMERO * RADIO_NÚMERO)
      {
        fill(170, 130, 225);
      }
      
      ellipse(númeroX[i], númeroY[i], 2 * RADIO_NÚMERO, 2 * RADIO_NÚMERO);
      
      fill(255);
      escribir("" + (i + 1), númeroX[i], númeroY[i], 36, CENTER);
    }
  }
  
  // Destello rojo si te equivocaste
  
  float edadError = (millis() - inicioError) / 1000;
  
  if (edadError < 0.4)
  {
    fill(210, 40, 50, 110 * (1 - edadError / 0.4));
    rect(PANEL_X, PANEL_Y, PANEL_ANCHO, PANEL_ALTO, 30);
  }
}

void dibujarNotificación()
{
  if (hayNotificación)
  {
    fill(40, 40, 58, 245);
    
    if (estáRatónSobreRectángulo(NOTIF_X, NOTIF_Y, NOTIF_ANCHO, NOTIF_ALTO))
    {
      fill(70, 70, 95, 245);
    }
    
    rect(NOTIF_X, NOTIF_Y, NOTIF_ANCHO, NOTIF_ALTO, 24);
    
    fill(90, 200, 120);
    ellipse(NOTIF_X + 45, NOTIF_Y + 40, 44, 44);
    
    fill(170);
    escribir("Mensajes  •  ahora", NOTIF_X + 85, NOTIF_Y + 24, 18, LEFT);
    
    fill(255);
    textAlign(LEFT, TOP);
    textSize(22);
    text(textoNotificación, NOTIF_X + 85, NOTIF_Y + 42, NOTIF_ANCHO - 105, 60);
  }
}

void dibujarResultadoMinijuego()
{
  float centro = PANEL_X + PANEL_ANCHO / 2;
  
  if (rendimientoMinijuego >= UMBRAL_TAREA)
  {
    fill(140, 230, 150);
    escribir("¡Tarea superada!", centro, 360, 70, CENTER);
  }
    else
  {
    fill(255, 150, 140);
    escribir("La tarea no salió bien", centro, 360, 70, CENTER);
  }
  
  fill(255);
  escribir("Rendimiento: " + round(rendimientoMinijuego * 100) + " %", centro, 480, 56, CENTER);
  
  fill(220);
  
  if (distraccionesMinijuego > 0)
  {
    escribir("Notificaciones tocadas: " + distraccionesMinijuego + ". Perdiste tiempo y te estresaste.", centro, 590, 28, CENTER);
  }
    else
  {
    if (notificacionesIgnoradas > 0)
    {
      escribir("Notificaciones ignoradas: " + notificacionesIgnoradas + ". ¡Buen enfoque!", centro, 590, 28, CENTER);
    }
      else
    {
      escribir("Ninguna notificación te distrajo.", centro, 590, 28, CENTER);
    }
  }
  
  fill(190);
  escribir("Rendir bien te estresa menos; rendir mal, más.", centro, 650, 26, CENTER);
  
  fill(255);
  escribir("Haz click para continuar", centro, 860, 36, CENTER);
}
