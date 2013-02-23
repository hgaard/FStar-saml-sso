module HttpProtocol

type HttpMessage =
  | Get: uri -> HttpMessage
  | Post: uri -> HttpMessage
  | Redirect: destination -> message -> HttpMessage
