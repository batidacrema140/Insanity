
// ==============
// | Cronómetro |
// ==============

void iniciarCronómetro()
{
  tiempoReferencia = millis();
}

float cronómetro()
{
  return (millis() - tiempoReferencia) / 1000;
}

// =================
// | Interpolación |
// =================

float interpolarRebote(float x)
{
  float resultado = 1;

  if (x < 1)
  {
    resultado = (4 + (2 * x - 5) * x) * x;
  }

  return resultado;
}

float invertirInterpolarRebote(float x)
{
  return 1 - interpolarRebote(x);
}

// ======================
// | Lógica del puntero |
// ======================

boolean estáRatónSobreRectángulo(float x, float y, float ancho, float alto)
{
  return
    x <= mouseX && mouseX <= x + ancho &&
    y <= mouseY && mouseY <= y + alto;
}

// =========
// | Texto |
// =========

// Escribe un texto con el tamaño y la alineación horizontal dada

void escribir(String texto, float x, float y, int tamaño, int alineación)
{
  textAlign(alineación, CENTER);
  textSize(tamaño);
  
  text(texto, x, y);
}
