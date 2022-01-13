global without sharing class GenericHttpMock implements HttpCalloutMock {
  String body;
  Integer statusCode;
  Map<String, String> headers;

  GenericHttpMock(Integer statusCode, String body, Map<String, String> headers) {
    this.body = body;
    this.statusCode = statusCode;
    this.headers = headers;
  }

  global HttpResponse respond(HttpRequest req) {
    HttpResponse res = new HttpResponse();
    if (headers != null) {
      for (String k : headers.keySet()) {
        res.setHeader(k, headers.get(k));
      }
    }
    res.setStatusCode(statusCode);
    res.setBody(body);
    return res;
  }
}
