import httpbeast,os,strutils,parseopt,json,asyncdispatch,options
import stub

var stubs: seq[Stub]

proc getArgs():tuple[port:int, path:string] =
  result = (port:8080, path:"co-metub.json")
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
      if req.httpMethod == v.stubMethod and req.path.get() == v.stubPath:
        try:
          if v.stubSleep > 0:
            await sleepAsync(v.stubSleep)
          let 
            headers = "Content-Type: " & v.stubContentType
            stauts = v.stubStatus.get
          req.send(stauts, v.stubResponse, headers)
        except Exception:
          let
            headers = "Content-type: application/json; charset=utf-8"
            response = %*{"message": "エラーが発生しました"}
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
