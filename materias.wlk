class Estudiante {
    const materiasAprobadas = #{}
    const carrerasInscriptas = #{}
    const historialDeMaterias = []

    method inscribirAlaCarraera(carrera) {
      self.validarSiPuedeInscribirseAlaCarrera(carrera)
      self.agregarCarrera(carrera)
    }

    method agregarCarrera(carrera) {
      carrerasInscriptas.add(carrera)
    }

    method agregarMateria(materia) {
      historialDeMaterias.add(materia)
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

    method materiasAprobadas() {
      return materiasAprobadas
    }

    method registrarMateria(registrarMateria,registrarNota) {
      self.agregarAHistorialMaterias(registrarMateria,registrarNota)
      self.agregarMateriaSiEstaAprobada(registrarMateria,registrarNota)
    }

    method agregarAHistorialMaterias(registrarMateria,registrarNota) {
      self.validarSiEstaInscriptoAMateria(registrarMateria)
      self.validarSiEsNotaValida(registrarNota)
      self.agregarMateria(new MateriaYNota(materia = registrarMateria, nota = registrarNota))
    }

    method agregarMateriaSiEstaAprobada(registrarMateria,registrarNota) {
      self.validarSiEsMateriaAprobada(registrarMateria,registrarNota)
      if(registrarNota.between(6, 10)){
        materiasAprobadas.add(new MateriaYNota(materia = registrarMateria, nota = registrarNota))
      }
    }

    method validarSiEstaInscriptoAMateria(materia) {
    if (!self.estaInscriptoAlaMateria(materia)) {
      self.error("no esta inscripto a la materia" + materia)
    }
  }

  method validarSiEsMateriaAprobada(materia,nota) {
    if (self.estaAprobada(materia)) {
      self.error("la materia ya esta aprobada")
    }
  }

  method validarSiEsNotaValida(nota) {
    if(!nota.between(1, 10)) {
      self.error("la nota es invalida")
    }
  }

  method laNotaEsValida(nota) {
    return nota.between(1, 10)
  }

  method estaAprobada(materia) {
    return materiasAprobadas.any({ materiaAprobada =>
      materiaAprobada.materia() == materia && materiaAprobada.nota().between(6, 10)
    })
  }

  method promedioEn(carrera) {
    self.validarSiEstaInscriptoA(carrera)
    self.validarSiTieneMateriasAprobadasEn(carrera)
    return self.notaDeMateriasEn(carrera) / self.cantidadMateriasAprobadas(carrera)
  }

  method validarSiEstaInscriptoA(carrera) {
    if(!self.estaInscriptoA(carrera)){
      self.error("no esta inscripto a la carrera")
    }
  }

  method notaDeMateriasEn(carrera) {
    return self.materiasAprobadasEn(carrera).sum({materiaAprobada => materiaAprobada.nota()})
  }

  method materiasAprobadasEn(carrera) {
    return materiasAprobadas.filter({materiaAprobada => carrera.tieneMateria(materiaAprobada.materia())})
  }

  method cantidadMateriasAprobadas(carrera) {
    return self.materiasAprobadasEn(carrera).size()
  }

  method validarSiTieneMateriasAprobadasEn(carrera) {
    if(self.cantidadMateriasAprobadas(carrera) == 0){
      self.error("no tiene materias aprobadas")
    }
  }

  method promedioEnTodasLasCarreras() {
    self.validarSiTieneMateriasAprobadas()
    const notas = materiasAprobadas.sum({materiaAprobada => materiaAprobada.nota()})
    return notas / materiasAprobadas.size()
  }

  method validarSiTieneMateriasAprobadas() {
    if(materiasAprobadas.isEmpty()){
      self.error("no tiene materias aprobadas")
    }
  }

  method cursadasDeMateria(materia) {
    return historialDeMaterias.filter({cursada => cursada.materia() == materia})
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
}

class Materia {
  const materia 

  method materia() {
    return materia
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


