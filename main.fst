module MAIN
open PROTOCOL
open CLIENT

val main: sp:prin -> user:string -> password:string -> unit
let main sp user password = 
	client sp user password
end