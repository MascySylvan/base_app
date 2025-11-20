import json
import boto3
import uuid

def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table("base_app_parameters")

    # CORS headers
    headers = {
        "Access-Control-Allow-Headers": "Content-Type,system-id",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "OPTIONS,POST"
    }

    # Extract systemId from headers
    system_id = None
    if event.get("headers"):
        system_id = event["headers"].get("system-id")

    if not system_id:
        return {
            "statusCode": 400,
            "headers": headers,
            "body": json.dumps({"message": "system-id is required in headers"})
        }

    # Parse body
    try:
        body = json.loads(event.get("body", "{}"))
    except:
        return {
            "statusCode": 400,
            "headers": headers,
            "body": json.dumps({"message": "Invalid JSON body"})
        }

    # Extract fields from body
    uuid_value = body.get("uuid")
    param_class = body.get("paramClass")
    param_name = body.get("paramName")
    param_color = body.get("paramColor")

    # Validation
    if not param_class or not param_name or not param_color:
        return {
            "statusCode": 400,
            "headers": headers,
            "body": json.dumps({"message": "paramClass, paramName and paramColor are required"})
        }

    # If uuid is "0", create a new UUID
    if uuid_value in [None, "", "0"]:
        uuid_value = str(uuid.uuid4())

    # Save item
    item = {
        "systemId": system_id,     # PK
        "uuid": uuid_value,         # SK
        "paramClass": param_class,
        "paramName": param_name,
        "paramColor": param_color
    }

    try:
        table.put_item(Item=item)

        return {
            "statusCode": 200,
            "headers": headers,
            "body": json.dumps({
                "uuid": uuid_value,
                "paramClass": param_class,
                "paramName": param_name,
                "paramColor": param_color
            })
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "headers": headers,
            "body": json.dumps({"message": str(e)})
        }
