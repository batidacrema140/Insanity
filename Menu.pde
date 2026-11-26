
// Botones del menú
// 0 jugar, 1 logros, 2 créditos, 3 cerrar

int HORIZONTAL_BOTONES = 200;
int VERTICAL_BOTONES   = 700;
int SEPARACIÓN_BOTONES = 100;

int ANCHURA_BOTONES = 400;
int ALTURA_BOTONES  = 80;

String[] textoBotones    = { "Jugar", "Logros", "Créditos", "Cerrar" };
String[] etiquetaBotones = { "¿No quieres Jugar? :D", "¡Colecciónalos todos!", "¡Conócenos!", "Te extrañaremos" };

// Establece la sección actual al menú

void iniciarMenú()
{
  botónEnfocado = -1;
  
  secciónActual = 0;
}

// Administra el ciclo del menú

void administrarMenú()
{
  background(fondoMenú);
  
  botónEnfocado = -1;
  
  for (int i = 0; i < textoBotones.length; i++)
  {
    float x = HORIZONTAL_BOTONES - 60;
    float y = VERTICAL_BOTONES + i * SEPARACIÓN_BOTONES - 40;
    
    if (estáRatónSobreRectángulo(x, y, ANCHURA_BOTONES, ALTURA_BOTONES))
    {
      botónEnfocado = i;
    }
  }
  
  if (botónEnfocado >= 0)
  {
    fill(255, 100);
    
    rect(
      HORIZONTAL_BOTONES - 60,
      VERTICAL_BOTONES + botónEnfocado * SEPARACIÓN_BOTONES - 40,
      ANCHURA_BOTONES,
      ALTURA_BOTONES,
      20
    );
    
    mostrarEtiqueta(etiquetaBotones[botónEnfocado]);
  }
  
  fill(255);
  
  for (int i = 0; i < textoBotones.length; i++)
  {
    escribir(textoBotones[i], HORIZONTAL_BOTONES, VERTICAL_BOTONES + i * SEPARACIÓN_BOTONES, 36, LEFT);
  }
}

// Acciones en caso de presionar algún botón

void administrarClicksMenú()
{
  if (botónEnfocado == 0)
  {
    iniciarPartida();
  }
  
  if (botónEnfocado == 1)
  {
    iniciarLogrosPantalla();
  }
  
  if (botónEnfocado == 2)
  {
    iniciarCréditos();
  }
  
  if (botónEnfocado == 3)
  {
    exit();
  }
}
