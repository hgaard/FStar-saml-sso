module PROTOCOL

type prin
type dsig
type resource
type uri
type nonce

type samlmessage =
  | AuthnRequest: samlmessage
  | Response: samlmessage

type request =
  | HttpGet: uri -> request
  | SamlAuthnRequest: uri -> prin -> samlmessage -> dsig -> string -> request
  | AuthenticateUser: prin -> string -> string -> nonce -> request

type response =
  | SamlAuthnRequestRedirect: uri -> prin -> samlmessage -> dsig -> string -> response
  | Challenge: nonce -> response
  | Failed: response

val send: prin -> request -> unit
val recieve: prin -> response 


val createAuthnRequest: prin -> prin -> (samlmessage * dsig)
val createChallenge: prin -> string
val createSamlResponse: prin -> prin -> (samlmessage * dsig)

val recieveHttpRequest: prin -> uri
val recieveHttpResponse: prin -> resource
val recieveAutenticationRequestChallenge: prin -> string
val recieveAutenticationRequest: prin -> (string * string * string)
val recieveAutenticationCredentials: prin -> (samlmessage * dsig * string)
val recievehttpRedirect: prin -> (prin * samlmessage * dsig * string)

val sendRequestResource: prin -> request -> unit
val sendhttpRedirect: prin -> prin -> samlmessage -> dsig -> string -> unit
val sendAuthnRequest: prin -> samlmessage -> dsig -> string -> unit
val sendAutenticationRequest: prin -> string -> string -> string -> unit
val sendAutenticationChallenge: prin -> string -> unit
val sendAuthentication: prin -> samlmessage -> string -> unit
val sendResource: prin -> resource

end (*PROTOCOL*)