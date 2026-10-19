object creditos {
  method cumpleRequisitos(carrera,estudiante,materia) {
    return self.creditosDeMaterias(estudiante,carrera) >= materia.creditosNecesarios()
  }

  method creditosDeMaterias(estudiante,carrera) {
    return estudiante.materiasAprobadasEn(carrera).sum({materiaActual => materiaActual.materia().creditos()})
  }
}

object anio { 
  method cumpleRequisitos(carrera,estudiante,materia) {
    return self.materiasAprobadasAnioPasado(estudiante,carrera,materia) == self.materiasQuePertencenAnioAnterior(carrera,materia)
  }

  method materiasAprobadasAnioPasado(estudiante,carrera,materia) {
    return estudiante.materiasAprobadasEn(carrera).filter({materiaActual => materiaActual.materia().anio() == materia.anio() - 1}).size()
  }

  method materiasQuePertencenAnioAnterior(carrera,materia) {
    return carrera.materias().filter({materiaActual => materiaActual.anio() == materia.anio()-1}).size()
  }
}

class Correlativas {
  const correlativas

  method cumpleRequisitos(carrera,estudiante,materia){
    return correlativas.all({correlativa => self.tieneAprobadaRequisito(estudiante, correlativa)})
  }

  method tieneAprobadaRequisito(estudiante, correlativa) {
    return estudiante.estaAprobada(correlativa)
  }
}

object sinRequisitos { //nada
  method cumpleRequisitos(carrera,estudiante,materia) {
    return true
  }
}