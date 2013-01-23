module xServer

open Protocol
open FstNetwork

val server: string -> string -> unit
let server sp idp = 
  let msg = RecieveX "sp" in
  match msg with
  | HttpGet (uri) -> 
    let authReq = CreateAuthnRequest sp idp in
    let req = SamlProtocolMessage sp authReq "sig" in
    let status = SendX "sp" req in
    match status with
    | true -> print_string "great!";()
    | false -> print_string "crap!";()
  | _ -> print_string "Oh shit!";()