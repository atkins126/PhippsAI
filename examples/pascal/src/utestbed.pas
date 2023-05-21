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

unit utestbed;

interface

uses
  System.SysUtils,
  System.Classes,
  PhippsAI;

procedure RunTest(const aNum: Integer);
procedure RunTests;

implementation

procedure Pause;
begin
  Write(CRLF+'Press ENTER to continue...');
  ReadLn;
end;

{ ---------------------------------------------------------------------------
  This example demonstrates the process of configuring and invoking the chat
  endpoint by providing a question and awaiting a response. The Ask call
  operates in a blocking manner, thereby halting execution until it completes
  successfully or encounters an error. In a subsequent example, we will
  illustrate the usage of the chat endpoint in a non-blocking manner.
----------------------------------------------------------------------------- }
procedure Test01;
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

    // call chat api
    LApi.Ask;

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
end;

{ ---------------------------------------------------------------------------
  This example serves as a fundamental illustration of a chatbot,
  demonstrating how to retain context using the Language Model (LM) and
  engage in a conversation. It is important to note that this example does
  not account for token limitations. As the conversation progresses and
  approaches the token limit, the LM will respond with an error message
  indicating that the input size exceeds the maximum allowable tokens. In a
  forthcoming example, we will showcase a solution for effectively managing
  this issue.
----------------------------------------------------------------------------- }
procedure Test02;
var
  LApi: TPhippsAIApi;
  LContext: TStringList;
  LPrompt: string;
  LResponse: string;
begin
  LApi := TPhippsAIApi.Create;
  try
    LContext := TStringList.Create;
    try
      // init your api key, if not defined here, it will try to read it from
      // PhippsAIApiKey environment variable

      //LApi.ApiKey := 'YOUR_API_KEY';

      // init your assistant
      LApi.Assistant := 'PhippsAI, your AI assistent';

      // display intro
      WriteLn(CRLF+'Hello, I am ', LApi.Assistant, CRLF);

      // start chat loop
      repeat
        // display question prompt and wait for input
        WriteLn('Question:');
        ReadLn(LPrompt);

        // check the promp commands: quit
        if (LPrompt = 'q') or (LPrompt = 'quit') then
          Break;

        // add prompt to context
        LContext.Add(LPrompt);

        // init the question you wish to ask
        LApi.Question := LContext.Text;

        // ask you question
        LApi.Ask;

        if LApi.Success then
          begin
            // if there is success then add answer to context
            LResponse := LApi.Answer;
            LContext.Add(LResponse);
          end
        else
          begin
            // otherwise just get the error message
            LResponse := LApi.Error;
          end;

        // display the response
        WriteLn(CRLF+CRLF+'Answer:');
        WriteLn(LResponse+CRLF);

      // continue to loop until break
      until False;

    finally
      // free context instance
      LContext.Free;
    end;
  finally
    // free api instance
    LApi.Free;
  end;
end;

procedure RunTest(const aNum: Integer);
begin
  case aNum of
    1: Test01;
    2: Test02;
  end;
end;

procedure RunTests;
begin
  RunTest(2);
  Pause;
end;

end.
