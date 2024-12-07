import boto3, os, json

sns_client = boto3.client('sns')

def mail_handler(event, context):
    for record in event["Records"]:

        if record['eventName'] == 'INSERT':
            new_record = record['dynamodb']['NewImage']    
            response = sns_client.publish(
                TargetArn=os.environ['SNS_TOPIC'],
                Message=json.dumps({'default': json.dumps(new_record)}),
                MessageStructure='json'
            )