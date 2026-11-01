public final class PagoResilienteTest {
    private static void comprobar(boolean condicion, String mensaje) {
        if (!condicion) throw new AssertionError(mensaje);
    }

    public static void main(String[] args) {
        var pasarela = new PagoResiliente.PasarelaFalsa();
        var servicio = new PagoResiliente.ConciliadorPagos(pasarela);

        // Caso 1: la pasarela cae 15 minutos: no se pierde la reserva.
        var r1 = servicio.registrar("R-001", "clave-r001");
        pasarela.disponible = false;
        servicio.reconciliar();
        servicio.avanzarMinutos(15);
        comprobar(r1.estado == PagoResiliente.Estado.INCIERTO,
                "Durante la caida, la reserva debe ser incierta");
        comprobar(pasarela.cobrosEfectivos == 0, "No se cobra durante la caida");

        // Caso 2: recuperada la pasarela, se confirma en menos de 30 minutos.
        long recuperacion = servicio.minutoActual();
        pasarela.disponible = true;
        servicio.avanzarMinutos(5);
        servicio.reconciliar();
        comprobar(r1.estado == PagoResiliente.Estado.CONFIRMADO,
                "Pago confirmado tras recuperacion");
        comprobar(r1.confirmadaEnMinuto - recuperacion <= 30,
                "Se excedio el limite de 30 minutos");
        servicio.reconciliar();
        comprobar(pasarela.cobrosEfectivos == 1, "No debe repetirse el cobro");

        // Caso 3: hubo cobro real, pero se perdio la respuesta HTTP.
        var r2 = servicio.registrar("R-002", "clave-r002");
        pasarela.perderRespuestaDespuesDeCobrar = true;
        servicio.reconciliar();
        comprobar(r2.estado == PagoResiliente.Estado.INCIERTO,
                "Respuesta perdida debe quedar INCIERTO");
        comprobar(pasarela.cobrosEfectivos == 2, "Se cobro exactamente una vez");
        servicio.reconciliar();
        comprobar(r2.estado == PagoResiliente.Estado.CONFIRMADO,
                "Reconsulta confirma el pago previamente realizado");
        comprobar(pasarela.cobrosEfectivos == 2, "La reconsulta no duplica el cobro");
        comprobar(servicio.obtener("R-001") == r1, "Reserva original conservada");

        System.out.println("OK - 3 escenarios: caida, recuperacion e idempotencia");
    }
}
