import ballerina/http;

public function validateResponse (http:Caller outboundEp, http:Response res) {
    // Client only supports json. Therefore we need to make sure only json responses are returned
    var payload = res.getJsonPayload();
    if (payload is error) {
        res.statusCode = 500;
        json message = {"error": "Error while generating response"};
        res.setPayload(message);
    }
}
