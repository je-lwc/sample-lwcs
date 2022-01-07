public without sharing class UxApiHelper {
  public enum HttpMethod {
    HTTP_GET,
    HTTP_POST,
    HTTP_DELETE,
    HTTP_PUT
  }

  public class RequestParams {
    public String origin;
    public String path;
    public HttpMethod method;
    public Object body;
    public Map<String, String> headers;
    public Map<String, String> queryParams;
    public Integer timeout;

    public String url {
      get {
        String endpoint = origin + '/' + path;
        if (queryParams != null && !queryParams.isEmpty()) {
          String params = '?';
          for (String key : queryParams.keySet()) {
            String value = queryParams.get(key);
            // Encode the parameter only if it's NOT encoded (by checking if it contains space)
            if (value != null && value.contains(' ')) {
              value = EncodingUtil.urlEncode(value, 'UTF-8');
            }
            params += String.format('{0}={1}', new List<String>{ key, value }) + '&';
          }
          endpoint += params.removeEnd('&');
        }
        return endpoint;
      }
    }

    public RequestParams() {
      // use named credential by default
      origin = 'callout:NamedUxAPI';
      method = HttpMethod.HTTP_GET;
      headers = new Map<String, String>();
      queryParams = new Map<String, String>();
      timeout = 120000;
    }
  }

  static HttpRequest getHttpRequest(RequestParams requestParams) {
    HttpRequest request = new HttpRequest();
    request.setMethod(requestParams.method.name().removeStart('HTTP_'));
    request.setTimeout(requestParams.timeout);
    request.setEndpoint(requestParams.url);

    // Set Headers
    if (requestParams.Headers != null && !requestParams.Headers.isEmpty()) {
      for (String key : requestParams.headers.keySet()) {
        String value = requestParams.headers.get(key);
        request.setHeader(key, value);
      }
    }

    // Set Body
    if (requestParams.method != HttpMethod.Http_GET && requestParams.body != null) {
      if (requestParams.body instanceof String) {
        request.setBody((String) requestParams.body);
      } else if (requestParams.body instanceof Blob) {
        request.setBodyAsBlob((Blob) requestParams.body);
      } else if (requestParams.body instanceof Dom.Document) {
        request.setBodyDocument((Dom.Document) requestParams.body);
      } else {
        request.setBody(String.valueOf(requestParams.body));
      }
    }
    return request;
  }

  public static HttpResponse sendRequest(RequestParams requestParams) {
    HttpRequest request = getHttpRequest(requestParams);
    return new Http().send(request);
  }

  public static Object sendRequestContinuation(RequestParams requestParams, String callbackMethod) {
    HttpRequest request = getHttpRequest(requestParams);
    Continuation con = new Continuation(120);
    con.state = con.addHttpRequest(request);
    con.continuationMethod = callbackMethod;
    return con;
  }
}
