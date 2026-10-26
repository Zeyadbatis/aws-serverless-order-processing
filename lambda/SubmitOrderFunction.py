import json
import boto3

sqs = boto3.client('sqs')
queue_url = 'https://sqs.ap-southeast-2.amazonaws.com/449126594288/sqs'

def lambda_handler(event, context):
    headers = {
        'Access-Control-Allow-Origin': 'https://zeyadbatis.com',
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