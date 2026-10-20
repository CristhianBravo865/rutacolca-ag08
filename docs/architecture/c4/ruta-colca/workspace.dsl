workspace "RutaColca" "Modelo C4 de RutaColca - Grupo N.º __" {

    !identifiers hierarchical

    model {
        turista = person "Turista" "Busca, reserva y paga tours."
        operador = person "Operador de agencia" "Publica tours y administra salidas y reservas."
        guia = person "Guía de turismo" "Recibe itinerarios y listas por WhatsApp."
        administrador = person "Administrador" "Aprueba agencias y revisa ventas."
        ruta = softwareSystem "RutaColca" "Plataforma de publicación, reservas y pagos de tours del Colca." {
            web = container "Web del turista" "Permite buscar, reservar y pagar tours." "React SPA"
            portal = container "Portal de agencias" "Permite publicar tours, registrar reservas y gestionar agencias." "React PWA"
            api = container "API de negocio" "Gestiona tours, cupos, boletos, pagos, reservas y reportes." "Java 21 / Spring Boot"
            bd = container "Base de datos" "Almacena agencias, tours, salidas, reservas y pagos." "PostgreSQL 16"
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

        turista -> ruta.web "Busca salidas y solicita reservas en" "HTTPS"
        operador -> ruta.portal "Gestiona tours y reservas en" "HTTPS"
        administrador -> ruta.portal "Aprueba agencias y consulta ventas en" "HTTPS"
        ruta.web -> ruta.api "Consulta tours y solicita reservas a" "JSON/HTTPS"
        ruta.portal -> ruta.api "Publica tours y sincroniza reservas con" "JSON/HTTPS"
        ruta.api -> ruta.bd "Consulta y registra tours, cupos y reservas en" "JDBC"
        ruta.api -> autocolca "Valida el número de boleto en" "JSON/HTTPS"
        ruta.api -> pagos "Solicita el cobro de la reserva a" "HTTPS"
        ruta.api -> whatsapp "Envía itinerarios y listas de grupo mediante" "HTTPS"
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
        dynamic ruta "Dinamico" "Reservar y pagar un tour" {
            turista -> ruta.web "Selecciona salida e ingresa boleto"
            ruta.web -> ruta.api "Solicita reserva con boleto"
            ruta.api -> autocolca "Valida boleto turístico"
            ruta.api -> pagos "Solicita cobro tras validación"
            ruta.api -> ruta.bd "Registra reserva y actualiza cupos tras pago exitoso"
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
