module Serviceprovider
open Protocol

(*
- Protocol events
- Add assumtions
- Add asserts
- Fork
*)

val serviceprovider: me:prin -> client:prin -> idp:prin -> pubkey idp -> unit 
let serviceprovider me client idp pubkidp = 
    (* Generate keypair *)
  let pubk, privk = keygen me in

    let reqRes = recieve client in (*1*)
  match reqRes with
  | HttpGet (uri) -> 
  
    let authnReq = createAuthnRequest me idp in 
    assume(Log me authnReq) (*Protocol event*);
    let sigSP = sign me privk authnReq in
      
    let authnReqest = SamlProtocolMessage idp authnReq sigSP uri in 
    send client authnReqest; (*2*)  
    let authResponse = recieve client in (*7*)
    match authResponse with
    | SamlProtocolMessage (sp, message, sigIDP, relay) -> 
      (if verify idp pubkidp message sigIDP
      then
        ((*assert(Log idp message);*)
          let resource = Resource uri in
          send client resource)  (*8*)
      else ())
    | _ ->  send client (Failed (403))(*8.1*)     
  
  | _ -> send client (Failed (400))(*2.1*)

end (* Serviceprovider *)