
// Escenarios
// Habitación -> Sala -> Cocina

int ESCENARIO_HABITACIÓN = 0;
int ESCENARIO_SALA       = 1;
int ESCENARIO_COCINA     = 2;

String[] nombreEscenario = { "Habitación", "Sala", "Cocina" };

// Número de cada objeto en su escenario

int HAB_CAMA       = 0;
int HAB_ESCRITORIO = 1;
int HAB_LIBRERÍA   = 2;
int HAB_PLANTA     = 3;
int HAB_CELULAR    = 4;

int SALA_CHIMENEA = 0;
int SALA_ESTANTE  = 2;
int SALA_PLANTA   = 4;
int SALA_SOFÁ     = 5;
int SALA_TV       = 6;

int COC_FOGÓN  = 1;
int COC_NEVERA = 2;
int COC_PLANTA = 3;

void iniciarEscenario(int escenario)
{
  switch (escenario)
  {
    case 0:
      iniciarHabitación();
    break;
    
    case 1:
      iniciarSala();
    break;
    
    case 2:
      iniciarCocina();
    break;
  }
}

void iniciarHabitación()
{
  fondoEscenario = fondoHabitación;
  límiteSuperior = 380;
  
  iniciarObjetos(
    new PImage[] { cama, escritorio, librería, planteusHabitación, celular },
    new String[] { "Dormir", "Estudiar", "Leer", "Venerar a Planteus", "Usar el teléfono" },
    new int[]    { 0, 1, 2, 3, 4 },
    new float[][] {
      { 1446, 195, 1909, 915  },
      {  702, 157, 1408, 611  },
      {   21, 183,  482, 635  },
      {   17, 634,  158, 1074 },
      { 1623, 717, 1771, 1006 }
    }
  );
  
  obstáculos = new float[][] {
    { 1446, 375, 1909, 915  },
    {  702, 341, 1408, 611  },
    {   21, 375,  482, 635  },
    {   38, 964,  140, 1074 }
  };
  
  // Planteus solo se usa una vez
  
  objetoActivo[HAB_PLANTA] = !plantaUsada[ESCENARIO_HABITACIÓN];
  
  // Sale por la derecha debajo de la cama
  
  salidas = new float[][] {
    { 1800, 940, 120, 125, ESCENARIO_SALA, 190, 700, 1 }
  };
  
  escenarioActual = ESCENARIO_HABITACIÓN;
}

void administrarClicksHabitación()
{
  if (objetoEnfocado == HAB_CAMA)
  {
    usarCama();
  }
  
  if (objetoEnfocado == HAB_ESCRITORIO)
  {
    usarEscritorio();
  }
  
  if (objetoEnfocado == HAB_LIBRERÍA)
  {
    usarLibrería();
  }
  
  if (objetoEnfocado == HAB_PLANTA)
  {
    usarPlanta(ESCENARIO_HABITACIÓN, HAB_PLANTA);
  }
  
  if (objetoEnfocado == HAB_CELULAR)
  {
    usarTeléfono();
  }
}

void iniciarSala()
{
  fondoEscenario = fondoSala;
  límiteSuperior = 385;
  
  iniciarObjetos(
    new PImage[] { chimenea, fuego, estante, lámpara, plantaSala, sofá, tv },
    new String[] { "Disfrutar de la chimenea", "", "Leer", "", "Venerar a Planteus", "Descansar en el sofá", "Ver televisión" },
    new int[]    { 0, 0, 2, -1, 4, 5, 6 },
    new float[][] {
      {  565,   0,  869,  551 },
      {  659, 297,  778,  504 },
      { 1417,   0, 1879,  514 },
      { 1180, 656, 1338, 1079 },
      {  912, 102, 1049,  554 },
      { 1080, 409, 1408, 1048 },
      { 1758, 284, 1897,  996 }
    }
  );
  
  obstáculos = new float[][] {
    {  565, 381,  869,  551 },
    { 1417, 384, 1879,  514 },
    {  935, 430, 1030,  554 },
    { 1080, 608, 1408, 1048 },
    { 1758, 376, 1897,  996 }
  };
  
  objetoActivo[SALA_PLANTA] = !plantaUsada[ESCENARIO_SALA];
  
  salidas = new float[][] {
    {    0,  470, 110, 410, ESCENARIO_HABITACIÓN, 1650, 1000, 0 },
    { 1480, 1020, 220,  40, ESCENARIO_COCINA,     1730,  600, 3 }
  };
  
  escenarioActual = ESCENARIO_SALA;
}

void administrarClicksSala()
{
  if (objetoEnfocado == SALA_CHIMENEA)
  {
    usarChimenea();
  }
  
  if (objetoEnfocado == SALA_ESTANTE)
  {
    usarLibrería();
  }
  
  if (objetoEnfocado == SALA_PLANTA)
  {
    usarPlanta(ESCENARIO_SALA, SALA_PLANTA);
  }
  
  if (objetoEnfocado == SALA_SOFÁ)
  {
    usarSofá();
  }
  
  if (objetoEnfocado == SALA_TV)
  {
    usarTelevisión();
  }
}

void iniciarCocina()
{
  fondoEscenario = fondoCocina;
  límiteSuperior = 425;
  
  iniciarObjetos(
    new PImage[] { campana, lavaplatos, nevera, plantaCocina },
    new String[] { "", "Cocinar", "Comer de la nevera", "Venerar a Planteus" },
    new int[]    { 1, 1, 2, 3 },
    new float[][] {
      {   52,   0, 1332, 1079 },
      {   44,   0, 1316,  585 },
      { 1309,   0, 1582,  583 },
      { 1333, 528, 1490, 1079 }
    }
  );
  
  obstáculos = new float[][] {
    {   44, 380, 1316,  585 },
    {   54, 790, 1329, 1079 },
    { 1311, 378, 1582,  583 },
    { 1355, 969, 1471, 1079 }
  };
  
  objetoActivo[COC_PLANTA] = !plantaUsada[ESCENARIO_COCINA];
  
  // Sale por la puerta a la derecha
  
  salidas = new float[][] {
    { 1800, 480, 120, 200, ESCENARIO_SALA, 1590, 900, 1 }
  };
  
  escenarioActual = ESCENARIO_COCINA;
}

void administrarClicksCocina()
{
  if (objetoEnfocado == COC_FOGÓN)
  {
    usarCocinar();
  }
  
  if (objetoEnfocado == COC_NEVERA)
  {
    usarNevera();
  }
  
  if (objetoEnfocado == COC_PLANTA)
  {
    usarPlanta(ESCENARIO_COCINA, COC_PLANTA);
  }
}

// Flechas que indican por dónde se sale

void mostrarSalidas()
{
  float pulso = 0.5 + 0.5 * sin(millis() * 0.005);
  
  textAlign(CENTER, CENTER);
  textSize(26);
  
  for (int i = 0; i < salidas.length; i++)
  {
    float[] s = salidas[i];
    
    float centroX = s[0] + s[2] / 2;
    float centroY = s[1] + s[3] / 2;
    
    float dx = centroX - posiciónPersonaje[0];
    float dy = centroY - posiciónPersonaje[1];
    
    float opacidad = 120;
    
    if (dx * dx + dy * dy < 450 * 450)
    {
      opacidad = 230;
    }
    
    opacidad = opacidad * (0.6 + 0.4 * pulso);
    
    int dirección = (int) s[7];
    
    float hx = 0;
    float hy = 0;
    
    if (dirección == 0)
    {
      hx = -1;
    }
    if (dirección == 1)
    {
      hx = 1;
    }
    if (dirección == 2)
    {
      hy = -1;
    }
    if (dirección == 3)
    {
      hy = 1;
    }
    
    // Triángulo
    
    fill(255, opacidad);
    triangle(
      centroX + hx * 26,           centroY + hy * 26,
      centroX - hx * 22 - hy * 32, centroY - hy * 22 + hx * 32,
      centroX - hx * 22 + hy * 32, centroY - hy * 22 - hx * 32
    );
    
    // El nombre va sobre un banner oscuro
    
    String nombre = nombreEscenario[(int) s[4]];
    
    float anchoEtiqueta = textWidth(nombre) + 30;
    float etiquetaX     = constrain(centroX, anchoEtiqueta / 2 + 10, ANCHO - anchoEtiqueta / 2 - 10);
    float etiquetaY     = centroY + 62;
    
    if (dirección == 3 || centroY > ALTO - 150)
    {
      etiquetaY = centroY - 62;
    }
    
    fill(30, 20, 40, 170);
    rect(etiquetaX - anchoEtiqueta / 2, etiquetaY - 20, anchoEtiqueta, 40, 20);
    
    fill(255, opacidad);
    text(nombre, etiquetaX, etiquetaY);
  }
}

void comprobarSalidas()
{
  for (int i = 0; i < salidas.length; i++)
  {
    float[] s = salidas[i];
    
    boolean dentroEnX = posiciónPersonaje[0] >= s[0] && posiciónPersonaje[0] <= s[0] + s[2];
    boolean dentroEnY = posiciónPersonaje[1] >= s[1] && posiciónPersonaje[1] <= s[1] + s[3];
    
    if (!enTransición && dentroEnX && dentroEnY)
    {
      enTransición     = true;
      cambioRealizado  = false;
      salidaElegida    = i;
      inicioTransición = millis();
    }
  }
}

// Oscurece la pantalla

void mostrarTransición()
{
  if (enTransición)
  {
    float progreso = (millis() - inicioTransición) / 800;
    
    if (progreso >= 0.5 && !cambioRealizado)
    {
      float[] s = salidas[salidaElegida];
      
      int destino = (int) s[4];
      
      iniciarEscenario(destino);
      iniciarPersonaje(s[5], s[6]);
      
      registrarVisita(destino);
      
      cambioRealizado = true;
    }
    
    if (progreso >= 1)
    {
      enTransición = false;
    }
      else
    {
      fill(0, 255 * (1 - abs(2 * progreso - 1)));
      rect(0, 0, width, height);
    }
  }
}
