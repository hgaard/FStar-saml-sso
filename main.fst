module MAIN
open PROTOCOL
open CLIENT

val main: sp:prin -> res:uri -> user:string -> password:string -> unit
let main sp resource user password = 
	let req = HttpGet resource in
		client sp req user password
end