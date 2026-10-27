import json
import boto3
import os
from datetime import datetime, timezone

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['DYNAMODB_TABLE_NAME'])


def lambda_handler(event, context):
    for record in event['Records']:
        message_body = json.loads(record['body'])

        item = {'order_id': record['messageId'],
                 'productName': message_body['productName'],
                 'quantity': message_body['quantity'],
                 'email':message_body['email'],
                 'orderDate': datetime.now(timezone.utc).isoformat()}
        
        table.put_item(Item=item)
    return {'statusCode': 200, 'body': json.dumps({'message': 'Orders processed successfully'})}
