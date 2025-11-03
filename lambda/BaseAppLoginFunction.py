import json
import boto3
from boto3.dynamodb.conditions import Attr

def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    table_name = "base_app_users"
    table = dynamodb.Table(table_name)

    # Extract query parameters from URL
    params = event.get('queryStringParameters')

    if not params:
        return {
            'statusCode': 400,
        'headers': {
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
        },
            'body': json.dumps({'message': 'No query parameters provided'})
        }

    # Build the filter expression dynamically
    filter_expression = None
    for key, value in params.items():
        condition = Attr(key).eq(value)
        if filter_expression is None:
            filter_expression = condition
        else:
            filter_expression = filter_expression & condition

    try:
        # Scan the DynamoDB table with filters
        response = table.scan(
            FilterExpression=filter_expression,
            Limit=1  # Only need the first match
        )

        items = response.get('Items', [])
        if not items:
            return {
                'statusCode': 404,
        'headers': {
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
        },
                'body': json.dumps({'message': 'Account with entered credentials does not exist.'})
            }

        return {
            'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
        },
            'body': json.dumps(items[0])
        }

    except Exception as e:
        return {
            'statusCode': 500,
        'headers': {
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
        },
            'body': json.dumps({'message': str(e)})
        }
