import httpbeast,strutils,json,options,strformat

type Stub* = ref object
  stubPath*: Option[string]
  stubMethod*: Option[HttpMethod]
  stubContentType*: Option[string]
  stubStatus*: HttpCode
  stubResponse*: string
  stubSleepMs*: int

type
  StubLoadError* = object of IOError

proc createStub(json:JsonNode) :Stub=
  result = new Stub
  try:
    result.stubPath = some(json["path"].str)
  except:
    raise newException(StubLoadError, fmt"path is not set on this json")

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
      raise newException(StubLoadError, fmt"method is not set on {$result.stubPath}")

  try:
    var contentType = json["contentType"].str
    if contentType == "":
      result.stubContentType = none(string)
    else:
      result.stubContentType = some(fmt"Content-Type: {contentType}")
  except:
    result.stubContentType = some("Content-Type: application/json")

  result.stubStatus =
    case json["statusCode"].str.parseInt()
      of 0 .. 599:
        HttpCode(json["statusCode"].str.parseInt())
      else:
        raise newException(StubLoadError, fmt"statusCode is not set on {$result.stubPath}")

  try:
    result.stubResponse = json["response"].str
  except:
    raise newException(StubLoadError, fmt"response is not set on {$result.stubPath}")

  try:
    result.stubSleepMs = json["sleep"].getInt
  except:
    result.stubSleepMs = 0

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
