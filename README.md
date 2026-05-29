# Farkle TP - Programación 1 (2026)

Trabajo Práctico de la materia **Programación 1** - Implementación del juego de dados **Farkle** en R.

## Integrantes del grupo

- Vazquez, Santos Nicolás - Comisión 4A
- Morello, Nino Julián - Comisión 2A
- Mengarelli, Luca Franco - Comisión 1B

## Organización del grupo

El trabajo fue desarrollado de forma colaborativa usando **GitHub** como repositorio compartido.
Cada integrante trabajó en su propia rama y subió sus cambios al repositorio para que el resto
pudiera verlos e integrarlos.

La división del trabajo se hizo por funciones: cada uno tomó las funciones que le correspondían,
las implementó de forma independiente y las documentó siguiendo el mismo estilo que el resto del
grupo. A continuación se detalla quién hizo qué en cada archivo.

### `funciones.R`

| Función | Responsable | Estado |
|---|---|---|
| `calcular_puntaje_tirada` | Nino | Terminada |
| `dados_sin_puntaje` | Luca | Terminada |
| `ejecutar_turno` | Nino | En progreso |

### `interfaz.R`

| Función | Responsable | Estado |
|---|---|---|
| `pantalla_inicio` | Nico | Terminada |
| `mostrar_tabla` | Nico | Terminada |

### `jugar.R`

| Sección | Responsable | Estado |
|---|---|---|
| Programa principal (bucle de rondas, lógica de fin de juego) | Luca | Terminado |

## Cómo ejecutar

Desde la terminal, situarse en este directorio y correr:

```bash
Rscript jugar.R
```

## Estructura del proyecto

```
├── jugar.R        # Script principal (punto de entrada)
├── funciones.R    # Funciones del juego: calcular_puntaje_tirada, dados_sin_puntaje, ejecutar_turno
├── interfaz.R     # Funciones de interfaz: pantalla_inicio, mostrar_tabla
└── README.md
```

> **Nota:** Las funciones `pantalla_inicio` y `mostrar_tabla` fueron implementadas por Nico
> en `interfaz.R` en lugar de `funciones.R`. El archivo `jugar.R` carga ambos archivos con
> `source()`, por lo que el juego funciona correctamente. Las funciones siguen estando
> disponibles de la misma manera para el resto del código.

## Instalación del paquete `farkle`

Correr **una sola vez** antes de ejecutar el programa:

```r
install.packages("pak")
pak::pkg_install("ee-unr/programacion-1/tp/farkle")
```

## Reglas del juego

- Se juega entre **dos jugadores**, por turnos.
- En cada turno se lanzan **5 dados**.
- Cada **1** suma 100 puntos; cada **5** suma 50 puntos.
- Los dados que muestran 1 o 5 se retiran; con los restantes se puede seguir tirando o detenerse.
- Si ningún dado muestra 1 o 5, el turno termina y se pierden los puntos acumulados en ese turno.
- Si todos los dados son retirados, se puede volver a tirar con 5 dados manteniendo el puntaje del turno.
- **Gana el primero en llegar exactamente a 1000 puntos.** Si se supera ese número, no se suman los puntos del turno.

