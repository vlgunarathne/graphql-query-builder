package test;

import ballerina/io;
import ballerina/net.http;
import ballerina/util;

import builder;

public function main (string[] args) {
    endpoint http:ClientEndpoint clientEP {
        targets:[{uri:"https://api.github.com/graphql"}]
    };

    http:Request req = {};
    req.addHeader("Authorization", "Bearer " + getAccessToken());

    builder:GQLBuilder gqlBuilder = {};
    string sQuery = gqlBuilder
                    .setQuery()
                    .addVariable("owner", builder:GQL_DATATYPE_STRING)
                    .addVariable("repository", builder:GQL_DATATYPE_STRING)
                    .addVariable("states", builder:GQL_DATATYPE_PROJECT_STATES)
                    .addVariable("recordCount", builder:GQL_DATATYPE_INT)
                    .addObject(builder:OBJECT_REPOSITORY)
                    .addArgument(builder:GQL_ARGUMENT_OWNER, "owner")
                    .addArgument(builder:GQL_ARGUMENT_NAME, "repository")
                    .addNestedObject(builder:OBJECT_PROJECTS)
                    .addArgument(builder:GQL_ARGUMENT_FIRST, "recordCount")
                    .addArgument(builder:GQL_ARGUMENT_STATES, "states")
                    .addNestedObject(builder:OBJECT_PAGE_INFO)
                    .addObject(builder:NODES_REPOSITORY_PROJECT)
                    .build();
    string stringQuery = string `{"variables":{"owner":"vlgunarathne","repository":"ProLAd-ExpertSystem","states":"OPEN","recordCount":1}, "query":"{{sQuery}}"}`;
    json jsonQuery =? util:parseJson(stringQuery);
    req.setJsonPayload(jsonQuery);
    io:println("Starting request ...");
    var response = clientEP -> post("", req);

    match response {
        http:Response res => {
            var rsp = res.getJsonPayload();
            io:println(rsp);
        }
        http:HttpConnectorError err => io:println(err);
    }

}
