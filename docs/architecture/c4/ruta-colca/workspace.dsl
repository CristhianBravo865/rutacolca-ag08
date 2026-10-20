workspace "RutaColca" "Modelo C4 de RutaColca - Grupo N.º __" {

    !identifiers hierarchical

    model {
        turista = person "Turista" "Busca, reserva y paga tours."
        operador = person "Operador de agencia" "Publica tours y administra salidas y reservas."
        guia = person "Guía de turismo" "Recibe itinerarios y listas por WhatsApp."
        administrador = person "Administrador" "Aprueba agencias y revisa ventas."
        ruta = softwareSystem "RutaColca" "Plataforma de publicación, reservas y pagos de tours del Colca." {
        }
        pagos = softwareSystem "Pasarela de pagos" "Procesa cobros con tarjeta o billetera móvil." "Externo"
        whatsapp = softwareSystem "WhatsApp Business" "Entrega mensajes a los guías." "Externo"
        autocolca = softwareSystem "Sistema de AUTOCOLCA" "Valida boletos turísticos mediante API HTTPS (supuesto didáctico)." "Externo"

        turista -> ruta "Consulta tours y solicita reservas en"
        operador -> ruta "Publica tours y registra reservas en"
        administrador -> ruta "Aprueba agencias y consulta reportes en"
        ruta -> guia "Comunica itinerarios y listas de grupo a"
        ruta -> pagos "Solicita cobros a"
        ruta -> autocolca "Solicita validación de boletos a"
        ruta -> whatsapp "Envía itinerarios y listas mediante"
        whatsapp -> guia "Entrega itinerarios y listas a"
    }

    views {
        systemContext ruta "Contexto" "Diagrama de contexto de RutaColca" {
            include *
            autolayout lr
        }

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
