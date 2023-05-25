(****************************************************************************

@@@@@@@@@@@@%+=*%@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@%%%%%%%###%@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@%%@***##**#%%%%%%@%@@@@@@@@@%%@@@@@@@@
%%%%%%%%%%##*::=++++*****##%%@@%@%%%%@%%%@%
%%%%%%%%%@#-:. :=*=::+*#+#*#*##%%%%%%%%%%%%
%%%%%%%%%%#::. .... .++-.:=***+*%%####%%%%%
%%%%%%%%%%%+-.......=++=--=++=+*#####*####%
%%%%%%%%%%%%%+....::=++==+**##***#***++++*#
%%%%%%%%%%%%%#:...-+##******###############
%%%%%%%%%%%%%%*. ..:-==+**##%%%%%%%%%%%#%%%
%%%%%%%@%%%%%%%....-=+**####%%%%%%%%%%%%%%%
@@%%%%%%%%%%%%+..::=*%####+*%%%%%%%%%%%%%%%
%%%%%%%%%%%#*=-  .-+*##+-:.+#%%%%@@%%%%%%@@
%%%%%%%###+=-==  ..-**+===-+##%%%%%%%%@@@@@
%%###****=-:+#+. .=*%#+=--:=#%%%%%%%%%%%@@@
%+++***+--=###*: :++#*:.. .=%%%%#%%###%%%%@
+-###%%*=*#%%**+.-*+#+....:*%%%%%%%%%%%%%%@
:+%@#%*=#%%%#**%=*#*#+...:*%%%%%%%##%%%%%%@
:%#@#%#=%%%#***@%###%*::-*%%%%%%%%%%@%%@@%%
-%%@#%%*+%%####@@@%%%#==#@%%@%%%%%%@@@@@@%@
-#@%#%%#*#%%%%#@%@@@%%#%@@%@@%@%@%@@@@@@@%@
 ___  _     _                    _    ___ ™
| _ \| |_  (_) _ __  _ __  ___  /_\  |_ _|
|  _/| ' \ | || '_ \| '_ \(_-< / _ \  | |
|_|  |_||_||_|| .__/| .__//__//_/ \_\|___|
              |_|   |_|

        Your Personal AI Butler

Copyright © 2023-present tinyBigGAMES™ LLC
All Rights Reserved.

Website: https://tinybiggames.com
Email  : support@tinybiggames.com

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software in
   a product, an acknowledgment in the product documentation would be
   appreciated but is not required.

2. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

3. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in
   the documentation and/or other materials provided with the
   distribution.

4. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived
   from this software without specific prior written permission.

5. All video, audio, graphics and other content accessed through the
   software in this distro is the property of the applicable content owner
   and may be protected by applicable copyright law. This License gives
   Customer no rights to such content, and Company disclaims any liability
   for misuse of content.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
*****************************************************************************)

unit PhippsAI;

interface

uses
  System.Generics.Collections,
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.Net.URLClient,
  System.Net.HttpClient;

const
  CR = #10;
  LF = #13;
  CRLF = CR+LF;

  {$IFDEF PHIPPSAI_LOCAL}
  CBaseUrl = 'http://127.0.0.1:9000/api/v1';
  {$ELSE}
  CBaseUrl = 'https://phippsai.com/api/v1';
  {$ENDIF}

  { API key environment variable }
  CEnvVarApiKey = 'PhippsAIApiKey';

  { Summary Prompts }
  CChatSummaryPrompt =
    'Please provide a comprehensive summary of this conversation? The summary ' +
    'should cover all the key points and main ideas presented in the original ' +
    'text, while also condensing the information into a concise and ' +
    'easy-to-understand format. Please ensure that the summary includes relevant ' +
    'details and examples that support the main ideas, while avoiding any ' +
    'unnecessary information or repetition. To ensure accuracy, please read the ' +
    'text carefully and pay attention to any nuances or complexities in the ' +
    'language. The length of the summary should be appropriate for the length ' +
    'and complexity of the original text, providing a clear and accurate ' +
    'overview without omitting any important information. Additionally, the ' +
    'summary should avoid any personal biases or interpretations and remain ' +
    'objective and factual throughout.';

  CTextSummaryPrompt =
    'Please create a concise summery of the following text';

type
  { TBaseObject }
  TBaseObject = class
  public
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  { TPhippsAIApi }
  TPhippsAIApi = class
  protected
    FApiKey: string;
    FSuccess: Boolean;
    FError: string;
    FQuestion: string;
    FAnswer: string;
    FAssistant: string;
    FProxy: TProxySettings;
    function  SanitizeToJson(const aText: string): string;
    function  SanitizeFromJson(const aText: string): string;
    procedure SetApiKey(const AValue: string);
    procedure SetAssistant(const AValue: string);
    procedure SetQuestion(const AValue: string);
  public
    property ApiKey: string read FApiKey write SetApiKey;
    property Success: Boolean read FSuccess;
    property Error: string read FError;
    property Assistant: string read FAssistant write SetAssistant;
    property Question: string read FQuestion write SetQuestion;
    property Answer: string read FAnswer;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure SetProxy(const aHost: string; aPort: Integer; const aUserName: string = ''; const aPassword: string = ''; const AScheme: string = '');
    procedure ChatCompletion;
    procedure TextCompletion;
    function SummarizeText(const AText: string; const ANumSentences: Integer): string;
    function TokenCount(const AText: string): Integer;
    function TextToSpeech(const AText, ALanguage: string): TStream;
  end;

{ Routines }
function FindJsonValue(const AJson: TJsonObject; const APath: string): TJSONValue;

implementation

{ Routines }
function FindJsonValue(const AJson: TJsonObject; const APath: string): TJSONValue;
var
  LParser: TJSONPathParser;
  LCurrentValue: TJSONValue;
begin
  Result := nil;
  if APath = '' then Exit;

  LParser := TJSONPathParser.Create(APath);
  LCurrentValue := AJson;

  while not LParser.IsEof do
  begin
    case LParser.NextToken of

      TJSONPathParser.TToken.Name:
      begin
        if LCurrentValue.ClassType = TJSONObject then
          begin
            LCurrentValue := TJSONObject(LCurrentValue).Values[LParser.TokenName];
            if LCurrentValue = nil then Exit;
          end
        else
          Exit;
      end;

      TJSONPathParser.TToken.ArrayIndex:
      begin
        if LCurrentValue.ClassType = TJSONArray then
          if LParser.TokenArrayIndex < TJSONArray(LCurrentValue).Count then
            LCurrentValue := TJSONArray(LCurrentValue).Items[LParser.TokenArrayIndex]
          else
            Exit
        else
          Exit;
      end;

      TJSONPathParser.TToken.Error,
      TJSONPathParser.TToken.Undefined:
      begin
        Exit;
      end;

      TJSONPathParser.TToken.Eof: ;
    end;
  end;

  Result := LCurrentValue;
end;

{ TBaseObject }
constructor TBaseObject.Create;
begin
  inherited;
end;

destructor TBaseObject.Destroy;
begin
  inherited;
end;

{ TPhippsAIApi }
function  TPhippsAIApi.SanitizeToJson(const aText: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(aText) do
  begin
    case aText[i] of
      '\': Result := Result + '\\';
      '"': Result := Result + '\"';
      '/': Result := Result + '\/';
      #8:  Result := Result + '\b';
      #9:  Result := Result + '\t';
      #10: Result := Result + '\n';
      #12: Result := Result + '\f';
      #13: Result := Result + '\r';
      else
        Result := Result + aText[i];
    end;
  end;
  Result := Result;
end;

function  TPhippsAIApi.SanitizeFromJson(const aText: string): string;
var
  LText: string;
begin
  LText := aText;
  LText := LText.Replace('\n', #10);
  LText := LText.Replace('\r', #13);
  LText := LText.Replace('\b', #8);
  LText := LText.Replace('\t', #9);
  LText := LText.Replace('\f', #12);
  LText := LText.Replace('\/', '/');
  LText := LText.Replace('\"', '"');
  LText := LText.Replace('\\', '\');
  Result := LText;
end;

procedure TPhippsAIApi.SetApiKey(const AValue: string);
begin
  if aValue.IsEmpty then
    // if value is empty try to get api key from environment variable
    FApiKey := GetEnvironmentVariable(CEnvVarApiKey)
  else
    // otherwise set api key to value
    FApiKey := aValue;
end;

procedure TPhippsAIApi.SetAssistant(const AValue: string);
var
  LAssistant: string;
begin
  // set assistant to empty
  LAssistant := '';

  // if value is empty return
  if aValue.IsEmpty then Exit;

  // save assistant value
  LAssistant := aValue;

  // sanitize input
  LAssistant := LAssistant.Trim;
  LAssistant := LAssistant.Replace(#0, '');
  LAssistant := SanitizeToJson(LAssistant);

  // save assistant prompt
  FAssistant := LAssistant;
end;

procedure TPhippsAIApi.SetQuestion(const AValue: string);
var
  LQuestion: string;
begin
  // set question to empty
  LQuestion := '';

  // if value is empty return
  if aValue.IsEmpty then Exit;

  // save question value
  LQuestion := aValue;

  // sanitize input
  LQuestion := LQuestion.Trim;
  LQuestion := LQuestion.Replace(#0, '');
  LQuestion := SanitizeToJson(LQuestion);

  // save question prompt
  FQuestion := LQuestion;
end;

constructor TPhippsAIApi.Create;
begin
  inherited;
  // set empty apikey, will try to read from environment variable
  ApiKey := '';
end;

destructor TPhippsAIApi.Destroy;
begin
  inherited;
end;

procedure TPhippsAIApi.SetProxy(const aHost: string; aPort: Integer; const aUserName: string = ''; const aPassword: string = ''; const AScheme: string = '');
begin
  FProxy.Create(aHost, aPort, aUserName, aPassword, aScheme);
end;

procedure TPhippsAIApi.ChatCompletion;
var
  LClient: THTTPClient;
  LResponse: IHTTPResponse;
  LPostData: TStringStream;
  LJson: TJsonObject;
  LString: string;
  LQuestion: string;
begin
  // clear error string
  FError := '';

  // clear status
  FSuccess := False;

  // validate for empty apikey
  if FApiKey.IsEmpty then
  begin
    FError := 'API key was empty';
    Exit;
  end;

  // validate for empty question
  if FQuestion.IsEmpty then
  begin
    FError := 'Question was empty';
    Exit;
  end;

  try
    // create a http client object
    LClient := THTTPClient.Create;
    try
      // init proxy
      LClient.ProxySettings := FProxy;

      // set header content type
      LClient.CustomHeaders['Content-Type'] := 'application/json';

      // create json object
      LJson := TJsonObject.Create;
      try
        // init endpoint data
        LJson.AddPair('apikey', FApiKey);
        LQuestion := FAssistant + ' : ' + FQuestion;
        LQuestion := LQuestion.Trim;
        LJson.AddPair('question', LQuestion);

        // save the json string
        LString := LJson.ToString;
      finally
        LJson.Free;
      end;

    // create a post data stream
    LPostData := TStringStream.Create(LString, TEncoding.UTF8);
    try
      // call the chat endpoint
      LResponse := LClient.Post(CBaseUrl+'/chat', LPostData);
    finally
      // free post data stream object
      LPostData.Free;
    end;

    // check for OK response status code
    if LResponse.StatusCode = 200 then
      begin
        // create json object from content
        LJson := TJsonObject.ParseJSONValue(LResponse.ContentAsString) as TJsonObject;
        try
          // save the response data
          FSuccess := FindJsonValue(LJson, 'success').Value.ToBoolean;
          FError := FindJsonValue(LJson, 'error').Value;
          Question := FindJsonValue(LJson, 'question').Value;
          FAnswer := SanitizeFromJson(FindJsonValue(LJson, 'answer').Value);
        finally
          // free json object
          LJson.Free;
        end;
      end
    else
      begin
        // we did not get a OK response so save the error
        FError := Format('HTTP response code %d: %s', [LResponse.StatusCode, LResponse.StatusText]);
      end;
    finally
      // free http client object
      LClient.Free;
    end;
  except
    on E: Exception do
    begin
      // we got an exception, save as error
      FError := E.Message;
    end;
  end;
end;

procedure TPhippsAIApi.TextCompletion;
var
  LClient: THTTPClient;
  LResponse: IHTTPResponse;
  LPostData: TStringStream;
  LJson: TJsonObject;
  LString: string;
  LQuestion: string;
begin
  // clear error string
  FError := '';

  // clear status
  FSuccess := False;

  // validate for empty apikey
  if FApiKey.IsEmpty then
  begin
    FError := 'API key was empty';
    Exit;
  end;

  // validate for empty question
  if FQuestion.IsEmpty then
  begin
    FError := 'Question was empty';
    Exit;
  end;

  try
    // create a http client object
    LClient := THTTPClient.Create;
    try
      // init proxy
      LClient.ProxySettings := FProxy;

      // set header content type
      LClient.CustomHeaders['Content-Type'] := 'application/json';

      // create json object
      LJson := TJsonObject.Create;
      try
        // init endpoint data
        LJson.AddPair('apikey', FApiKey);
        LQuestion := FAssistant + ' : ' + FQuestion;
        LQuestion := LQuestion.Trim;
        LJson.AddPair('question', LQuestion);

        // save the json string
        LString := LJson.ToString;
      finally
        LJson.Free;
      end;

    // create a post data stream
    LPostData := TStringStream.Create(LString, TEncoding.UTF8);
    try
      // call the chat endpoint
      LResponse := LClient.Post(CBaseUrl+'/text', LPostData);
    finally
      // free post data stream object
      LPostData.Free;
    end;

    // check for OK response status code
    if LResponse.StatusCode = 200 then
      begin
        // create json object from content
        LJson := TJsonObject.ParseJSONValue(LResponse.ContentAsString) as TJsonObject;
        try
          // save the response data
          FSuccess := FindJsonValue(LJson, 'success').Value.ToBoolean;
          FError := FindJsonValue(LJson, 'error').Value;
          Question := FindJsonValue(LJson, 'question').Value;
          FAnswer := SanitizeFromJson(FindJsonValue(LJson, 'answer').Value);
        finally
          // free json object
          LJson.Free;
        end;
      end
    else
      begin
        // we did not get a OK response so save the error
        FError := Format('HTTP response code %d: %s', [LResponse.StatusCode, LResponse.StatusText]);
      end;
    finally
      // free http client object
      LClient.Free;
    end;
  except
    on E: Exception do
    begin
      // we got an exception, save as error
      FError := E.Message;
    end;
  end;
end;

function TPhippsAIApi.SummarizeText(const AText: string; const ANumSentences: Integer): string;
var
  LApi: TPhippsAIApi;
  LNumSentences: Integer;
begin
  // set return to empty string by default
  Result := '';

  // check for empty text
  if AText.IsEmpty then Exit;

  // init number of sentences to summerize down to
  LNumSentences := ANumSentences;

  // validate sentence range
  if LNumSentences < 0 then
    LNumSentences := 1;

  // create a api instance
  LApi := TPhippsAIApi.Create;
  try
    // use same setting as parent instance
    LApi.ApiKey := FApiKey;
    LApi.FProxy := FProxy;

    // set the summary prompt
    LApi.Assistant := Format('%s down to no more than %d sentences', [CTextSummaryPrompt, LNumSentences]);

    // set text to be summarized
    LApi.Question := aText;

    // use the text completion endpoint
    LApi.TextCompletion;

    // return answer on sugges
    if LApi.Success then
      Result := LApi.Answer
    else
      // otherwise return error
      Result := LApi.Error;
  finally
    // free api instance
    LApi.Free;
  end;

end;

function TPhippsAIApi.TokenCount(const AText: string): Integer;
var
  LClient: THTTPClient;
  LResponse: IHTTPResponse;
  LPostData: TStringStream;
  LJson: TJsonObject;
  LString: string;
begin
  Result := 0;

  // clear error string
  FError := '';

  // clear status
  FSuccess := False;

  // validate for empty apikey
  if FApiKey.IsEmpty then
  begin
    FError := 'API key was empty';
    Exit;
  end;

  // validate for empty question
  if AText.IsEmpty then
  begin
    FError := 'Text was empty';
    Exit;
  end;

  try
    // create a http client object
    LClient := THTTPClient.Create;
    try
      // init proxy
      LClient.ProxySettings := FProxy;

      // set header content type
      LClient.CustomHeaders['Content-Type'] := 'application/json';

      // create json object
      LJson := TJsonObject.Create;
      try
        // init endpoint data
        LJson.AddPair('apikey', FApiKey);
        LJson.AddPair('content', AText);

        // save the json string
        LString := LJson.ToString;
      finally
        LJson.Free;
      end;

    // create a post data stream
    LPostData := TStringStream.Create(LString, TEncoding.UTF8);
    try
      // call the chat endpoint
      LResponse := LClient.Post(CBaseUrl+'/tokens', LPostData);
    finally
      // free post data stream object
      LPostData.Free;
    end;

    // check for OK response status code
    if LResponse.StatusCode = 200 then
      begin
        // create json object from content
        LJson := TJsonObject.ParseJSONValue(LResponse.ContentAsString) as TJsonObject;
        try
          // save the response data
          FSuccess := FindJsonValue(LJson, 'success').Value.ToBoolean;
          FError := FindJsonValue(LJson, 'message').Value;
          Result := FindJsonValue(LJson, 'count').Value.ToInteger
        finally
          // free json object
          LJson.Free;
        end;
      end
    else
      begin
        // we did not get a OK response so save the error
        FError := Format('HTTP response code %d: %s', [LResponse.StatusCode, LResponse.StatusText]);
      end;
    finally
      // free http client object
      LClient.Free;
    end;
  except
    on E: Exception do
    begin
      // we got an exception, save as error
      FError := E.Message;
    end;
  end;
end;

function TPhippsAIApi.TextToSpeech(const AText, ALanguage: string): TStream;
var
  LClient: THTTPClient;
  LResponse: IHTTPResponse;
  LPostData: TStringStream;
  LJson: TJsonObject;
  LString: string;
begin
  Result := nil;

  // clear error string
  FError := '';

  // clear status
  FSuccess := False;

  // validate for empty apikey
  if FApiKey.IsEmpty then
  begin
    FError := 'API key was empty';
    Exit;
  end;

  // validate for empty question
  if AText.IsEmpty then
  begin
    FError := 'Text was empty';
    Exit;
  end;

  try
    // create a http client object
    LClient := THTTPClient.Create;
    try
      // init proxy
      LClient.ProxySettings := FProxy;

      // set header content type
      LClient.CustomHeaders['Content-Type'] := 'application/json';

      // create json object
      LJson := TJsonObject.Create;
      try
        // init endpoint data
        LJson.AddPair('apikey', FApiKey);
        LJson.AddPair('text', AText);
        LJson.AddPair('lang', ALanguage);

        // save the json string
        LString := LJson.ToString;
      finally
        LJson.Free;
      end;

    // create a post data stream
    LPostData := TStringStream.Create(LString, TEncoding.UTF8);
    try
      // call the chat endpoint
      LResponse := LClient.Post(CBaseUrl+'/tts', LPostData);
    finally
      // free post data stream object
      LPostData.Free;
    end;

    // check for OK response status code
    if LResponse.StatusCode = 200 then
      begin
        Result := TMemoryStream.Create;
        Result.CopyFrom(LResponse.ContentStream);
        FSuccess := True;
        FError := '';
      end
    else
      begin
        // create json object from content
        LJson := TJsonObject.ParseJSONValue(LResponse.ContentAsString) as TJsonObject;
        try
          // save the response data
          FSuccess := FindJsonValue(LJson, 'success').Value.ToBoolean;
          FError := FindJsonValue(LJson, 'message').Value;
        finally
          // free json object
          LJson.Free;
        end;
      end;
    finally
      // free http client object
      LClient.Free;
    end;
  except
    on E: Exception do
    begin
      // we got an exception, save as error
      FError := E.Message;
    end;
  end;
end;

initialization
  ReportMemoryLeaksOnShutdown := True;

finalization

end.
