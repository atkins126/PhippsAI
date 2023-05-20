![PhippsAI](media/PhippsAI.png)  

[![Chat on Discord](https://img.shields.io/discord/754884471324672040.svg?logo=discord)](https://discord.gg/tPWjMwK) [![Twitter Follow](https://img.shields.io/twitter/follow/tinyBigGAMES?style=social)](https://twitter.com/tinyBigGAMES)
# PhippsAI - Your Personal AI Butler
### PhippsAI API for Delphi

Integrate with tinyBigGAMES's **PhippsAI** API seamlessly from <a href="https://www.embarcadero.com/es/products/delphi" target="_blank">Delphi</a>. 

### Beta Testers
We are looking for a limited number of beta testers for free, full access to help us test the service. If you are interested:
- Contact us at: https://tinybiggames.com/contact
- Fill out your Name and a working email and ask for beta access
- We will email your beta API key to the email entered

### Features
- Integrate Large Language Model (LLM) AI support into your applications.
- API key can be read from `PhippsAIApiKey` environment variable if defined
- Automatically sanitizes input to minimize errors
- Ability to define proxy settings
- Indie developer friendly, affordable with good performance.
- Only **$5.00US/monthly**, sponsor project for full access. Note, API key generation is a manual process at the moment. So there maybe a short delay after sign-up before receiving your key. We will however, get it out ASAP.

### Minimum Requirements 
- Windows 10
- <a href="https://www.embarcadero.com/products/delphi/starter" target="_blank">Delphi Community Edition</a>

### Usage
- Get your API Key by sponsoring this project, https://github.com/sponsors/tinyBigGAMES, we will then issues you an API key for full access as long as your sponsorship remains active.

- Define environment variable `PhippsAIApiKey` and assigned your API key. You may have to reboot your machine for it to take effect.

```Delphi
// Basic example showing how to query PhippsAI
uses
  PhippsAI;
    
var
  LApi: TPhippsAIApi;
begin
  // create an api instance
  LApi := TPhippsAIApi.Create;
  try
    // init your api key, if not defined here, it will try to read it from
    // PhippsAIApiKey environment variable
    LApi.ApiKey := 'YOUR_API_KEY';

    // init your assistant
    LApi.Assistant := 'PhippsAI, your AI assistent';

    // init your question
    LApi.Question := 'what is the Delphi language?';

    // display question
    WriteLn(LFCR+'Question: '+LFCR, LApi.Question);

    // call chat api
    LApi.Chat;

    if LApi.Success then
      // display answer on success
      WriteLn(LFCR+'Answer: '+LFCR, LApi.Answer)
    else
      // otherwise display error message
      WriteLn(LFCR+'Error: '+LFCR, LApi.Error);
  finally
    // free api instance
    LApi.Free;
  end;
end;
```
- Load the Delphi project group file **PhippsAI (Delphi).groupproj** in `installdir\distro\repo\examples\pascal`

### Media


### Support
- <a href="https://github.com/tinyBigGAMES/PhippsAI/issues" target="_blank">Issues</a>
- <a href="https://github.com/tinyBigGAMES/PhippsAI/discussions" target="_blank">Discussions</a>
- <a href="https://github.com/tinyBigGAMES" target="_blank">Discord</a>
- <a href="https://tinybiggames.com/" target="_blank">tinyBigGAMES Homepage</a>

<p align="center">
<img src="media/delphi.png" alt="Delphi">
</p>
<h5 align="center">

Made with :heart: in Delphi
</h5>
