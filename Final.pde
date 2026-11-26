
int RESULTADO_DERROTA = 0;
int RESULTADO_MALO    = 1;
int RESULTADO_NORMAL  = 2;
int RESULTADO_BUENO   = 3;

// Qué final se obtuvo según la ansiedad y la puntuación secreta

int resultadoFinal()
{
  int total = puntuaciónTotal();
  
  int resultado = RESULTADO_MALO;
  
  if (total >= FINAL_NORMAL)
  {
    resultado = RESULTADO_NORMAL;
  }
  if (total >= FINAL_BUENO)
  {
    resultado = RESULTADO_BUENO;
  }
  if (derrota)
  {
    resultado = RESULTADO_DERROTA;
  }
  
  return resultado;
}

String[] títuloFinal = { "Perdiste", "Final malo", "Final normal", "Final bueno" };

String[] mensajeFinal = {
  "Tu ansiedad llegó al 100. A veces hay que parar, respirar y pedir ayuda.\nTe consumió la locura y adoras una planta D:",
  "La semana te superó: las tareas, el sueño y el teléfono pasaron factura.\nLa próxima vez sé más positivo.",
  "Saliste adelante, pero todavía puedes cuidar mejor tu tiempo y tu calma.\nEstás bien.",
  "Aprendiste a soltar el teléfono y a cuidar de ti. La semana terminó con calma.\nTE VAS A COMER EL MUNDO GANADORA :D"
};

// Nombres de los logros conseguidos en esta partida

String logrosDeLaPartida()
{
  String lista = "";
  
  for (int i = 0; i < TOTAL_LOGROS; i++)
  {
    if (logroEnPartida[i])
    {
      if (lista.length() > 0)
      {
        lista += "   •   ";
      }
      
      lista += logroNombre[i];
    }
  }
  
  if (lista.length() == 0)
  {
    lista = "Ninguno todavía: ¡prueba cosas nuevas!";
  }
  
  return lista;
}

int cantidadLogrosDeLaPartida()
{
  int cantidad = 0;
  
  for (int i = 0; i < TOTAL_LOGROS; i++)
  {
    if (logroEnPartida[i])
    {
      cantidad += 1;
    }
  }
  
  return cantidad;
}

// Pantalla final

void mostrarFinal()
{
  if (!finalIniciado)
  {
    finalIniciado = true;
    iniciarCronómetro();
    
    evaluarLogrosFinales();
  }
  
  float t = cronómetro();
  
  int total     = puntuaciónTotal();
  int resultado = resultadoFinal();
  
  switch (resultado)
  {
    case 0:
      background(fondoDerrota);
    break;
    
    case 1:
      background(fondoMalo);
    break;
    
    case 2:
      background(fondoNeutral);
    break;
    
    case 3:
      background(fondoBueno);
    break;
  }
  
  fill(255);
  
  String título = "Terminó la semana";
  
  if (derrota)
  {
    título = "Se acabó la partida";
  }
  
  escribir(título, width / 2, 110, 56, CENTER);
  
  if (t > 1)
  {
    escribir("Tareas completadas: " + tareasCompletadas + "      Tareas sin hacer: " + tareasPendientes, width / 2, 220, 30, CENTER);
    escribir("Veces que usaste el teléfono: " + usosTeléfono, width / 2, 268, 30, CENTER);
  }
  
  if (t > 2.5)
  {
    escribir("Responsabilidades: " + puntos[PUNTOS_RESPONSABILIDAD], width / 2, 350, 30, CENTER);
    escribir("Bienestar: "        + puntos[PUNTOS_BIENESTAR], width / 2, 396, 30, CENTER);
    escribir("Teléfono: "         + puntos[PUNTOS_TELÉFONO], width / 2, 442, 30, CENTER);
  }
  
  if (t > 4.5)
  {
    escribir("Puntuación secreta: " + total, width / 2, 540, 48, CENTER);
  }
  
  if (t > 6)
  {
    escribir(títuloFinal[resultado], width / 2, 640, 64, CENTER);
    escribir(mensajeFinal[resultado], width / 2, 715, 30, CENTER);
  }
  
  if (t > 7)
  {
    fill(255, 205, 60);
    escribir("Logros de esta partida: " + cantidadLogrosDeLaPartida() + " de " + TOTAL_LOGROS, width / 2, 800, 28, CENTER);

    fill(230);
    textAlign(CENTER, TOP);
    textSize(22);
    text(logrosDeLaPartida(), width / 2 - 750, 830, 1500, 130);
  }
  
  if (t > 8)
  {
    fill(255);
    escribir("Haz click para volver al menú", width / 2, 1030, 24, CENTER);
  }
}
