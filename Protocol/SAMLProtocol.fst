module Protocol

type prin = string
type pubkey :: prin => *
type privkey :: prin => *
type dsig
type resource = bytes
type uri = string
type nonce

val keygen:  p:prin
          -> (pubkey p * privkey p)

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
  | ChallengeMessage: nonce -> message
  | Resource: uri -> message
  | Failed: int -> message

(*Verification*)
type Log :: prin => samlmessage => E

val sign:  p:prin
        -> privkey p
        -> msg:samlmessage{Log p msg}
        -> dsig

val verify: p:prin
        -> pubkey p 
        -> msg:samlmessage
        -> dsig
        -> b:bool{b=true ==> Log p msg}

val send: prin -> message -> unit
val recieve: prin -> message 

val createAuthnRequest: sp:prin -> idp:prin -> samlmessage
val createChallenge: prin -> nonce
val createSamlResponse: prin -> prin -> SamlStatus -> samlmessage

val fork: list (unit -> unit) -> unit
