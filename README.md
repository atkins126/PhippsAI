![PhippsAI](media/PhippsAI.png)  

[![Chat on Discord](https://img.shields.io/discord/754884471324672040.svg?logo=discord)](https://discord.gg/tPWjMwK) [![Twitter Follow](https://img.shields.io/twitter/follow/tinyBigGAMES?style=social)](https://twitter.com/tinyBigGAMES)
# PhippsAI - Your Personal AI Butler
### PhippsAI API Integration for Delphi
Seamlessly incorporate tinyBigGAMES's **PhippsAI** API into your <a href="https://www.embarcadero.com/es/products/delphi" target="_blank">Delphi</a> applications.

#### Benefits
- Cost-effectiveness: Our service offers full endpoint access at a significantly lower cost of only $5 per month, making it highly affordable for indie developers with limited budgets.

- Ease of use: We prioritize a user-friendly integration process, ensuring developers can easily incorporate our AI capabilities into their applications without facing unnecessary complexity or technical challenges.

- Focus on supporting indie developers: Our service is specifically designed to cater to the unique needs and constraints of indie developers. We strive to empower them with access to high-quality language models while keeping costs minimal.

- Affordable access to LLM: By leveraging high-quality large language models, we provide developers with access to cutting-edge AI capabilities at a fraction of the cost compared to other options. This allows developers to utilize state-of-the-art technology without incurring exorbitant expenses.

- Seamless app AI integration without high expenses: Our service relieves the burden of high expenses, enabling developers to seamlessly integrate AI into their applications. With affordable access to our service, developers can focus on enhancing their app's functionality instead of worrying about costly infrastructure.

- Safeguards against abuse: We have implemented robust safeguards to prevent abuse of our service, ensuring a fair and enjoyable experience for all users. These measures maintain the quality and availability of our AI capabilities.

In summary, choosing our PhippsAI service provides a cost-effective, user-friendly, and indie developer-focused solution that leverages high-quality language models while safeguarding against abuse.

#### Features
- Integrate Large Language Model (LLM) AI support into your applications.
- API key can be retrieved from the `PhippsAIApiKey` environment variable, if defined.
- Automatic input sanitization to minimize errors.
- Ability to customize proxy settings.
- Rate limiting implemented to prevent abuse.
- Indie developer friendly and affordable with excellent performance.
- Monthly subscription fee of $5.00 US. Full access is granted upon sponsorship. Note: API key generation is currently a manual process, so there may be a short delay after sign-up before receiving your key. We will expedite the process as soon as possible.

#### Minimum Requirements 
- Windows 10
- <a href="https://www.embarcadero.com/products/delphi/starter" target="_blank">Delphi Community Edition</a>

#### Usage
- Obtain your API Key by sponsoring this project at https://github.com/sponsors/tinyBigGAMES. Upon sponsorship confirmation, we will issue you an API key for full access as long as your sponsorship remains active.
- Define the environment variable `PhippsAIApiKey` and assign your API key. You may need to reboot your machine for the changes to take effect.
- Load the Delphi project group file `PhippsAI (Delphi).groupproj` located in `installdir\distro\repo\examples\pascal`.
- Refer to the examples for more information on how to use the API.
```Delphi
uses
  PhippsAI;
    
{ ---------------------------------------------------------------------------
  This example demonstrates the process of configuring and invoking the text
  completion endpoint by providing a question and awaiting a response. The call
  operates in a blocking manner, thereby halting execution until it completes
  successfully or encounters an error. In a subsequent example, we will
  illustrate the usage of the chat endpoint in a non-blocking manner.
----------------------------------------------------------------------------- }

var
  LApi: TPhippsAIApi;
begin
  // create an api instance
  LApi := TPhippsAIApi.Create;
  try
    // init your api key, if not defined here, it will try to read it from
    // PhippsAIApiKey environment variable

    //LApi.ApiKey := 'YOUR_API_KEY';

    // init your assistant
    LApi.Assistant := 'PhippsAI, your AI assistent';

    // init your question
    LApi.Question := 'what is the Delphi language?';

    // display question
    WriteLn(CRLF+'Question: '+CRLF, LApi.Question);

    // call text completion api
    LApi.TextCompletion;

    if LApi.Success then
      // display answer on success
      WriteLn(CRLF+'Answer: '+CRLF, LApi.Answer)
    else
      // otherwise display error message
      WriteLn(CRLF+'Error: '+CRLF, LApi.Error);
  finally
    // free api instance
    LApi.Free;
  end;
end.
```

#### Media


#### Support
- <a href="https://github.com/tinyBigGAMES/PhippsAI/issues" target="_blank">Issues</a>
- <a href="https://github.com/tinyBigGAMES/PhippsAI/discussions" target="_blank">Discussions</a>
- <a href="https://github.com/tinyBigGAMES" target="_blank">Discord</a>
- <a href="https://tinybiggames.com/" target="_blank">tinyBigGAMES Homepage</a>

<p align="center">
<img src="media/Delphi.png" alt="Delphi">
</p>
<h5 align="center">

Made in Delphi :heart:
</h5>
