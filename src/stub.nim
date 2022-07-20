import httpbeast,strutils,json,options

type Stub* = ref object
  stubPath*:string
  stubMethod*: Option[HttpMethod]
  stubContentType*: string
  stubStatus*: Option[HttpCode]
  stubResponse*: string
  stubSleep*: int

proc createStub(json:JsonNode) :Stub=
  result = new Stub
  result.stubPath = json["path"].str
  result.stubMethod = case json["method"].str
    of "HEAD", "head":
      some(HttpHead)
    of "GET", "get":
      some(HttpGet)
    of "POST", "post":
      some(HttpPost)
    of "PUT", "put":
      some(HttpPut)
    of "DELETE", "delete":
      some(HttpDelete)
    of "TRACE", "trace":
      some(HttpTrace)
    of "OPTIONS", "options":
      some(HttpOptions)
    of "CONNECT", "connect":
      some(HttpConnect)
    of "PATCH", "patch":
      some(HttpPatch)
    else:
      none(HttpMethod)
  result.stubContentType = json["contentType"].str
  result.stubStatus =
    case json["statusCode"].str.parseInt()
      of 0 .. 599:
        some(HttpCode(json["statusCode"].str.parseInt()))
      else:
        none(HttpCode)
  result.stubResponse = json["response"].str
  result.stubSleep = json["sleep"].getInt

proc getStubsOn*(path:string):seq[Stub] =
  let 
    jsonStr = readFile(path)
    stubSettings = parseJson jsonStr

  if stubSettings.kind == JArray:
    for v in stubSettings:
      let stub = createStub(v)
      result.add(stub)
  else:
    let stub = createStub(stubSettings)
    result.add(stub)
