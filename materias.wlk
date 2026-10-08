class Estudiante {
    const materiasAprobadas = #{}
    const carrerasInscriptas = #{}
    const historialMaterias = []

    method inscribirAlaCarraera(carrera) {
      self.validarSiPuedeInscribirseAlaCarrera(carrera)
      self.agregarCarrera(carrera)
    }

    method agregarCarrera(carrera) {
      carrerasInscriptas.add(carrera)
    }

    method agregarMateria(materia) {
      historialMaterias.add(materia)
    }

    method validarSiPuedeInscribirseAlaCarrera(carrera) {
      if(carrerasInscriptas.contains(carrera)) {
        self.error("ya esta inscripto a esta carrera")
      }
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

    method registrarMateriaConNota(materia, nota) {
    self.validarSiEsMateriaAprobada(materia,nota)
    materiasAprobadas.add(new MateriaYNota(materia = materia, nota = nota))
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

  method notasDeMateriasAprobadasDe(carrera) {
    return self.materiasDeCarrera(carrera).sum({materiaAprobada => materiaAprobada.nota()})
  }

  method promedioMateriasEn(carrera) {
    return self.notasDeMateriasAprobadasDe(carrera) / self.materiasDeCarrera(carrera).size()
  }

  method materiasDeCarrera(carrera) {
    return materiasAprobadas.filter({materiaAprobada => carrera.tieneMateria(materiaAprobada.materia())}).map({materiaAprobada => materiaAprobada.materia()})
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


