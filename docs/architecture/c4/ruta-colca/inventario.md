# Inventario C4 — RutaColca

| Elemento | Tipo C4 | Justificación |
|---|---|---|
| Turista | Persona | Consulta, reserva y paga tours. |
| Operador de agencia | Persona | Publica tours y administra reservas. |
| Guía de turismo | Persona | Recibe información por WhatsApp, aunque no ingresa directamente. |
| Administrador | Persona | Aprueba agencias y consulta ventas. |
| RutaColca | Sistema de software propio | Es la plataforma que se está modelando. |
| Pasarela de pagos | Sistema externo | Procesa cobros sin almacenar tarjetas en RutaColca. |
| WhatsApp Business | Sistema externo | Entrega comunicaciones a los guías. |
| Sistema de AUTOCOLCA | Sistema externo | Valida boletos mediante API HTTPS supuesta para el ejercicio. |
| Web del turista | Contenedor (aplicación) | SPA React para el turista. |
| Portal de agencias | Contenedor (aplicación) | PWA React para operadores y administradores. |
| API | Contenedor (aplicación) | Backend Java 21 Spring Boot. |
| Base de datos | Contenedor (almacén de datos) | PostgreSQL 16. |
| Almacén local de reservas | Contenedor (almacén de datos, reto) | IndexedDB en la tablet para trabajo sin conexión. |

**Decisión:** el guía aparece como persona porque recibe el resultado del sistema a través de WhatsApp, sin utilizar directamente la plataforma.
