
// Burbuja con texto junto al puntero

void mostrarEtiqueta(String mensaje)
{
  textAlign(LEFT, CENTER);
  textSize(24);
  
  float ancho = textWidth(mensaje) + 20;
  
  float x = mouseX + 10;
  float y = mouseY;
  
  if (x > width - ancho - 10)
  {
    x = width - ancho - 10;
  }
  
  if (y < 30)
  {
    y = 30;
  }
  
  fill(30, 20, 40, 190);
  rect(x, y - 20, ancho, 40, 20);
  
  fill(255);
  text(mensaje, x + 10, y);
}
