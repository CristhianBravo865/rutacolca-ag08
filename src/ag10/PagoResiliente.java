import java.util.HashMap;
import java.util.Map;

/** POC autocontenida; no representa la API real de pagos de RutaColca. */
public final class PagoResiliente {
    public enum Estado { PENDIENTE, INCIERTO, CONFIRMADO, RECHAZADO }

    public static final class Reserva {
        public final String id;
        public final String clave;
        public Estado estado = Estado.PENDIENTE;
        public long confirmadaEnMinuto = -1;
        public Reserva(String id, String clave) {
            this.id = id;
            this.clave = clave;
        }
    }

    public interface PasarelaPago {
        boolean estaDisponible();
        boolean estaPagado(String clave);
        void cobrar(String clave);
    }

    public static final class PasarelaFalsa implements PasarelaPago {
        public boolean disponible = true;
        public boolean perderRespuestaDespuesDeCobrar = false;
        public int cobrosEfectivos = 0;
        private final Map<String, Boolean> pagos = new HashMap<>();

        @Override public boolean estaDisponible() { return disponible; }

        @Override public boolean estaPagado(String clave) {
            if (!disponible) throw new IllegalStateException("pasarela caida");
            return pagos.containsKey(clave);
        }

        @Override public void cobrar(String clave) {
            if (!disponible) throw new IllegalStateException("pasarela caida");
            if (!pagos.containsKey(clave)) {
                pagos.put(clave, true);
                cobrosEfectivos++;
            }
            if (perderRespuestaDespuesDeCobrar) {
                perderRespuestaDespuesDeCobrar = false;
                throw new IllegalStateException("respuesta perdida tras cobro");
            }
        }
    }

    public static final class ConciliadorPagos {
        private final PasarelaPago pasarela;
        private final Map<String, Reserva> reservas = new HashMap<>();
        private long minuto;

        public ConciliadorPagos(PasarelaPago pasarela) { this.pasarela = pasarela; }
        public void avanzarMinutos(long n) { minuto += n; }
        public long minutoActual() { return minuto; }

        public Reserva registrar(String id, String clave) {
            if (reservas.containsKey(id)) throw new IllegalArgumentException("ID duplicado");
            if (reservas.values().stream().anyMatch(r -> r.clave.equals(clave))) {
                throw new IllegalArgumentException("clave idempotente duplicada");
            }
            Reserva r = new Reserva(id, clave);
            reservas.put(id, r);
            return r;
        }

        public void reconciliar() {
            for (Reserva reserva : reservas.values()) {
                if (reserva.estado == Estado.CONFIRMADO || reserva.estado == Estado.RECHAZADO) continue;
                if (!pasarela.estaDisponible()) {
                    reserva.estado = Estado.INCIERTO;
                    continue;
                }
                try {
                    // Consultar SIEMPRE antes de un nuevo intento de cobro.
                    if (!pasarela.estaPagado(reserva.clave)) pasarela.cobrar(reserva.clave);
                    // Si el proveedor devolvio una respuesta incierta, el estado se consulta nuevamente.
                    if (pasarela.estaPagado(reserva.clave)) {
                        reserva.estado = Estado.CONFIRMADO;
                        reserva.confirmadaEnMinuto = minuto;
                    }
                } catch (IllegalStateException ex) {
                    reserva.estado = Estado.INCIERTO;
                }
            }
        }

        public Reserva obtener(String id) { return reservas.get(id); }
    }
}
