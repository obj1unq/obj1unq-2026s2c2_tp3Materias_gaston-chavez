class Estudiante {
    const carrerasInscriptas = #{}
    const historiaAcademica = new HistoriaAcademica()

    method historiaAcademica() {
      return historiaAcademica
    }

    method inscribirAlaCarraera(carrera) {
      self.validarSiPuedeInscribirseAlaCarrera(carrera)
      self.agregarCarrera(carrera)
    }

    method agregarCarrera(carrera) {
      carrerasInscriptas.add(carrera)
    }

    method validarSiPuedeInscribirseAlaCarrera(carrera) {
      if(self.estaInscriptoA(carrera)) {
        self.error("ya esta inscripto a esta carrera")
      }
    }

    method estaInscriptoA(carrera) {
      return carrerasInscriptas.contains(carrera)
    }

    method carrerasInscriptas() {
      return carrerasInscriptas
    }

    method estaInscriptoAlaMateria(materia) {
      return carrerasInscriptas.any({carrera => carrera.tieneMateria(materia)})
    }

    method registrarMateria(registrarMateria,registrarNota) {
      self.validarSiEstaInscriptoAMateria(registrarMateria)
      historiaAcademica.registrarMateria(registrarMateria, registrarNota)
    }

    method validarSiEstaInscriptoAMateria(materia) {
    if (!self.estaInscriptoAlaMateria(materia)) {
      self.error("no esta inscripto a la materia" + materia)
    }
  }

  method estaAprobada(materia) {
    return historiaAcademica.estaAprobada(materia)
  }

  method promedioEn(carrera) {
    self.validarSiEstaInscriptoA(carrera)
    return historiaAcademica.promedioEn(carrera)
  }

  method validarSiEstaInscriptoA(carrera) {
    if(!self.estaInscriptoA(carrera)){
      self.error("no esta inscripto a la carrera")
    }
  }

  method promedioEnTodasLasCarreras() {
    return historiaAcademica.promedioEnTodasLasCarreras()
  }

  method cursadasDeMateria(materia) {
    return historiaAcademica.cursadasDeMateria(materia)
  }
}

class Carrera {
    const materias 

    method materias() {
      return materias
    }

    method tieneMateria(materia) {
      return materias.contains(materia)
    }

    method materiasEnLaQueSePuedeInscribir(estudiante) {
      return materias.filter({materia => materia.puedeInscribirA(estudiante)})
    }
}

class Materia {
  const materia
  const estudiantes 
  var requisitos = #{}

  method requisitos(_requisitos) {
    requisitos = _requisitos
  }

  method materia() {
    return materia
  }

  method estudiantes() {
    return estudiantes
  }

  method puedeInscribirA(estudiante) {
    return self.materiaEstaEnAlgunaCarreraDe(estudiante)     &&
           not self.estudianteTieneAprobadaM(estudiante)     &&
           not self.tieneInscriptoA(estudiante)              &&
           self.tieneAprobadasMateriasRequisitos(estudiante)
  }

  method tieneAprobadasMateriasRequisitos(estudiante) {
    return requisitos.all({requisito => self.tieneAprobadaRequisito(estudiante, requisito)})
  }

  method tieneAprobadaRequisito(estudiante, requisito) {
    return estudiante.historiaAcademica().estaAprobada(requisito)
  }

  method materiaEstaEnAlgunaCarreraDe(estudiante) {
    return estudiante.estaInscriptoAlaMateria(self)
  }

  method estudianteTieneAprobadaM(estudiante) {
    return estudiante.historiaAcademica().estaAprobada(self)
  }

  method tieneInscriptoA(estudiante) {
    return estudiantes.contains(estudiante)
  }

  method inscribirEstudianteAM(estudiante) {
    self.validarSiPúedeInscribirseAM(estudiante)
    self.inscribirEstudiante(estudiante)
  }

  method validarSiPúedeInscribirseAM(estudiante) {
    if(not self.puedeInscribirA(estudiante)) {
      self.error("no puede inscribirse a la materia")
    }
  }

  method inscribirEstudiante(estudiante) {
    estudiantes.add(estudiante)
  }
}

class MateriaYNota {
  const materia 
  const nota

  method materia() {
    return materia
  }

  method nota() {
    return nota
  }
}

class HistoriaAcademica {
  const cursadas = []

  method registrarMateria(registrarMateria,registrarNota) {
    self.validarSiEsNotaValida(registrarNota)
    self.validarQueNoEsteAprobada(registrarMateria)
    self.agregarMateriaACursadas(registrarMateria,registrarNota)
  }

  method validarSiEsNotaValida(nota) {
    if(!nota.between(1, 10)) {
      self.error("la nota es invalida")
    }
  }

  method validarQueNoEsteAprobada(materia) {
    if (self.estaAprobada(materia)) {
      self.error("la materia ya esta aprobada")
    }
  }

  method estaAprobada(materia) {
    return cursadas.any({ cursada =>
      cursada.materia() == materia && cursada.nota().between(6, 10)
    })
  }

  method agregarMateriaACursadas(registrarMateria,registrarNota) {
    cursadas.add(new MateriaYNota(materia = registrarMateria, nota = registrarNota))
  }

  method promedioEn(carrera) {
    const aprobadas = self.materiasAprobadasEn(carrera)
    self.validarSiTieneMateriasAprobadas(aprobadas)
    return self.notaDeMateriasEn(carrera) / self.cantidadMateriasAprobadas(carrera)
  }

  method notaDeMateriasEn(carrera) {
    return self.materiasAprobadasEn(carrera).sum({materiaAprobada => materiaAprobada.nota()})
  }

  method materiasAprobadasEn(carrera) {
    return cursadas.filter({cursada => carrera.tieneMateria(cursada.materia()) &&
    cursada.nota().between(6, 10)})
  }

  method cantidadMateriasAprobadas(carrera) {
    return self.materiasAprobadasEn(carrera).size()
  }

  method validarSiTieneMateriasAprobadas(materiasAprobadas) {
    if(materiasAprobadas.isEmpty()){
      self.error("no tiene materias aprobadas")
    }
  }

  method promedioEnTodasLasCarreras() {
    const materiasAprobadas = cursadas.filter({materiaAprobada => materiaAprobada.nota().between(6, 10)})
    self.validarSiTieneMateriasAprobadas(materiasAprobadas)
    return self.notas(materiasAprobadas) / materiasAprobadas.size()
  }

  method notas(materias) {
    return materias.sum({materia => materia.nota()})
  }

  method cursadasDeMateria(materia) {
    return cursadas.filter({cursada => cursada.materia() == materia})
  }
}
