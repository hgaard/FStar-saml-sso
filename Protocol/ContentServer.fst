module ContentServer

val buildErrorPage: string -> string
let buildErrorPage msg =
	let errorHeader = "<html><head><title>the page</title></head><body>" in
	let errorFooter = "</body></html>" in
	Concat errorHeader (Concat msg errorFooter)

val getContent: string -> string
let getContent page =
	(*Should read the specified page and return it*)
	"<html><head><title>the page</title></head><body>You are now logged in</body></html>"

val getErrorPage: int -> string
let getErrorPage status = match	status with
	| 400 -> buildErrorPage "400 - Bad request"
	| 403 -> buildErrorPage "403 - Forbidden"
	| _ -> buildErrorPage "500 - internal server error"
