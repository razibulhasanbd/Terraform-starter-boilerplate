import json


def lambda_handler(event, context):
    
  message= {
    'message':'Hello From sqs connected function!!'
  }
  return {
        "statusCode": 200,
        "body": json.dumps(message)
    }
