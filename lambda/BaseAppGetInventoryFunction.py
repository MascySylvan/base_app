import json
import boto3
from boto3.dynamodb.conditions import Key

def lambda_handler(event, context):
    dynamodb = boto3.resource("dynamodb")
    table = dynamodb.Table("base_app_inventory")

    # CORS headers
    headers = {
        "Access-Control-Allow-Headers": "Content-Type,system-id",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "OPTIONS,GET",
    }

    # Extract systemId
    system_id = None
    if event.get("headers"):
        system_id = event["headers"].get("system-id")

    if not system_id:
        return {
            "statusCode": 400,
            "headers": headers,
            "body": json.dumps({"message": "system-id is required in headers"}),
        }

    # Query DynamoDB
    try:
        response = table.query(
            KeyConditionExpression=Key("systemId").eq(system_id)
        )

        items = response.get("Items", [])

        # Convert quantity → int and unitPrice → float
        formatted_items = []
        for item in items:
            formatted_items.append({
                "uuid": item.get("uuid"),
                "itemName": item.get("itemName"),
                "quantity": int(item.get("quantity", 0)),
                "unitPrice": float(item.get("unitPrice", 0)),
                "category": item.get("category"),
                "createdDate": item.get("createdDate"),
            })

        return {
            "statusCode": 200,
            "headers": headers,
            "body": json.dumps(formatted_items),
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "headers": headers,
            "body": json.dumps({"message": str(e)}),
        }
