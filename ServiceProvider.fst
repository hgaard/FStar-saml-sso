module SERVICEPROVIDER
open PROTOCOL

(*
- Protocol events
- Add assumtions
- Add asserts
*)

val serviceprovider: me:prin -> client:prin -> idp:prin -> unit 
let serviceprovider me client idp = 
  let reqUri = recieveHttpRequest client in (*1*)
    let (authnReq, sigSP)  = createAuthnRequest me idp in 
      sendAuthnRequest client authnReq sigSP "relay"; (*2*)
      let (sp, samlResponse, sigIDP, relay) = recievehttpRedirect client in (*7*)
        sendResource client; (*8*)
        ()

end (* SERVICEPROVIDER *)