module CRYPTO
type prin = string
type pubkey :: prin => *
type privkey :: prin => *
type dsig 

val keygen:  p:prin
          -> (pubkey p * privkey p)

type Says :: prin => bytes => E
val sign:  p:prin
        -> privkey p
        -> msg:bytes{Says p msg}
        -> dsig

val verify: p:prin
        -> pubkey p 
        -> msg:bytes
        -> dsig
        -> b:bool{b=true ==> Says p msg}

end(* crypto *)

module UTIL
open CRYPTO
val string2bytes: string -> bytes
val send: prin -> (bytes * dsig) -> unit
val recv: prin -> (bytes * dsig)
val fork: list (unit -> unit) -> unit

end(* util *)

module CLIENT
open CRYPTO
open UTIL
val client: me:prin -> pubkey me -> privkey me 
         -> server:prin -> pubkey server -> unit
let client me mypk mysk server serverpk = 
   let req = string2bytes "Hi server" in assume (Says me req); (* protocol event *)
   let dsig = sign me mysk req in send server (req, dsig);
   let (resp, dsig') = recv server in 
    if verify server serverpk resp dsig'
    then (assert (Says server resp); ())
    else ()

end(* client *)

module SERVER
open CRYPTO
open UTIL
open CLIENT
val server: me:prin -> pubkey me -> privkey me 
         -> client:prin -> pubkey client
         -> unit
let server me mypk mysk client clientpk = 
   let (req, dsig) = recv client in 
   if verify client clientpk req dsig
   then 
     (assert (Says client req);
      let resp = string2bytes "Ack" in 
      assume (Says me resp);
      let dsig = sign me mysk resp in 
      send client (resp, dsig))
   else ()

end(* server *)

module CRYPTOMAIN
open CRYPTO
open UTIL
open CLIENT
open SERVER
let main attacker =
  let cpk, csk = keygen "client" in 
  let spk, ssk = keygen "server" in 
  fork [attacker;
        (fun () -> client "client" cpk csk "server" spk);
        (fun () -> server "server" spk ssk "client" cpk)]
