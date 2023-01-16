import json


def lambda_handler(event, context):
    
  message= {
    'message':'Hello From Event Triggered Function!!'
  }
  return {
        "statusCode": 200,
        "body": json.dumps(message)
    }
