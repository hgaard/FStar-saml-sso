module Main
open Protocol
open Client

val main: sp:prin -> res:uri -> user:string -> password:string -> unit
let main sp resource user password = 
	let req = HttpGet resource in
		let message = client sp req user password in
		()
end