class Pasajero{
    constructor(dni,ayn){
      this.dni = dni;
      this.ayn = ayn;
    }
    getDNI(){
        return this.dni;
    }
    getNyA(){
        return this.ayn;
    }
    getTodasReservas(){
        return "trae la lista";
    }
    reservar(){
        return "agrego la reserva"; /**falta rey*/
    }
     
  }
class Empresa{
    constructor(){
    }
    addViaje(){
        return "agregamos viaje";
    }
    addPasajero(){
        return "agregamos pasajero";
    }
    addParada(){
        return "agregamso parada";
    }
    addVendedor(){
        return "agrego vendedor"; /**falta rey*/
    }
     
  }
class Viaje{
    constructor(fs,fl,pb){
        this.fs= fs;
        this.fl=fl;
        this.pb=pb;
    }
    getDuracion(){
        return this.fl-this.fs;
    }
    getOrigen(){
        return this.ayn;
    }
    getDestino(){
        return "trae la lista";
    }
    getAsientosDisp(){
        return "agrego la reserva"; /**falta rey*/
    }
     
  }
class Parada{
    constructor(n,d,l,p){
        this.n=n;
        this.d=d;
        this.l=l;
        this.p=p;
    }
    getNomYDir(){
        return this.n,this.d,this,l,this,p;
    }
}
class Asiento{
    constructor(nro,estado){
        this.nro=nro;
        this.estado=estado;
    }
    getEstado(){
        return "estado del asiento";
    }
}
class Reserva{
    constructor(fechareserva,fechaconfirm,fechacancel,nropasaje,montoabon,estado){
        this.fechacancel=fechacancel;
        this.fechaconfirm=fechaconfirm;
        this.fechareserva=fechareserva;
        this.nropasaje=nropasaje;
        this.montoabon=montoabon;
        this.estado=estado;
    }
    getEstado(){
        return "estado reserva";
    }
}
class Vendedor{
    getReservasRealizadas(){
        return "listado de reservas de este vendedor"
    }
}
class VendedorTerminal extends Vendedor{
    constructor(nrovent,nya){
        this.nrovent=nrovent;
        this.nya=nya;
    }
}
class AgenciaViaje extends Vendedor{
    constructor(cuit,nom){
        this.cuit=cuit;
        this.nom=nom;
    }
}

const pass = new Pasajero(12345678, "nombre", );
console.log(pass.dni, pass.ayn, pass.getDNI());
  
  