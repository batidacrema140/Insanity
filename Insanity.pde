
// ===========================
// | Definición de variables |
// ===========================

// Todo el juego está diseñado para una resolución de 1920 x 1080

int ANCHO = 1920;
int ALTO  = 1080;

// Sección actual
// 0 menú, 1 partida, 2 créditos, 3 logros

int secciónActual;
int escenarioActual;

// Variables del cronómetro

float tiempoReferencia;

// Variables del menú

int botónEnfocado = -1;

PImage fondoMenú;

// Variables de la partida

int energía;
int ansiedad;

PImage iconoEnergía;
PImage iconoAnsiedad;

int reloj;

// Posición de los pies del personaje

float[] posiciónPersonaje = new float[2];

PImage[] personaje = new PImage[8];

int direcciónPersonaje = 6;

boolean mostrarColisiones;

// Escenarios

PImage fondoEscenario;

PImage fondoHabitación;
PImage fondoSala;
PImage fondoCocina;

// Habitación

PImage cama;
PImage escritorio;
PImage librería;
PImage planteusHabitación;
PImage celular;

// Sala

PImage chimenea;
PImage fuego;
PImage estante;
PImage lámpara;
PImage plantaSala;
PImage sofá;
PImage tv;

// Cocina

PImage campana;
PImage lavaplatos;
PImage nevera;
PImage plantaCocina;

// Objetos interactivos del escenario actual

PImage[]  objetoImagen;
String[]  objetoNombre;
int[]     objetoGrupo;
float[]   objetoElevación;
boolean[] objetoActivo;
float[][] objetoCaja;

int objetoEnfocado = -1;

// Rectángulos que bloquean el paso y las salidas del escenario

float[][] obstáculos = new float[0][4];
float[][] salidas    = new float[0][8];

float límiteSuperior;

// Transición entre escenarios

boolean enTransición;
boolean cambioRealizado;

float inicioTransición;

int salidaElegida;

// Progreso de la semana

int tareasPendientes;
int tareasCompletadas;

int díaÚltimaLectura;
int últimaAcción;
int horaÚltimaComida;
int usosTeléfono;
int máximaAnsiedad;

boolean[] plantaUsada = new boolean[3];

boolean[] escenarioVisitado = new boolean[3];

boolean insomnio;
boolean semanaTerminada;
boolean derrota;
boolean finalIniciado;

// Puntuación secreta
// responsabilidad, bienestar y teléfono

int[] puntos = new int[3];

// Estado antes de una acción

int energíaAntes;
int ansiedadAntes;
int relojAntes;

// Avisos en pantalla

String aviso          = "";
String avisoPendiente = "";
String notaAviso      = "";

float tiempoAviso;

// Fondos de los finales

PImage fondoDerrota;
PImage fondoMalo;
PImage fondoNeutral;
PImage fondoBueno;

// Logros

int TOTAL_LOGROS = 24;

String[] logroNombre      = new String[TOTAL_LOGROS];
String[] logroDescripción = new String[TOTAL_LOGROS];

boolean[] logroSecreto      = new boolean[TOTAL_LOGROS];
boolean[] logroDesbloqueado = new boolean[TOTAL_LOGROS];
boolean[] logroEnPartida    = new boolean[TOTAL_LOGROS];

// Contadores de la semana

int lecturas;
int notificacionesTocadas;
int notificacionesIgnoradas;

// Logros recién conseguidos que esperan su turno para mostrarse

int[] colaLogros = new int[TOTAL_LOGROS];
int   logrosEnCola;

int logroVisible = -1;

float inicioLogroVisible;

// Variables de las tarjetas

boolean estáActivaTarjeta;

PImage tarjetaCómic;

PImage tarjetaDurmiendo;
PImage tarjetaEstudiando;
PImage tarjetaLeyendo;
PImage tarjetaPlanteus;

PImage tarjetaCocinando;
PImage tarjetaComiendo;
PImage tarjetaTV;
PImage tarjetaChimenea;
PImage tarjetaSofá;
PImage tarjetaCelular;

PImage tarjetaActual;

// Platos que aparecen sobre las tarjetas de cocinar y de la nevera

PImage platoPasta;
PImage platoSándwich;
PImage platoActual;

String nombrePlato = "";

// Minijuegos de las tareas

boolean minijuegoActivo;

int tipoMinijuego;
int últimoMinijuego = -1;
int faseMinijuego;
int dificultadMinijuego;

float inicioFase;
float factorTiempoMinijuego;
float rendimientoMinijuego;

int distraccionesMinijuego;

// Notificaciones que distraen durante los minijuegos

boolean hayNotificación;

float inicioNotificación;
float próximaNotificación;

String textoNotificación = "";

// Preguntas de ortografía y matemáticas

int preguntaActual;
int totalPreguntas;
int aciertosPreguntas;
int respuestaCorrecta;
int respuestaElegida = -1;

String textoPregunta = "";
String[] opcionesPregunta = new String[4];

boolean enRespuesta;

float inicioPregunta;
float inicioRespuesta;
float tiempoPregunta;

boolean[] ortografíaUsada;

// Memoria

int[] cartaSímbolo;

boolean[] cartaVolteada;
boolean[] cartaEmparejada;

int primeraCarta = -1;
int segundaCarta = -1;
int totalPares;
int paresEncontrados;
int columnasMemoria;
int filasMemoria;

float inicioComparación;
float tiempoLímiteFase;

// Concentración

float[] númeroX;
float[] númeroY;

int totalNúmeros;
int siguienteNúmero;

float inicioError;

// Variables de los créditos

int créditoActual;

PImage David, Dayana, Isabella, Paula;
PImage fondoCréditos;

// ==================
// | Inicialización |
// ==================

void setup()
{
  fullScreen(P2D);
  noStroke();
  
  // Carga las imágenes del menú
  
  fondoMenú = loadImage("fondos/menu.png");
  
  // Carga las imágenes de la partida
  
  iconoEnergía  = loadImage("iconos/energia.png");
  iconoAnsiedad = loadImage("iconos/ansiedad.png");
  
  // Carga los ángulos del personaje
  
  personaje[0] = loadImage("personaje/izquierda.png");
  personaje[1] = loadImage("personaje/atrasIzquierda.png");
  personaje[2] = loadImage("personaje/atras.png");
  personaje[3] = loadImage("personaje/atrasDerecha.png");
  personaje[4] = loadImage("personaje/derecha.png");
  personaje[5] = loadImage("personaje/adelanteDerecha.png");
  personaje[6] = loadImage("personaje/adelante.png");
  personaje[7] = loadImage("personaje/adelanteIzquierda.png");
  
  // Fondos de los escenarios
  
  fondoHabitación = loadImage("habitacion/espacio.png");
  fondoSala       = loadImage("sala/espacio.png");
  fondoCocina     = loadImage("cocina/espacio.png");
  
  // Elementos de la habitación
  
  cama               = loadImage("habitacion/cama.png");
  escritorio         = loadImage("habitacion/escritorio.png");
  librería           = loadImage("habitacion/libreria.png");
  planteusHabitación = loadImage("habitacion/planteus.png");
  celular            = loadImage("habitacion/celular.png");
  
  // Elementos de la sala
  
  chimenea   = loadImage("sala/chimenea.png");
  fuego      = loadImage("sala/fuego.png");
  estante    = loadImage("sala/estante.png");
  lámpara    = loadImage("sala/lampara.png");
  plantaSala = loadImage("sala/planta.png");
  sofá       = loadImage("sala/sofa.png");
  tv         = loadImage("sala/tv.png");
  
  // Elementos de la cocina
  
  campana      = loadImage("cocina/campana.png");
  lavaplatos   = loadImage("cocina/lavaplatos.png");
  nevera       = loadImage("cocina/nevera.png");
  plantaCocina = loadImage("cocina/planteus.png");
  
  // Carga las imágenes de las tarjetas
  
  tarjetaCómic = loadImage("tarjetas/comic.png");

  tarjetaDurmiendo  = loadImage("tarjetas/durmiendo.png");
  tarjetaEstudiando = loadImage("tarjetas/estudiando.png");
  tarjetaLeyendo    = loadImage("tarjetas/leyendo.png");
  tarjetaPlanteus   = loadImage("tarjetas/planteus.png");

  tarjetaCocinando = loadImage("tarjetas/cocinando.png");
  tarjetaComiendo  = loadImage("tarjetas/comiendo.png");
  tarjetaTV        = loadImage("tarjetas/tv.png");
  tarjetaChimenea  = loadImage("tarjetas/chimenea.png");
  tarjetaSofá      = loadImage("tarjetas/sofa.png");
  tarjetaCelular   = loadImage("tarjetas/celular.png");
  
  // Carga los platos de comida

  platoPasta    = loadImage("comida/pasta.png");
  platoSándwich = loadImage("comida/sandwich.png");
  
  // Carga las imágens de los finales
  
  fondoDerrota = loadImage("fondos/derrota.png");
  fondoMalo    = loadImage("fondos/malo.png");
  fondoNeutral = loadImage("fondos/neutral.png");
  fondoBueno   = loadImage("fondos/bueno.png");
  
  // Carga las imágenes de los créditos
  
  David    = loadImage("creditos/David.jpeg");
  Dayana   = loadImage("creditos/Dayana.jpeg");
  Isabella = loadImage("creditos/Isabella.jpeg");
  Paula    = loadImage("creditos/Paula.jpeg");
  
  fondoCréditos = loadImage("fondos/creditos.png");
  
  // Prepara los logros
  
  iniciarLogros();
  
  // Inicializa el menú
  
  iniciarMenú();
}

// ===================
// | Ciclo principal |
// ===================

void draw()
{
  switch (secciónActual)
  {
    case 0:
      administrarMenú();
    break;
    
    case 1:
      administrarPartida();
    break;
    
    case 2:
      administrarCréditos();
    break;
    
    case 3:
      administrarLogros();
    break;
  }
}

// =====================
// | Eventos del ratón |
// =====================

void mouseClicked()
{
  switch (secciónActual)
  {
    case 0:
      administrarClicksMenú();
    break;
    
    case 1:
      administrarClicksPartida();
    break;
    
    case 2:
      administrarClicksCréditos();
    break;
    
    case 3:
      administrarClicksLogros();
    break;
  }
}
