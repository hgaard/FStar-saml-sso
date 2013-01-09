module X

open Protocol
open FstNetwork

val GetReq: prin -> prin -> samlmessage
let GetReq sp idp = 
	CreateAuthnRequest sp idp

val CreateAndSend: prin -> prin ->unit
let CreateAndSend sp idp =
	let authReq = CreateAuthnRequest sp idp in
	let req = SamlProtocolMessage sp authReq "sig" in
	let status = SendX sp "GET" "query=Somevalue" "cookei=somevalue" "body" in
	match status with
	| Success -> print_string "great!";()
	| _ -> print_string "crap!";()

	
val CreateSendAndRecieve: prin -> prin ->unit
let CreateSendAndRecieve sp idp =
	let authReq = CreateAuthnRequest sp idp in
	let req = SamlProtocolMessage sp authReq "sig" in
	let status = SendX sp "GET" "query=Somevalue" "cookei=somevalue" "body" in
	match status with
	| Success -> print_string "great!";
		let resp = RecieveX sp in 
			print_string resp; ()
	| _ -> print_string "crap!";()