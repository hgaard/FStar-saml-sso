module Protocol

(*TODO: 
- Gør beskrder endnu mere generelle
- Så de afspejler http og model bedre 
*)
type prin
type dsig
type resource
type uri
type nonce

type samlmessage =
  | AuthnRequest: samlmessage
  | Response: samlmessage

type message =
  | HttpGet: uri -> message
  | SamlProtocolMessage: prin -> samlmessage -> dsig -> string -> message
  | Credentials: string -> string -> nonce -> message
  | Challenge: nonce -> message
  | Resource: uri -> message
  | Failed: message

val send: prin -> message -> unit
val recieve: prin -> message 

val createAuthnRequest: prin -> prin -> (samlmessage * dsig)
val createChallenge: prin -> nonce
val createSamlResponse: prin -> prin -> (samlmessage * dsig)

end (*Protocol*)