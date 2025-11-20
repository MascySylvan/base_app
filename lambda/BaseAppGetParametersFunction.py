import json
import boto3
from boto3.dynamodb.conditions import Key, Attr

def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table("base_app_parameters")

    # CORS Headers
    headers = {
        "Access-Control-Allow-Headers": "Content-Type,system-id",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "OPTIONS,GET,POST"
    }

    # Extract systemId from headers
    system_id = None
    if event.get("headers"):
        system_id = event["headers"].get("system-id")

    # Extract paramClass from query string
    param_class = None
    if event.get("queryStringParameters"):
        param_class = event["queryStringParameters"].get("paramClass")

    # Validate input
    if not system_id or not param_class:
        return {
            "statusCode": 400,
            "headers": headers,
            "body": json.dumps({"message": "systemId (header) and paramClass (query) are required"})
        }

    try:
        # Query using systemId (Partition Key)
        if param_class == "ALL":
            # No filtering, just query by systemId
            print("Fetching ALL param classes")
            response = table.query(
                KeyConditionExpression=Key("systemId").eq(system_id)
            )
        else:
            # Filter by paramClass
            print(f"Filtering paramClass = {param_class}")
            response = table.query(
                KeyConditionExpression=Key("systemId").eq(system_id),
                FilterExpression=Attr("paramClass").eq(param_class)
            )

        items = response.get("Items", [])

        # Only include uuid, paramClass, paramName
        filtered_items = [
            {
                "uuid": item.get("uuid"),
                "paramClass": item.get("paramClass"),
                "paramName": item.get("paramName"),
                "paramColor": item.get("paramColor")
            }
            for item in items
        ]

        return {
            "statusCode": 200,
            "headers": headers,
            "body": json.dumps(filtered_items)
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "headers": headers,
            "body": json.dumps({"message": str(e)})
        }
