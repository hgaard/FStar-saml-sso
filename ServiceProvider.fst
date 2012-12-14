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
	let (authnReq, sigSP)  = createAuthnRequest me idp in 
  	let authnReqest = SamlProtocolMessage idp authnReq sigSP "relay" in 
  	send client authnReqest; (*2*)
  	let authResponse = recieve client in (*7*)
  	match authResponse with
  	| SamlProtocolMessage (sp, message, sigIDP, relay) -> 
  		let resource = Resource uri in
  		send client resource	(*8*)
  	| _ ->  ()
  | _ -> ()

  ()

end (* Serviceprovider *)