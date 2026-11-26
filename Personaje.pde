
float MEDIO_ANCHO_PIES = 45;
float MEDIO_ALTO_PIES  = 18;

void iniciarPersonaje(float x, float y)
{
  posiciónPersonaje[0] = x;
  posiciónPersonaje[1] = y;
}

boolean hayColisión(float x, float y)
{
  boolean choca = false;
  
  // Bordes de la pantalla y pared del fondo
  
  if (x - MEDIO_ANCHO_PIES < 0 || x + MEDIO_ANCHO_PIES > ANCHO)
  {
    choca = true;
  }
  if (y - MEDIO_ALTO_PIES < límiteSuperior || y + MEDIO_ALTO_PIES > ALTO - 5)
  {
    choca = true;
  }
  
  // Obstáculos
  
  for (int i = 0; i < obstáculos.length; i++)
  {
    float[] o = obstáculos[i];
    
    if (x + MEDIO_ANCHO_PIES > o[0] && x - MEDIO_ANCHO_PIES < o[2] && y + MEDIO_ALTO_PIES > o[1] && y - MEDIO_ALTO_PIES < o[3])
    {
      choca = true;
    }
  }
  
  return choca;
}

// Camina hacia el puntero

void moverPersonaje()
{
  if (!enTransición)
  {
    float dx = mouseX - posiciónPersonaje[0];
    float dy = mouseY - posiciónPersonaje[1];
    
    float distancia = sqrt(dx * dx + dy * dy);
    
    // Mira hacia el puntero
    
    if (distancia > 12)
    {
      girarPersonaje(dx, dy);
    }
    if (distancia >= 1)
    {
      caminarPersonaje(dx, dy, distancia);
    }
  }
}

// Elige cuál de los 8 dibujos del personaje mira hacia donde apunta el puntero

void girarPersonaje(float dx, float dy)
{
  int ángulo = floor(4 * atan2(dy, dx) / PI + 4.5);
  
  if (ángulo > 7)
  {
    ángulo = 0;
  }
  
  direcciónPersonaje = ángulo;
}

// Se mueve hacia el puntero

void caminarPersonaje(float dx, float dy, float distancia)
{
  float x = posiciónPersonaje[0];
  float y = posiciónPersonaje[1];
  
  float paso = constrain(distancia * 0.06, 2.5, 22);
  
  if (paso > distancia)
  {
    paso = distancia;
  }
  
  float pasoX = dx / distancia * paso;
  float pasoY = dy / distancia * paso;
  
  // Evita quedar atorado en un obstáculo
  
  boolean atascado = hayColisión(x, y);
  
  if (atascado || !hayColisión(x + pasoX, y))
  {
    x += pasoX;
  }
  if (atascado || !hayColisión(x, y + pasoY))
  {
    y += pasoY;
  }

  posiciónPersonaje[0] = x;
  posiciónPersonaje[1] = y;
}

void mostrarPersonaje()
{
  PImage sprite = personaje[direcciónPersonaje];
  
  float ancho = sprite.width  * 0.7;
  float alto  = sprite.height * 0.7;
  
  float x = posiciónPersonaje[0];
  float y = posiciónPersonaje[1];
  
  fill(0, 70);
  ellipse(x, y, 2 * MEDIO_ANCHO_PIES + 20, 2 * MEDIO_ALTO_PIES);
  
  image(sprite, x - ancho / 2, y - alto, ancho, alto);
}
