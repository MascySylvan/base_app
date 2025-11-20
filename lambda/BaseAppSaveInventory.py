import json
import boto3
import uuid


def lambda_handler(event, context):
    dynamodb = boto3.resource("dynamodb")
    table = dynamodb.Table("base_app_inventory")

    # CORS headers
    headers = {
        "Access-Control-Allow-Headers": "Content-Type,system-id",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "OPTIONS,POST",
    }

    # Extract systemId from headers
    system_id = None
    if event.get("headers"):
        system_id = event["headers"].get("system-id")

    if not system_id:
        return {
            "statusCode": 400,
            "headers": headers,
            "body": json.dumps({"message": "system-id is required in headers"}),
        }

    # Parse JSON body
    try:
        body = json.loads(event.get("body", "{}"))
    except:
        return {
            "statusCode": 400,
            "headers": headers,
            "body": json.dumps({"message": "Invalid JSON body"}),
        }

    # Extract fields
    uuid_value = body.get("uuid")
    item_name = body.get("itemName")
    quantity = body.get("quantity")
    unit_price = body.get("unitPrice")
    category = body.get("category")
    createdDate = body.get("createdDate")

    # Validation
    if not item_name or quantity is None or unit_price is None:
        return {
            "statusCode": 400,
            "headers": headers,
            "body": json.dumps(
                {"message": "itemName, quantity and unitPrice are required"}
            ),
        }

    # Convert quantity to int and unitPrice to float
    try:
        quantity = int(quantity)
        unit_price = str(float(unit_price))
    except:
        return {
            "statusCode": 400,
            "headers": headers,
            "body": json.dumps(
                {"message": "quantity must be int and unitPrice must be float"}
            ),
        }

    # Create UUID if needed
    if uuid_value in [None, "", "0"]:
        uuid_value = str(uuid.uuid4())

    # Save item to DynamoDB
    item = {
        "systemId": system_id,
        "uuid": uuid_value,
        "itemName": item_name,
        "quantity": quantity,
        "unitPrice": unit_price,
        "category": category,
        "createdDate": createdDate,
    }

    try:
        table.put_item(Item=item)

        return {
            "statusCode": 200,
            "headers": headers,
            "body": json.dumps({"message": item_name + " added successfully", "data": item}),
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "headers": headers,
            "body": json.dumps({"message": str(e)}),
        }
