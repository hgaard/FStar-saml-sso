module X

open Protocol
open FstNetwork

val GenKeys: prin -> string
let GenKeys principal = 
	println "starting keygen";
	let (privk, pubk) = KeyGenExt principal in
	
	print_int 2;
	"super"

val GetReq: prin -> prin -> samlmessage
let GetReq sp idp = 
	CreateAuthnRequest sp idp
	

val GetSamlMessages: prin -> prin -> string
let GetSamlMessages sp idp = 
	print_string "Getting AuthReq\n";
	let req = CreateAuthnRequest sp idp in
	print_string req;
	(*print_string "\nGetting Challenge\n";
	let challenge = CreateChallenge sp in
	print_string challenge;*)
	print_string "\nGetting Assertion\n";
	let assertion = CreateSamlAssertion "me" idp sp in
	print_string assertion;
	print_string "\nGetting Response\n";
	let response = CreateSamlResponse idp sp assertion in
	print_string response;
	"Done"

val CreateAndSend: prin -> prin ->unit
let CreateAndSend sp idp =
	let authReq = CreateAuthnRequest sp idp in
	let req = SamlProtocolMessage sp authReq "sig" in
	let status = SendX sp req in
	match status with
	| true -> print_string "great!";()
	| _ -> print_string "crap!";()

	
val CreateSendAndRecieve: prin -> prin ->unit
let CreateSendAndRecieve sp idp =
	let authReq = CreateAuthnRequest sp idp in
	let req = SamlProtocolMessage sp authReq "sig" in
	let status = SendX sp req in
	match status with
	| true -> print_string "great!";
		let msg = RecieveX sp in
		match msg with
		| HttpGet (url) -> 
			print_string url;()
	| _ -> print_string "crap!";()


