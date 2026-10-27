import json
import boto3
import os

sqs = boto3.client('sqs')
queue_url = os.environ['QUEUE_URL']
allowed_origin = os.environ['ALLOWED_ORIGIN']

def lambda_handler(event, context):
    headers = {
        'Access-Control-Allow-Origin': allowed_origin,
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'OPTIONS,POST'
    }

    try:
        order_details = json.loads(event['body'])

        sqs.send_message(
            QueueUrl=queue_url,
            MessageBody=json.dumps(order_details)
        )

        return {
            'statusCode': 200,
            'headers': headers,
            'body': json.dumps({
                'message': 'Order submitted to queue successfully'
            })
        }

    except Exception as e:
        print(f"Error submitting order: {e}")

        return {
            'statusCode': 400,
            'headers': headers,
            'body': json.dumps({'error': str(e)})
        }