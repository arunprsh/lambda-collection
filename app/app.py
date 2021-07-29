import sagemaker
import pyodbc
import json

print(f"Using SageMaker version: {sagemaker.__version__}")
print(f"Using Pyodbc version: {pyodbc.version}")


def handler(event, context):
    body = {
        "message": "Hello World!",
        "input": event
    }
    response = {
        "statusCode": 200,
        "body": json.dumps(body)
    }
    return response