package builder;


@Description {value: "GraphQL query builder"}
public struct GQLBuilder {
    string gqlQuery;
    int indexStepNested;
    int indexStepObject;
    boolean flag;
}

@Description {value: "Set the query to type query"}
@Return {value: "GQLBuilder: A GQLBuilder instance"}
public function <GQLBuilder gqlBuilder> setQuery () returns GQLBuilder {
    gqlBuilder.gqlQuery = GQL_QUERY;
    gqlBuilder.indexStepNested = 0;
    gqlBuilder.indexStepObject = 0;
    gqlBuilder.flag = true;
    return gqlBuilder;
}

@Description {value: "Set the query to type search"}
@Return {value: "GQLBuilder: A GQLBuilder instance"}
public function <GQLBuilder gqlBuilder> setSearch () returns GQLBuilder {
    gqlBuilder.gqlQuery = GQL_QUERY;
    gqlBuilder.indexStepNested = 0;
    gqlBuilder.indexStepObject = 0;
    gqlBuilder.flag = true;
    return gqlBuilder;
}

@Description {value: "Add a variable to the query or search"}
@Param {value: "variableName: Name of the variable to be included in the GQL query"}
@Param {value: "variableType: Type of the variable to be included in the GQL query"}
@Return {value: "GQLBuilder: A GQLBuilder instance"}
public function <GQLBuilder gqlBuilder> addVariable (string variableName, string variableType) returns GQLBuilder {
    string stringQuery = gqlBuilder.gqlQuery;
    int indexOfVariableEnd = stringQuery.indexOf(")");
    string partOne = stringQuery.subString(0, indexOfVariableEnd);
    string partTwo = stringQuery.subString(indexOfVariableEnd, stringQuery.length());
    partOne = partOne + "$" + variableName + ":" + variableType + ",";
    gqlBuilder.gqlQuery = partOne + partTwo;

    return gqlBuilder;
}

@Description {value: "Add an GQL object to the same level as the previous object"}
@Param {value: "queryObject: Object to be added to the query"}
@Return {value: "GQLBuilder: A GQLBuilder instance"}
public function <GQLBuilder gqlBuilder> addObject (string queryObject) returns GQLBuilder {
    string stringQuery = gqlBuilder.gqlQuery;
    int indexStep = gqlBuilder.indexStepObject;
    int indexOfQueryEnd = stringQuery.lastIndexOf("}");
    string partOne = stringQuery.subString(0, indexOfQueryEnd - indexStep);
    string partTwo = stringQuery.subString(indexOfQueryEnd - indexStep, stringQuery.length());
    partOne = partOne + queryObject + ",";
    gqlBuilder.gqlQuery = partOne + partTwo;
    if (gqlBuilder.flag) {
        gqlBuilder.indexStepNested = gqlBuilder.indexStepNested + 2;
        gqlBuilder.flag = false;
    }
    return gqlBuilder;
}

@Description {value: "Add an GQL object inside the previous object"}
@Param {value: "queryObject: Object to be added to the query"}
@Return {value: "GQLBuilder: A GQLBuilder instance"}
public function <GQLBuilder gqlBuilder> addNestedObject (string queryNestedObject) returns GQLBuilder {
    string stringQuery = gqlBuilder.gqlQuery;
    int indexStep = gqlBuilder.indexStepNested;
    int indexOfObjectEnd = stringQuery.lastIndexOf("}");
    string partOne = stringQuery.subString(0, indexOfObjectEnd - indexStep);
    string partTwo = stringQuery.subString(indexOfObjectEnd - indexStep, stringQuery.length());
    partOne = partOne + queryNestedObject + ",";
    gqlBuilder.gqlQuery = partOne + partTwo;
    gqlBuilder.indexStepObject = gqlBuilder.indexStepObject + 2;
    gqlBuilder.indexStepNested = gqlBuilder.indexStepNested + 2;
    gqlBuilder.flag = true;
    return gqlBuilder;
}

@Description {value: "Add an argument to the added object"}
@Param {value: "argumentName: Argument name"}
@Param {value: "argumentValue: Argument value"}
@Return {value: "GQLBuilder: A GQLBuilder instance"}
public function <GQLBuilder gqlBuilder> addArgument (string argumentName, string argumentValue) returns GQLBuilder {
    string stringQuery = gqlBuilder.gqlQuery;
    int indexOfArgumentEnd = stringQuery.lastIndexOf(")");
    string partOne = stringQuery.subString(0, indexOfArgumentEnd);
    string partTwo = stringQuery.subString(indexOfArgumentEnd, stringQuery.length());
    partOne = partOne + argumentName + ":" + "$" + argumentValue + ",";
    gqlBuilder.gqlQuery = partOne + partTwo;
    return gqlBuilder;
}

@Description {value: "Add a set of fields to the added object"}
@Param {value: "fields: Array of fields"}
@Return {value: "GQLBuilder: A GQLBuilder instance"}
public function <GQLBuilder gqlBuilder> addFields (string[] fields) returns GQLBuilder {
    string stringQuery = gqlBuilder.gqlQuery;
    int indexStep = gqlBuilder.indexStepNested;
    int indexOfFieldEnd = stringQuery.lastIndexOf("}");
    string partOne = stringQuery.subString(0, indexOfFieldEnd - indexStep);
    string partTwo = stringQuery.subString(indexOfFieldEnd - indexStep, stringQuery.length());
    foreach field in fields {
        partOne = partOne + field + ",";
    }
    gqlBuilder.gqlQuery = partOne + partTwo;

    return gqlBuilder;
}

@Description {value: "Select the nested level in query, to add an object to that level"}
@Param {value: "level: Integral value of the level"}
@Return {value: "GQLBuilder: A GQLBuilder instance"}
public function <GQLBuilder gqlBuilder> goToLevel(int level) returns GQLBuilder {
    gqlBuilder.indexStepObject = level * 2;
    gqlBuilder.indexStepNested = (level * 2) + 2;

    return gqlBuilder;
}

@Description {value: "After every setup is complete, build the query and return"}
@Return {value: "GQLBuilder: A string query"}
public function <GQLBuilder gqlBuilder> build () returns string {
    string stringQuery = gqlBuilder.gqlQuery
                         .replace(",)", ")")
                         .replace(",}", "}");
    return stringQuery;
}
