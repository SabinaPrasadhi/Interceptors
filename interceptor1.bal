import ballerina/http;
import ballerina/log;
final string filter_name_header = "X-requestHeader";
final string filter_name_header_value = "RequestFilter";
public type RequestFilter object {
    *http:RequestFilter;
    public function filterRequest(http:Caller caller, http:Request request,
                        http:FilterContext context) returns boolean {
        request.setHeader(filter_name_header, filter_name_header_value);
        return true;
    }
};
RequestFilter requestFilter = new;
public type ResponseFilter object {
    *http:ResponseFilter;
    public function filterResponse(http:Response response, 
                        http:FilterContext context) returns boolean {
        response.setHeader("X-responseHeader", "ResponseFilter");
        return true;
    }
};
ResponseFilter responseFilter = new;
listener http:Listener echoListener = new http:Listener(9090,
                                            config = { filters: [requestFilter, responseFilter]});@http:ServiceConfig {
    basePath: "/hello"
}
service echo on echoListener {
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/sayHello"
    }
    resource function echo(http:Caller caller, http:Request req) {
        http:Response res = new;
        res.setHeader(filter_name_header, req.getHeader(filter_name_header));
        res.setPayload("Hello, World!");
        var result = caller->respond(<@untainted> res);
        if (result is error) {
           log:printError("Error sending response", err = result);
        }
    }
}

