module Serviceprovider
open Protocol

(*
- Protocol events
- Add assumtions
- Add asserts
*)

val serviceprovider: me:prin -> client:prin -> idp:prin -> unit 
let serviceprovider me client idp = 
  let reqRes = recieve client in (*1*)
  match reqRes with
  | HttpGet (uri) -> 
    let (authnReq, sigSP)  = CreateAuthnRequest me idp in 
    assume(Log idp authnReq);
  	let authnReqest = SamlProtocolMessage idp authnReq sigSP "relay" in 
  	send client authnReqest; (*2*)
  	let authResponse = recieve client in (*7*)
  	match authResponse with
  	| SamlProtocolMessage (sp, message, sigIDP, relay) -> 
  		let resource = Resource uri in
  		send client resource	(*8*)
  	| _ ->  send client (Failed (403))(*8.1*)     
  | _ -> send client (Failed (400))(*2.1*)
  

end (* Serviceprovider *)