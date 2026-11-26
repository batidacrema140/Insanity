
// Establece la sección actual a créditos

void iniciarCréditos()
{
  créditoActual = 0;
  iniciarCronómetro();
  
  secciónActual = 2;
}

// Administra el ciclo de los créditos

void administrarCréditos()
{
  background(fondoCréditos);
  
  float desplazamiento = (invertirInterpolarRebote(cronómetro()) - créditoActual) * height;
  
  image(David,    width / 2 -    David.width / 2, desplazamiento);
  image(Dayana,   width / 2 -   Dayana.width / 2, desplazamiento +     height);
  image(Isabella, width / 2 - Isabella.width / 2, desplazamiento + 2 * height);
  image(Paula,    width / 2 -    Paula.width / 2, desplazamiento + 3 * height);
  
  mostrarEtiqueta("Nos esforzamos mucho <3");
}

// En caso de que se haya hecho click

void administrarClicksCréditos()
{
  if (cronómetro() > 1)
  {
    if (créditoActual < 3)
    {
      créditoActual += 1;
      iniciarCronómetro();
    }
      else
    {
      iniciarMenú();
    }
  }
}
