module Protocol

open Network

type assertiontoken = string
type id = string


type Assertion =
  | UnsignedAssertion: assertiontoken -> 

type SamlMessage =
  | Login: uri -> SamlMessage
  | AuthnRequest: prin -> samlmessage -> dsig -> SamlMessage
  | ResponseMessage: uri -> SamlMessage
  | LoginResponse: int -> SamlMessage
  | Failed: int -> SamlMessage

type SamlStatus =
  | Success: SamlStatus
  | Requester: SamlStatus
  | Responder: SamlStatus

(*Verification*)
type Log :: prin => samlmessage => E
type Log2 :: string => string => nonce => E

val SendSaml: prin -> SamlMessage -> unit
val RecieveSaml: prin -> SamlMessage 

val IssuerAssertion: issuer:prin -> subject:prin -> audience:prin -> inresto:id -> assertiontoken
