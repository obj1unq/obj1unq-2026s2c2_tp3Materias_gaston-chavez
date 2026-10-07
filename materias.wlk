class Estudiante {
    const materiasAprobadas = #{}
    const carrerasInscriptas = #{}

    method inscribirAlaCarraera(carrera) {
      self.validarSiPuedeInscribirseAlaCarrera(carrera)
      self.agregarCarrera(carrera)
    }

    method agregarCarrera(carrera) {
      carrerasInscriptas.add(carrera)
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

