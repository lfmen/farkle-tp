#-------------------------------------------------------------------------------
# FUNCIONES AUXILIARES - Farkle
# Se carga desde jugar.R con source("funciones.R")
#-------------------------------------------------------------------------------

#' Calcula el puntaje obtenido en una tirada
#'
#' Suma 100 puntos por cada dado que muestra 1 y 50 puntos por cada dado
#' que muestra 5. Los demás valores no suman puntos.
#'
#' @param tirada Vector numérico con los resultados de los dados tirados.
#' @return Número entero con el puntaje total de la tirada.
calcular_puntaje_tirada <- function(tirada) {
  puntaje <- 0
  for (dado in tirada) {
    if (dado == 1) {
      puntaje <- puntaje + 100
    } else if (dado == 5) {
      puntaje <- puntaje + 50
    }
  }
  return(puntaje)
}

#' Cuenta cuántos dados de una tirada no suman puntos
#'
#' Devuelve los dados cuyo valor no es 1 ni 5, es decir, los que
#' se vuelven a lanzar en la siguiente tirada del turno.
#'
#' @param tirada Vector numérico con los resultados de los dados tirados.
#' @return Vector numérico con los dados que no suman puntos.
dados_sin_puntaje <- function(tirada) {
  restantes <- c()
  for (dado in tirada) {
    if (dado != 1 && dado != 5) {
      restantes <- c(restantes, dado)
    }
  }
  return(restantes)
}

#' Muestra la tabla de puntajes actuales de ambos jugadores
#'
#' Imprime en pantalla los nombres y puntajes de los dos jugadores
#' en formato de tabla sencilla.
#'
#' @param nombre1 Cadena de texto con el nombre del jugador 1.
#' @param nombre2 Cadena de texto con el nombre del jugador 2.
#' @param puntaje1 Número con el puntaje total del jugador 1.
#' @param puntaje2 Número con el puntaje total del jugador 2.
mostrar_tabla <- function(nombre1, nombre2, puntaje1, puntaje2) {
  cat("------------------------------------------\n")
  cat("  JUGADOR              PUNTOS\n")
  cat("------------------------------------------\n")
  cat(" ", nombre1, "             ", puntaje1, "\n")
  cat(" ", nombre2, "             ", puntaje2, "\n")
  cat("------------------------------------------\n")
}

#' Ejecuta el turno completo de un jugador
#'
#' Gestiona todas las tiradas del jugador durante su turno: lanza los dados,
#' calcula el puntaje, permite decidir si continúa o se detiene, y maneja
#' los casos especiales (sin puntos, todos los dados usados, pasarse del máximo).
#'
#' @param nombre Cadena de texto con el nombre del jugador.
#' @param puntaje_total Número con el puntaje total acumulado del jugador.
#' @param puntaje_maximo Número con el puntaje objetivo del juego (1000).
#' @return Número con los puntos ganados en este turno (0 si perdió el turno).
ejecutar_turno <- function(nombre, puntaje_total, puntaje_maximo) {
  puntaje_turno <- 0
  dados_disponibles <- 5
  veces_tirado <- 0

  while (TRUE) {
    # Mostrar información del turno
    cat("\n")
    titulo(paste("Turno de", nombre))
    cat(" Puntaje total del jugador:", puntaje_total, "\n")
    cat("------------------------------------------\n")
    cat(" Tiradas realizadas    :", veces_tirado, "\n")
    cat(" Puntos en este turno  :", puntaje_turno, "\n")
    cat(" Dados disponibles     :", dados_disponibles, "\n")
    cat("------------------------------------------\n")

    # Preguntar si quiere tirar
    opcion <- leer_opciones("Elegí una opción:", "Tirar dados", "Terminar turno")

    if (opcion == 2) {
      # El jugador decide detenerse
      cat("\nTurno finalizado.\n")
      pausa()
      return(puntaje_turno)
    }

    # Realizar la tirada
    tirada <- tirar_dados(dados_disponibles)
    veces_tirado <- veces_tirado + 1

    cat("\nSalieron los siguientes dados:\n")
    mostrar_dados(tirada)

    puntaje_tirada <- calcular_puntaje_tirada(tirada)

    if (puntaje_tirada == 0) {
      # No salió ningún 1 ni 5: el turno termina y se pierden los puntos
      cat("\nNo salió ningún 1 ni 5. ¡Perdiste los puntos del turno!\n")
      pausa()
      return(0)
    }

    # Hay al menos un dado que suma
    cat("\nPuntaje de esta tirada:", puntaje_tirada, "\n")
    puntaje_turno <- puntaje_turno + puntaje_tirada

    # Verificar si se pasaría del puntaje máximo
    if (puntaje_total + puntaje_turno > puntaje_maximo) {
      cat("\n¡Te pasaste del puntaje máximo! Perdés los puntos del turno.\n")
      pausa()
      return(0)
    }

    # Calcular dados restantes (los que no sumaron)
    restantes <- dados_sin_puntaje(tirada)
    dados_disponibles <- length(restantes)

    if (dados_disponibles == 0) {
      # Todos los dados sumaron: se puede reiniciar con 5 dados
      cat("\n¡Usaste todos los dados! Podés volver a tirar con 5 dados.\n")
      cat("Puntaje acumulado en este turno:", puntaje_turno, "\n")
      pausa()
      opcion2 <- leer_opciones("¿Qué hacés?", "Tirar con 5 dados", "Terminar turno")
      if (opcion2 == 2) {
        cat("\nTurno finalizado.\n")
        pausa()
        return(puntaje_turno)
      }
      dados_disponibles <- 5
    } else {
      cat("Tiro finalizado.\n")
      pausa()
    }
  }
}

#' Muestra la pantalla de inicio y lee los nombres de los jugadores
#'
#' Presenta el título del juego, las reglas y solicita los nombres
#' de ambos jugadores antes de comenzar la partida.
#'
#' @return Vector de caracteres con los dos nombres ingresados.
pantalla_inicio <- function() {
  limpiar_consola()
  titulo("FARKLE")

  texto_lento("Bienvenidos a Farkle, el juego de dados de estrategia y riesgo.\n")
  texto_lento("Dos jugadores compiten por ser el primero en llegar a 1000 puntos.\n\n")

  texto_lento("=== REGLAS ===\n")
  texto_lento("- Cada jugador tira 5 dados por turno.\n")
  texto_lento("- Un dado con 1 suma 100 puntos. Un dado con 5 suma 50 puntos.\n")
  texto_lento("- Los dados que suman puntos se retiran. Los demás se pueden volver a tirar.\n")
  texto_lento("- Si ningún dado suma puntos, perdés todos los puntos del turno.\n")
  texto_lento("- Si te pasás de 1000, perdés los puntos del turno.\n")
  texto_lento("- Si todos los dados sumaron, podés volver a tirar con 5 dados.\n\n")

  cat("Antes de comenzar, ingresá los nombres de los jugadores.\n\n")
  cat("Nombre del jugador 1: ")
  nombre1 <- leer_palabra()
  cat("Nombre del jugador 2: ")
  nombre2 <- leer_palabra()

  cat("\n¡Perfecto! Van a jugar", nombre1, "contra", nombre2, ".\n")
  pausa()

  return(c(nombre1, nombre2))
}
