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

type SamlStatus =
	| Success: SamlStatus
	| Requester: SamlStatus
	| Responder: SamlStatus

type message =
  | HttpGet: uri -> message
  | SamlProtocolMessage: prin -> samlmessage -> dsig -> string -> message
  | Credentials: string -> string -> nonce -> message
  | Challenge: nonce -> message
  | Resource: uri -> message
  | Failed: int -> message

val send: prin -> message -> unit
val recieve: prin -> message 

val CreateAuthnRequest: prin -> prin -> (samlmessage * dsig)
val CreateChallenge: prin -> nonce
val CreateSamlResponse: prin -> prin -> SamlStatus -> (samlmessage * dsig)

(*Verification*)
type Log :: prin => string => E

end (*Protocol*)