class Estudiante {
    const carrerasInscriptas = #{}
    const historiaAcademica = new HistoriaAcademica()

    method historiaAcademica() {
      return historiaAcademica
    }

    method materiasAprobadasEn(carrera) {
      return historiaAcademica.materiasAprobadasEn(carrera)
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
      self.error("ya esta inscripto a la materia" + materia)
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
    const property materias = #{}

    method tieneMateria(materia) {
      return materias.contains(materia)
    }

    method materiasEnLaQueSePuedeInscribir(estudiante) {
      return materias.filter({materia => materia.puedeInscribirA(estudiante)})
    }
}

class Materia {
  const carrera //indica la carrera a la que pertenece la materia
  const estudiantes 
  const capacidadMaxCupos
  var requisitos 
  var property anio
  var property creditos
  var property creditosNecesarios
  const estudiantesEnEspera = []

  method requisitos(_requisitos) {
    requisitos =_requisitos
  }

  method materia() {
    return self
  }

  method estudiantes() {
    return estudiantes
  }

  method puedeInscribirA(estudiante) {
    return self.materiaEstaEnAlgunaCarreraDe(estudiante)     &&
           not self.estudianteTieneAprobadaM(estudiante)     &&
           not self.tieneInscriptoA(estudiante)              &&
           self.puedeCumplirRequisito(estudiante)
  }

  method puedeCumplirRequisito(estudiante) {
    return requisitos.cumpleRequisitos(carrera,estudiante,self)
  }

  method materiaEstaEnAlgunaCarreraDe(estudiante) {
    return estudiante.estaInscriptoAlaMateria(self)
  }

  method estudianteTieneAprobadaM(estudiante) {
    return estudiante.estaAprobada(self)
  }

  method tieneInscriptoA(estudiante) {
    return estudiantes.contains(estudiante)
  }

  method inscribirEstudianteAM(estudiante) {
    self.validarSiPúedeInscribirseAM(estudiante)
    if(self.tieneCupo()) {
      self.inscribirEstudiante(estudiante)
    } else {
      self.agregarAListaEspera(estudiante)
    }
  }

  method darDebaja(estudiante) {
    estudiantes.remove(estudiante)
    estudiantes.add(self.estudiantesEnEspera().head())
    estudiantesEnEspera.remove(self.estudiantesEnEspera().head())
  }

  method estudiantesEnEspera() {
    return estudiantesEnEspera
  }

  method agregarAListaEspera(estudiante) {
    estudiantesEnEspera.add(estudiante)
  }

  method tieneCupo() {
    return estudiantes.size() < capacidadMaxCupos
  }

  method validarSiPúedeInscribirseAM(estudiante) {
    if(not self.puedeInscribirA(estudiante)) {
      self.error("no puede inscribirse a la materia")
    }
  }

  method inscribirEstudiante(estudiante) {
    estudiantes.add(estudiante)
  }

  method anio() {
    return anio
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
    self.validarSiTieneMateriasAprobadas(carrera)
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

  method validarSiTieneMateriasAprobadas(carrera) {
    if(self.materiasAprobadasEn(carrera).isEmpty()){
      self.error("no tiene materias aprobadas")
    }
  }

  method promedioEnTodasLasCarreras() {
    self.validarSiTieneMateriasAprobadasEnTodasLasCarreras()
    return self.notasTotalEnTodasLasCarreras() / self.materiasAprobadasEnTodasLasCarreras().size()
  }

  method notasTotalEnTodasLasCarreras() {
    return self.materiasAprobadasEnTodasLasCarreras().sum({materia => materia.nota()})
  }

  method materiasAprobadasEnTodasLasCarreras() {
    return cursadas.filter({materiaAprobada => materiaAprobada.nota().between(6, 10)})
  }

  method validarSiTieneMateriasAprobadasEnTodasLasCarreras() {
    if(self.materiasAprobadasEnTodasLasCarreras().isEmpty()){
      self.error("no tiene materias aprobadas")
    }
  }

  method cursadasDeMateria(materia) {
    return cursadas.filter({cursada => cursada.materia() == materia})
  }
}

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

