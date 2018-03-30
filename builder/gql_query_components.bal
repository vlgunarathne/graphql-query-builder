package builder;

import ballerina/io;


// GraphQL Query template
const string GQL_QUERY = "query(){}";
const string GQL_SEARCH = "search(){}";

// GraphQL objects
public const string OBJECT_REPOSITORY = "repository(){}";
public const string OBJECT_PROJECTS = "projects(){}";
public const string OBJECT_PAGE_INFO = "pageInfo{hasNextPage,hasPreviousPage,startCursor,endCursor}";
public const string OBJECT_CREATOR = "creator{login,resourcePath,url,avatarUrl}";
public const string OBJECT_REPOSITORY_OWNER = "owner{id,projectsResourcePath,projectsUrl,viewerCanCreateProjects,__typename}";

// GraphQL nodes
public const string NODES_REPOSITORY_PROJECT = string `nodes{id,databaseId,name,body,number,createdAt,updatedAt,closed,closedAt,resourcePath,state,url,viewerCanUpdate,{{OBJECT_CREATOR}},{{OBJECT_REPOSITORY_OWNER}}}`;

// GraphQL Data types
public const string GQL_DATATYPE_STRING = "String!";
public const string GQL_DATATYPE_INT = "Int!";
public const string GQL_DATATYPE_PROJECT_STATES = "[ProjectState!]";

// GraphQL Arguments
public const string GQL_ARGUMENT_FIRST = "first";
public const string GQL_ARGUMENT_STATES = "states";
public const string GQL_ARGUMENT_AFTER = "after";
public const string GQL_ARGUMENT_OWNER = "owner";
public const string GQL_ARGUMENT_NAME = "name";

