
String[] nombreDía = { "Lunes", "Martes", "Miércoles", "Jueves", "Viernes" };

void mostrarAviso(String mensaje)
{
  aviso       = mensaje;
  tiempoAviso = millis();
}

void mostrarAvisoActual()
{
  float edad = (millis() - tiempoAviso) / 1000;
  
  if (edad > 4)
  {
    aviso = "";
  }
  
  if (aviso.length() > 0)
  {
    dibujarAviso(edad);
  }
}

// Dibuja el aviso que se desvanece

void dibujarAviso(float edad)
{
  float opacidad = constrain((4 - edad) / 0.5, 0, 1) * 255;
  
  textSize(28);
  
  float ancho = 1100;
  float alto  = 30 + 42 * contarLíneas(aviso);
  
  fill(35, 20, 25, opacidad * 0.9);
  rect(width / 2 - ancho / 2, 110, ancho, alto, 30);
  
  fill(255, opacidad);
  
  textAlign(CENTER, CENTER);
  text(aviso, width / 2, 110 + alto / 2);
}

// Cuántas líneas tiene un texto

int contarLíneas(String texto)
{
  int líneas = 1;
  
  for (int i = 0; i < texto.length(); i++)
  {
    if (texto.charAt(i) == '\n')
    {
      líneas++;
    }
  }
  
  return líneas;
}

void mostrarBarras()
{
  fill(50, 35, 35);
  
  rect(100, 50, 400, 35, 15);
  rect(600, 50, 400, 35, 15);
  
  fill(230, 230, 0);
  rect(100, 50, (400 * energía) / 100, 35, 15);
  
  fill(230, 120, 0);
  rect(600, 50, (400 * ansiedad) / 100, 35, 15);
  
  image(iconoEnergía,   50, 50);
  image(iconoAnsiedad, 550, 50);
  
  if (estáRatónSobreRectángulo(100, 50, 400, 35))
  {
    mostrarEtiqueta("Energía: " + energía);
  }
  if (estáRatónSobreRectángulo(600, 50, 400, 35))
  {
    mostrarEtiqueta("Ansiedad: " + ansiedad);
  }
  
  fill(255);
  escribir(nombreEscenario[escenarioActual], ANCHO - 50, 67, 32, RIGHT);
}

void mostrarReloj()
{
  int día  = díaActual();
  int hora = horaActual();
  
  // Al terminar la semana el reloj marca el sábado a las 0:00, pero se muestra el viernes
  
  if (día > 4)
  {
    día = 4;
  }
  
  String horaTexto = "" + hora;
  
  if (hora < 10)
  {
    horaTexto = "0" + hora;
  }
  
  dibujarCinta(30, 972, 340, 56);
  
  fill(255);
  escribir(horaTexto + ":00 — " + nombreDía[día], 50, 1000, 32, LEFT);
}

void mostrarTareas()
{
  dibujarCinta(30, 922, 340, 52);
  
  fill(255);
  escribir("Tareas pendientes: " + tareasPendientes, 50, 950, 28, LEFT);
}

// Cinta oscura semitransparente para que el texto se lea sobre cualquier fondo

void dibujarCinta(float x, float y, float ancho, float alto)
{
  fill(30, 20, 40, 150);
  rect(x, y, ancho, alto, 24);
}

void dibujarPanel(float x, float y, float ancho, float alto)
{
  fill(120, 90, 150, 230);
  rect(x - 6, y - 6, ancho + 12, alto + 12, 36);
  
  fill(32, 20, 42, 242);
  rect(x, y, ancho, alto, 30);
}

// Botón con texto centrado que se aclara si el puntero está encima

boolean dibujarBotón(String texto, float x, float y, float ancho, float alto, int tamaño, int rojo, int verde, int azul)
{
  boolean encima = estáRatónSobreRectángulo(x, y, ancho, alto);
  
  int brillo = 0;
  
  if (encima)
  {
    brillo = 45;
  }
  
  fill(constrain(rojo + brillo, 0, 255), constrain(verde + brillo, 0, 255), constrain(azul + brillo, 0, 255), 235);
  rect(x, y, ancho, alto, 24);
  
  fill(255);
  escribir(texto, x + ancho / 2, y + alto / 2, tamaño, CENTER);
  
  return encima;
}
