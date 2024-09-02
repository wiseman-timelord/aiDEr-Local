# aiDEr-Local
- Its a fork, the main is [here](https://aider.chat/).
- Status: Alpha - Under Development.

### DEVELOPMENT:
1. `Setup-Install.Bat` fixed soes saving the `persistence.txt` correctly. The `aiDer-Local.Bat` now needs to be tested again. 1. persistence.txt, 2. Options, 3. Launch.
2. Since upgrading to 0.54.1, have had issues with httpx, this has slowed things dramatically, issue with httpx must be investigated again.
2. Currently its version specific to `v0.54.0`, as I added some files to the setup-install, that were seemingly not covered by the installer, to ensure they actually install, however, this is only a quick-fix, and I should move the additional install to its own "version patcher", possibly batches kept in `.\patches` to ensure that the libraries install correctly for each version of aider I use, or the likes. Dont want to mess with the `requirements.txt` anyhow, its way confusing.
1. Testing aider 0.54.10 after upgrade, so far its spanners in works, as it changed a lot of dependency versions. So still having the issue of accessing the models, LM Studio was not working when tested, and in ollama aiDEr cant identify the model.
2. Modelfile installer not workig. Its not identifying the model correctly through ollama.
2. LM Studio is not working...
```
Running Aider with LM Studio model (DeepSeek-Coder-V2-Lite-Instruct)...
No git repo found, create one to track aider's changes (recommended)? (Y)es/(N)o [Yes]: n
Model DeepSeek-Coder-V2-Lite-Instruct: Unknown which environment variables are required.
Model DeepSeek-Coder-V2-Lite-Instruct: Unknown context window size and costs, using sane defaults.
Did you mean one of these?
- ollama/deepseek-coder-v2-lite-instruct
For more info, see: https://aider.chat/docs/llms/warnings.html


Aider v0.54.0
Model: DeepSeek-Coder-V2-Lite-Instruct with diff edit format
Git repo: none
Repo-map: disabled
Use /help <question> for help, run "aider --help" to see cmd line args
────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
diff> make me a pacman game with a batch to run it, put the files in .\working

BadRequestError: litellm.BadRequestError: LLM Provider NOT provided. Pass in the LLM provider you are trying to call.
You passed model=DeepSeek-Coder-V2-Lite-Instruct
 Pass model as E.g. For 'Huggingface' inference endpoints pass in `completion(model='huggingface/starcoder',..)` Learn
more: https://docs.litellm.ai/docs/providers
```
3. Complete download of model (see NOTATIONS section) - In the mean time we are testing with "deepseek-v2-lite-instruct" in Q8 GGUF. 
4. running with file(s) needs investigating.
4. Testing Running aider - Is the install complete? Are there any further issues.
4. Implement code, to enable configuration and use of Huggingface Larger models, under the circumstances of repeating errors. This could auto-detect the larger versions with the nearest relating name, and just automatically use that, until the error has been solverd, or otherwise, it would have to be hardcoded to what I determine to be the best performing ~400b model at the time.
- Would prefer if I could use the vram and system ram, and be able to run slightly better models, but, ollama cannot do this to my knowledge. Needs investigating again, but possibly build ollama's requirements with opencl/vulkan support with overflow on system ram, or complete my model hosting software. 
-  There is also the deepseek v2 Lite gguf, in, base and instruct; somehow I am guessing an intelligent application of, the two models or the instruct model and some other chat model, and streamlining of code could be an option, but mainly somehow utilize the unlimited context on these deepseek models too?

### DESCRIPTION:
- This fork, will have drop-in files for aider, to enhance, useability and/or performance, for non-wsl windows 10 users, working off local models (though it may work on similar editions of windows just fine). 

### FEATURES:
- The batch `Install-Setup.Bat` - for setup and install of requirements, this includes, `setup-tools` and `requirements.txt`.
- The batch `aiDEr-local.Bat` - for launching aider with local models on, Ollama and LM Stuio, and also includes some management of Ollama.
- The folder `modelfiles` - contains batches and modelfiles, to simplify/foolproof the processes of installing those specific models to ollama. 

### PREVIEW:
- The Launcher Main Menu (testing LM Studio)...
```
========================================================================================================================
                                                     Aider Local Launcher
------------------------------------------------------------------------------------------------------------------------


    1. Run Aider with LM Studio

    2. Run Aider with, LM Studio and Files

    3. Run Ollama with Selected Model

    4. Run Ollama with, Selected Model and Files

    5. Manage Ollama Settings - M: DeepSeek-Coder-V2-Lite-Instruct, T: 20


========================================================================================================================
Selection; Menu Options = 1-5, Exit Batch = X:
```
- Essential Management of Ollama...
```
========================================================================================================================
                                               Ollama Settings Management
========================================================================================================================


    Available Ollama models:
NAME                                    ID              SIZE    MODIFIED
DeepSeek-Coder-V2-Lite-Instruct:latest  a5112c0daff8    17 GB   2 hours ago

    Current Model Used:
DeepSeek-Coder-V2-Lite-Instruct

    CPU Threads Available:
NumberOfLogicalProcessors
24

    Current Threads Used:
21


========================================================================================================================
Selection (Select Model = S, Set Threads = T, Back to Menu = B):
```
- The `Setup-Install.Bat` Output...
```
========================================================================================================================
                                                     Setup-Installer
========================================================================================================================

Python 312 found at: C:\Program Files\Python312\python.exe
Using pip from: C:\Program Files\Python312\\Scripts\pip.exe

Ensuring setuptools and wheel are properly installed...
Collecting setuptools
  Using cached setuptools-74.0.0-py3-none-any.whl.metadata (6.7 kB)
...
Successfully installed setuptools-74.0.0 wheel-0.44.0
Setuptools and wheel are installed.

Installing Requirements...
Requirement already satisfied: aiohappyeyeballs==2.4.0 in c:\program files\python312\lib\site-packages (from -r requirements.txt (line 7)) (2.4.0)
...
Requirement already satisfied: colorama in c:\users\mastar\appdata\roaming\python\python312\site-packages (from click==8.1.7->-r requirements.txt (line 39)) (0.4.6)
Requirements installed successfully.

Verifying installation...
aider-chat 0.54.10 has requirement httpx==0.27.2, but you have httpx 0.27.0.
...
aider-chat 0.54.10 has requirement zipp==3.20.1, but you have zipp 3.20.0.
Warning: Some conflicts may still exist. Please review the output above.

========================================================================================================================
All processes finished.
Press any key to continue . . .
```

## REQUIREMENTS:
- Windows v7-v11?? - version 10 is the, programming and testing, platform, and thats non-WSL.
- Python v3.9-3.12 - Now working with whatever version of Python is specified by the user during setup.

### USAGE:
1. Copy aider from the zip to a suitable directory, ie `D:\Programs\aider-0.5x.x`.
2. The files are dropped into relevantly `D:\Programs\aider-0.5x.x` or whatever folder. 
3. Run the batch `Install-Setup.Bat`, it will for setup and install of requirements, this includes, `setup-tools` and `requirements.txt`.
4. Ensure model is loaded in LM Studio, or otherwise that you have installed the model in Ollama (see folder .\modelfiles). 
5. Run The batch `aiDEr-Offline.Bat`, to, configure models/threads, and launch aider with, LM Studio or Ollama, with options to include files.
- When selecting model, you would copy and paste, for example `DeepSeek-Coder-V2-Lite-Instruct` not `DeepSeek-Coder-V2-Lite-Instruct:latest`. I think.
- As you can tell from the threads settings, its currently for CPU users but on ollama, so you may want to set it to `0` (auto/default), or you will have to use LM Studio for GPU accelleration.
- You can always put threads on "Auto" by selecting `0`, where Ollama is managing the threads.

## NOTATION:
- `Claude_Sonnet: there isn't any specific sanitization or validation for the number of threads entered`, hence for GPUs you are able able to specify more threads, which should relate to how many shaders there are, but what would I know I have a AMD RX 470, but if you can donate on kofi, maybe I will have that, AMD RX 7600 or GeForce RTX 4060, a little sooner, and these things can be known.
- Did notice that the Deepseek v2 GGUF would not load at a context higher than 8192 in LM Studio, so, these are the settings for Ollama, for now in the relating modelfile installer.
- Whats the best model for aider?? Apparently Deepseek Coder Light Instruct in 16b is as good as llama 3 instruct 70b, but they are the top dogs (Guessing [Meta-Llama-3.1-Chat-Uncensored-GGUF](https://huggingface.co/mradermacher/Meta-Llama-3.1-Chat-Uncensored-GGUF) in Q5 is the best one for 64GB System Ram. The meta rounds off its abilities, and uncensored supposedly more intelligent, and its 3.1 not 3.0)... 
```
                    Code Generation
          #TP 	#AP 	HumanEval 	MBPP+ 	LiveCodeBench 	USACO							
CodeStral                      22B 	22B 	78.1 	68.2 	31.0 	4.6
DeepSeek-Coder-Instruct      33B 	33B 	79.3 	70.1 	22.5 	4.2
Llama3-Instruct                70B 	70B 	81.1 	68.8 	28.7 	3.3
DeepSeek-Coder-V2-Lite-Instruct    16B 	2.4B 	81.1 	68.8 	24.3 	6.5
DeepSeek-Coder-V2-Instruct    236B 	21B 	90.2 	76.2 	43.4 	12.1
```
- issues with incorrectly recognized model file in ollama, when running aider...
```
Model ollama/deepseek-v2-lite-instruct: Unknown context window size and costs, using sane defaults.
Did you mean one of these?
- ollama/deepseek-coder-v2-instruct
- ollama/deepseek-coder-v2-lite-instruct
```
...solution, ensure model is installed with correct reference...
```
ollama create deepSeek-coder-v2-lite-instruct -f Modelfile
```
