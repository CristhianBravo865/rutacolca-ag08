workspace "RutaColca" "Modelo C4 de RutaColca - Grupo N.º __" {

    !identifiers hierarchical
    !impliedRelationships true

    model {
        // ---------- PASO 2 · Personas ----------
        turista = person "Turista" "Visitante que busca tours del valle del Colca, reserva una salida y paga en línea."
        operador = person "Operador de agencia" "Personal de una agencia de Arequipa o Chivay que publica tours, fechas y cupos."
        guia = person "Guía de turismo" "Conduce la salida; recibe el itinerario y la lista del grupo por WhatsApp."
        admin = person "Administrador" "Aprueba a las agencias que se registran y revisa las ventas por agencia y por mes."

        // ---------- PASO 2 y 3 · Sistema en estudio y contenedores ----------
        ruta = softwareSystem "RutaColca" "Plataforma del consorcio para publicar, reservar y pagar tours al valle del Colca." {
            web = container "Web del turista" "Búsqueda de tours, reserva y pago." "React (SPA)"
            portal = container "Portal de agencias" "Publicación de tours y salidas, reservas presenciales, aprobación y reportes." "React (PWA)"
            api = container "API" "Reglas de negocio: tours, reservas, validación de boleto, cobro y avisos." "Java 21, Spring Boot"
            db = container "Base de datos" "Tours, salidas, cupos, reservas y agencias. No guarda datos de tarjetas." "PostgreSQL 16" "Almacen"

            // ---------- PASO 8 · Reto sin conexión (HU-05) ----------
            // SUPUESTO del grupo: almacén local dentro de la PWA. Ajústenlo con su ADR-002.
            offline = container "Almacén local de reservas" "Guarda reservas presenciales pendientes cuando no hay internet." "IndexedDB (navegador, PWA)" "Almacen"
        }

        // ---------- PASO 2 · Sistemas externos ----------
        pasarela = softwareSystem "Pasarela de pagos" "Sistema externo que procesa pagos con tarjeta y billetera móvil." "Externo"
        whatsapp = softwareSystem "WhatsApp Business" "Sistema externo de mensajería para enviar itinerarios y listas de grupo a los guías." "Externo"
        autocolca = softwareSystem "Sistema de AUTOCOLCA" "Sistema externo que emite y valida el boleto turístico del Colca (supuesto didáctico, API HTTPS)." "Externo"

        // ---------- Relaciones (origen -> destino "Verbo + preposición" "Protocolo") ----------
        turista -> ruta.web "Reserva y paga tours en" "HTTPS"
        operador -> ruta.portal "Publica tours y registra reservas en" "HTTPS"
        admin -> ruta.portal "Aprueba agencias y consulta ventas en" "HTTPS"

        ruta.web -> ruta.api "Envía reservas y pagos a" "JSON/HTTPS"
        ruta.portal -> ruta.api "Envía tours y reservas a" "JSON/HTTPS"
        ruta.api -> ruta.db "Lee y escribe datos en" "JDBC"
        ruta.api -> pasarela "Cobra las reservas en" "HTTPS"
        ruta.api -> autocolca "Valida boletos turísticos en" "HTTPS"
        ruta.api -> whatsapp "Envía itinerarios por" "HTTPS"
        whatsapp -> guia "Entrega el itinerario y la lista del grupo a" "WhatsApp"

        // Reto sin conexión
        ruta.portal -> ruta.offline "Guarda reservas pendientes en" "IndexedDB"
        ruta.portal -> ruta.api "Sincroniza reservas pendientes con" "JSON/HTTPS"

        // ---------- PASO 7 · Despliegue en producción ----------
        produccion = deploymentEnvironment "Produccion" {
            celular = deploymentNode "Celular del turista" "" "Android / iOS" {
                navegador = deploymentNode "Navegador web" "" "Chrome / Safari" {
                    webInst = containerInstance ruta.web
                }
            }
            tablet = deploymentNode "Tablet de la agencia" "" "Android / iPadOS" {
                navegador = deploymentNode "Navegador web" "" "Chrome" {
                    portalInst = containerInstance ruta.portal
                    offlineInst = containerInstance ruta.offline
                }
            }
            cloud = deploymentNode "Proveedor cloud" "" "Cloud + Docker" {
                lb = infrastructureNode "Balanceador de carga" "Termina TLS y reparte el tráfico entre las VM." "Balanceador gestionado"
                vm = deploymentNode "VM Ubuntu 24.04 (x2)" "Réplicas de la API para temporada alta." "Ubuntu 24.04, Docker" 2 {
                    apiInst = containerInstance ruta.api
                }
                bd = deploymentNode "BD gestionada" "" "PostgreSQL 16 gestionado" {
                    dbInst = containerInstance ruta.db
                }
            }
        }

        // Relaciones entre nodos: fuera del bloque del entorno
        produccion.cloud.lb -> produccion.cloud.vm.apiInst "Reenvía las peticiones a" "HTTPS"
    }

    views {
        systemContext ruta "Contexto" {
            title "Diagrama de contexto de RutaColca"
            description "RutaColca como una sola caja, con sus usuarios y sistemas externos."
            include *
            include guia
            exclude ruta.offline
            autolayout lr
        }

        container ruta "Contenedores" {
            title "Diagrama de contenedores de RutaColca"
            description "Aplicaciones y almacenes de datos del ADR-001."
            include *
            include guia
            exclude ruta.offline
            autolayout tb
        }

        container ruta "ContenedoresReto" {
            title "Diagrama de contenedores de RutaColca - Reto sin conexión (HU-05)"
            description "Incluye el almacén local para registrar reservas sin internet."
            include *
            include guia
            autolayout tb
        }

        // ---------- PASO 4 · Dinámico (validar el boleto ANTES de cobrar) ----------
        dynamic ruta "Dinamico" "Reservar y pagar un tour" {
            title "Diagrama dinámico de RutaColca - Reservar y pagar un tour (HU-02, HU-03)"
            turista -> ruta.web "Elige la salida, registra su boleto y paga"
            ruta.web -> ruta.api "Envía la reserva y el pago a"
            ruta.api -> autocolca "Valida el boleto turístico en"
            ruta.api -> pasarela "Cobra la reserva en"
            ruta.api -> ruta.db "Guarda la reserva confirmada en"
            ruta.api -> whatsapp "Envía el itinerario por"
            autolayout lr
        }

        deployment ruta "Produccion" "Despliegue" {
            title "Diagrama de despliegue de RutaColca - Producción"
            description "Dónde corre cada contenedor y con qué infraestructura."
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
            element "Almacen" {
                shape Cylinder
            }
            element "Externo" {
                background #8C8C8C
                color #ffffff
            }
        }
    }
}
