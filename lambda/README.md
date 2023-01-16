### Lambda Function

-------------
<p>

Here, Terraform Lambda module is used to defined the infrastucture for Lambda function.
[Link of the terraform aws lambda module](https://registry.terraform.io/modules/terraform-aws-modules/lambda/aws/latest)

</p>

-------------

<h3>The input parameters to define the lambda infrastructure are :</h3>

<ul>

<li>

source <br />

<b> Description : </b>  source path of the module.

</li>

<li>

function_name <br />

<b>Description : </b>  Name for the lambda funtion. Function name must be unique. 

</li>

<li>

description <br />

<b>Description : </b>  Desvription for the lambda funtion.  

</li>

<li>

handler <br />

<b>Description : </b>  Lambda function entry point of one's code. Biscally it's a function name from where the lambda execution starts.
According to aws documentation, "The Lambda function handler is the method in your function code that processes events. 
When your function is invoked, Lambda runs the handler method. When the handler exits or returns a response, it becomes available to handle another event."  

</li>

<li>

runtime <br />

<b>Description : </b>  Timeout is the maximum amount of time in seconds that a Lambda function can run. 
The default value for this setting is 3 seconds, 
but one can adjust this in increments of 1 second up to a maximum value of 15 minutes(900 seconds).  

</li>

<li>

source_path <br />

<b>Description : </b>  local file or directory path for the lambda source code.  

</li>


<li>

environment_variables <br />

<b>Description : </b>  Difining the environment variables for lambda.The Lambda runtime makes environment 
variables available to code and sets additional environment variables that contain information about the 
function and invocation request.

</li>

<li>

tags <br />

<b>Description : </b>  tags for the lambda source code.  

</li>

<li>

allowed_triggers <br />

<b>Description : </b>  allowed_triggers create lambda permissions to create trigger for the  aws services.

</li>


</ul>

----------------------
<p>

One can use other input parameters to set his/her desired lambda infrastructure from here :
[Link of the terraform aws lambda module](https://registry.terraform.io/modules/terraform-aws-modules/lambda/aws/latest)

</p>
