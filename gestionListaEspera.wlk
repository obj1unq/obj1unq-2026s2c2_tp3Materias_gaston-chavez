import materias.*
import requisitos.*
object ordenDeLlegada {
    method prioridadEnLaCola(estudiantesEnEspera) {
      return estudiantesEnEspera.head()
    }
}

object elitista {
    method prioridadEnLaCola(estudiantes) {
      return estudiantes.max({estudiante => estudiante.promedioEnTodasLasCarreras()})
    }
}

object avance {
    method prioridadEnLaCola(estudiantes) {
      return estudiantes.max({estudiante => estudiante.creditosEnTodasLasMaterias()})
    }
}