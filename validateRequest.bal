import ballerina/http;
  
public function validateRequest (http:Caller outboundEp, http:Request req) {
    // Backend requires X-API-KEY header. No point in passing the request to the backend
    // if the header is not present in the request.
    boolean hasApiKey = req.hasHeader("X-API-KEY");
    if (!hasApiKey) {
        http:Response res = new;
        res.statusCode = 400;
        json message = {"error": "Missing required header"};
        res.setPayload(message);
        var status = outboundEp->respond(res);
    }
}
