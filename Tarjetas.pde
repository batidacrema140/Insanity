
// Crea una tarjeta

void iniciarTarjeta(PImage tarjeta)
{
  estáActivaTarjeta = true;
  tarjetaActual     = tarjeta;
  platoActual       = null;
  
  iniciarCronómetro();
}

void mostrarPlato(PImage plato, String nombre)
{
  platoActual = plato;
  nombrePlato = nombre;
}

// Muestra la tarjeta

void mostrarTarjeta()
{
  float desplazamiento = -invertirInterpolarRebote(cronómetro() / 2) * width;
  
  image(tarjetaActual, desplazamiento, 0);
  
  if (platoActual != null && cronómetro() > 1.6)
  {
    dibujarPlato();
  }
  
  if (cronómetro() > 3)
  {
    mostrarEtiqueta("Haz click para continuar...");
  }
}

// Dibuja el plato abajo a la derecha

void dibujarPlato()
{
  float aparición = constrain((cronómetro() - 1.6) / 0.8, 0, 1);
  float escala    = interpolarRebote(aparición);
  
  float ancho = platoActual.width  * escala;
  float alto  = platoActual.height * escala;
  
  float centroX = 1420;
  float baseY   = 885;
  
  fill(0, 80);
  ellipse(centroX, baseY, ancho * 0.9, 50 * escala);
  
  image(platoActual, centroX - ancho / 2, baseY - alto, ancho, alto);
  
  if (aparición >= 1)
  {
    dibujarCinta(centroX - 190, baseY + 14, 380, 52);
    
    fill(255);
    escribir(nombrePlato, centroX, baseY + 40, 30, CENTER);
  }
}

// Inténta cerrar la tarjeta

void intentarCerrarTarjeta()
{
  if (cronómetro() > 3)
  {
    estáActivaTarjeta = false;
    
    // Muestra lo que cambió con la acción que activó la tarjeta
    
    if (avisoPendiente.length() > 0)
    {
      mostrarAviso(avisoPendiente);
      avisoPendiente = "";
    }
  }
}
