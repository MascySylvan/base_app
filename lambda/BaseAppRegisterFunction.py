import json
import boto3
from boto3.dynamodb.conditions import Attr


def lambda_handler(event, context):
    dynamodb = boto3.resource("dynamodb")
    table = dynamodb.Table("base_app_users")

    # Common CORS headers for API Gateway
    headers = {
        "Access-Control-Allow-Headers": "Content-Type",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "OPTIONS,POST",
    }

    try:
        # Parse incoming JSON payload
        body = json.loads(event.get("body", "{}"))

        required_fields = [
            "uuid",
            "username",
            "password",
            "createdDate",
            "firstName",
            "lastName",
        ]
        for field in required_fields:
            if field not in body:
                return {
                    "statusCode": 400,
                    "headers": headers,
                    "body": json.dumps({"message": f"Missing required field: {field}"}),
                }

        username = body["username"]

        existing_user = table.scan(
            FilterExpression=Attr("username").eq(username),
            ProjectionExpression="#u",
            ExpressionAttributeNames={"#u": "uuid"},
        )

        if existing_user["Count"] > 0:
            return {
                "statusCode": 400,
                "headers": headers,
                "body": json.dumps({"message": "Username already exists"}),
            }

        # Insert new user
        table.put_item(Item=body)

        return {
            "statusCode": 200,
            "headers": headers,
            "body": json.dumps({"message": "Firefly " + username + " added successfully", "data": body}),
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "headers": headers,
            "body": json.dumps({"message": str(e)}),
        }
