import json


def lambda_handler(event, context):
    
  message= {
    'message':'Hello From Sign In Page!!'
  }
  return {
        "statusCode": 200,
        "body": json.dumps(message)
    }
