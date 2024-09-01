# aiDEr-Local
- Its a fork, the main is [here](https://aider.chat/).
- Status: Alpha - Under Development.

### DEVELOPMENT:
1. if the user deletes the model file that is currently selected, then it needs to, save the model to the global immediately and save the global to the `.\data\persistence.txt` upon going back to the main menu.
1. Complete download of model (see NOTATIONS section) - In the mean time we are testing with "deepseek-v2-lite-instruct" in Q8 GGUF. 
3. Testing Running aider - Is the install complete? Are there any further issues.
4. Implement code, to enable configuration and use of Huggingface Larger models, under the circumstances of repeating errors. This could auto-detect the larger versions with the nearest relating name, and just automatically use that, until the error has been solverd, or otherwise, it would have to be hardcoded to what I determine to be the best performing ~400b model at the time.
- I would prefer if I could use the vram and system ram, and be able to run slightly better models, but, ollama cannot do this to my knowledge. Needs investigating again, but possibly build ollama's requirements with opencl/vulkan support with overflow on system ram, or complete my model hosting software. 
-  There is also the deepseek v2 Lite gguf, in, base and instruct; somehow I am guessing an intelligent application of, the two models or the instruct model and some other chat model, and streamlining of code could be an option, but mainly somehow utilize the unlimited context on these deepseek models too?

### DESCRIPTION:
- This fork, will have drop-in files, to enhance, useability and/or performance, for non-wsl windows 10 users, working off local models (though it may work on similar editions of windows just fine).

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
    4. Run Ollama with, LM Studio and Files
    5. Ollama Models Management (deepseek-coder-v2-lite-instruct)

========================================================================================================================
Selection; Menu Options = 1-5, Exit Batch = X:

```
- Ollama Management...
```
========================================================================================================================
                                                Ollama Model Management
------------------------------------------------------------------------------------------------------------------------

    Available Ollama models:
NAME    ID      SIZE    MODIFIED

========================================================================================================================
Selection; Select Model = S, Delete Model = D, Back to Menu = M:
```

## REQUIREMENTS:
- Windows, version 10 is the, programming and testing, platform, non WSL.
- Python v3.12, this is the default verison, that is working, but I am working on this.
 

### USAGE:
1. Copy aider from the zip to a suitable directory, ie `D:\Programs\aider-0.5x.x`.
2. The files are dropped into relevantly `D:\Programs\aider-0.5x.x` or whatever folder. 
3. Run the batch `Install-Setup.Bat`, it will for setup and install of requirements, this includes, `setup-tools` and `requirements.txt`.
4. Ensure model is loaded in LM Studio, or otherwise that you have installed the model in Ollama (see folder .\modelfiles). 
4. Run The batch `aiDEr-Offline.Bat`, to launch aider with local models on, LM Studio or Ollama, with options to, include files or manageme Ollama models.

## NOTATION:
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
