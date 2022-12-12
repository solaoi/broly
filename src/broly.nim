import httpbeast,os,strutils,parseopt,json,asyncdispatch,options
import stub
import times
var stubs: seq[Stub]

proc getArgs():tuple[port:int, path:string] =
  result = (port:8080, path:"target.json")
  var opt = parseopt.initOptParser( os.commandLineParams().join(" ") )
  for kind, key, val in opt.getopt():
    case key
    of "port", "p":
      case kind
      of parseopt.cmdLongOption, parseopt.cmdShortOption:
        opt.next()
        result.port = opt.key.parseInt()
      else: discard
    else:
      result.path = key

proc onRequest(req: Request): Future[void]{.async.} = 
  var isSend:bool
  {.cast(gcsafe).}:
    for v in stubs:
      if req.httpMethod == v.stubMethod and req.path == v.stubPath:
        try:
          if v.stubSleepMs > 0:
            poll(v.stubSleepMS)
          let status = v.stubStatus
          if v.stubContentType.isSome:
            let headers = v.stubContentType.get
            req.send(status, v.stubResponse, headers)
          else:
            req.send(status, v.stubResponse)
        except Exception:
          let
            headers = "Content-type: application/json; charset=utf-8"
            response = %*{"message": "Error occurred."}
          req.send(Http400, $response, headers)
        finally:
          isSend=true
          break
  if not isSend:
    req.send(Http404)

when isMainModule:
  let (port, path) = getArgs()
  stubs = getStubsOn(path)
  let settings = initSettings(Port(port))
  run(onRequest, settings)
