workspace "RutaColca" "Modelo C4 de RutaColca - Grupo N.º __" {

    !identifiers hierarchical

    model {
        // PASO 2 · Personas: un rol humano por elemento
        turista = person "Turista" "TODO: describa al usuario en una oración."
        // TODO: operador de agencia, guía de turismo, administrador

        // PASO 2 · El sistema en estudio (una sola caja en el contexto)
        ruta = softwareSystem "RutaColca" "TODO: qué ofrece al negocio." {
            // PASO 3 · Contenedores: aplicaciones y almacenes de datos
            // nombre = container "Nombre" "Responsabilidad" "Tecnología"
            // TODO: web del turista, portal de agencias, API, base de datos
        }

        // PASO 2 · Sistemas externos (etiqueta "Externo")
        // TODO: pasarela de pagos, WhatsApp Business, sistema de AUTOCOLCA

        // Relaciones: origen -> destino "Verbo + preposición" "Protocolo"
        // TODO: complete las relaciones de los pasos 2 y 3

        // PASO 7 (Parte B) · deploymentEnvironment "Produccion" { ... }
    }

    views {
        systemContext ruta "Contexto" "Diagrama de contexto de RutaColca" {
            include *
            autolayout lr
        }

        container ruta "Contenedores" "Diagrama de contenedores de RutaColca" {
            include *
            autolayout tb
        }

        // PASO 4 · dynamic ruta "Dinamico" "Reservar y pagar un tour" { ... }

        // PASO 7 (Parte B) · deployment ruta "Produccion" "Despliegue" "Despliegue en producción de RutaColca" { ... }

        // PASO 8 (Parte B) · container ruta "ContenedoresReto" "Contenedores con trabajo sin conexión" { ... }

        styles {
            element "Person" {
                shape Person
                background #0B3D62
                color #ffffff
            }
            element "Software System" {
                background #1B5E8B
                color #ffffff
            }
            element "Container" {
                background #0E7D73
                color #ffffff
            }
            element "Externo" {
                background #8C8C8C
                color #ffffff
            }
        }
    }
}
