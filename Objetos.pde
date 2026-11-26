
void iniciarObjetos(PImage[] imágenes, String[] nombres, int[] grupos, float[][] cajas)
{
  objetoImagen    = imágenes;
  objetoNombre    = nombres;
  objetoGrupo     = grupos;
  objetoCaja      = cajas;
  objetoElevación = new float[imágenes.length];
  objetoActivo    = new boolean[imágenes.length];
  
  for (int i = 0; i < imágenes.length; i++)
  {
    objetoActivo[i] = true;
  }
  
  objetoEnfocado = -1;
}

// Devuelve el objeto que está bajo el puntero o -1

int buscarObjetoBajoRatón()
{
  int objeto = -1;
  
  for (int i = 0; i < objetoImagen.length; i++)
  {
    float[] caja = objetoCaja[i];
    
    if (objetoGrupo[i] == i && mouseX >= caja[0] && mouseX <= caja[2] && mouseY >= caja[1] && mouseY <= caja[3])
    {
      objeto = i;
    }
  }
  
  return objeto;
}

boolean estáCercaDeObjeto(int objeto)
{
  float[] caja = objetoCaja[objeto];
  
  float dx = 0;
  float dy = 0;
  
  if (posiciónPersonaje[0] < caja[0])
  {
    dx = caja[0] - posiciónPersonaje[0];
  }
  
  if (posiciónPersonaje[0] > caja[2])
  {
    dx = posiciónPersonaje[0] - caja[2];
  }
  
  if (posiciónPersonaje[1] < caja[1])
  {
    dy = caja[1] - posiciónPersonaje[1];
  }
  
  if (posiciónPersonaje[1] > caja[3])
  {
    dy = posiciónPersonaje[1] - caja[3];
  }
  
  return dx * dx + dy * dy <= 280 * 280;
}

// Detecta el objeto enfocado y sube o baja suavemente cada objeto

void actualizarObjetos()
{
  objetoEnfocado = -1;
  
  if (!enTransición)
  {
    objetoEnfocado = buscarObjetoBajoRatón();
  }
  
  for (int i = 0; i < objetoImagen.length; i++)
  {
    if (objetoGrupo[i] == i)
    {
      float meta = 0;
      
      if (i == objetoEnfocado)
      {
        meta = 20;
      }
      
      objetoElevación[i] += (meta - objetoElevación[i]) * 0.25;
    }
  }
}

// Dibuja los objetos que quedan detrás del personaje delante de él

void dibujarObjetos(boolean delante)
{
  for (int i = 0; i < objetoImagen.length; i++)
  {
    boolean estáDelante = objetoCaja[i][3] > posiciónPersonaje[1];
    
    if (estáDelante == delante)
    {
      int líder = objetoGrupo[i];
      
      float elevación = 0;
      
      if (líder >= 0)
      {
        elevación = objetoElevación[líder];
      }
      
      // Lo que ya no sirve se ve apagado
      
      noTint();
      
      if (líder >= 0 && !objetoActivo[líder])
      {
        tint(150);
      }
      
      image(objetoImagen[i], 0, -elevación);
    }
  }
  
  noTint();
}

// Nombre del objeto enfocado

void mostrarEtiquetaObjeto()
{
  if (objetoEnfocado >= 0)
  {
    String texto = objetoNombre[objetoEnfocado];
    
    if (!estáCercaDeObjeto(objetoEnfocado))
    {
      texto += " (acércate)";
    }
    
    mostrarEtiqueta(texto);
  }
}
