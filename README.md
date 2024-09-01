# aiDEr-Local
- Its a fork, the main is [here](https://aider.chat/).
- Status: Alpha - Under Development.

### DEVELOPMENT:
1. Complete download of model - Guessing [Meta-Llama-3.1-Chat-Uncensored-GGUF](https://huggingface.co/mradermacher/Meta-Llama-3.1-Chat-Uncensored-GGUF) in Q5 is the best one for 64GB System Ram. The meta ones improve performance by rounding off its abilities, and uncensored supposedly more intelligent. In the mean time we are testing with "deepseek-v2-lite-instruct" in Q8 GGUF. I found out it must have the correctly named file, which means more downloading, and I still cant test properly, unless I incorrectly name the file while downloading one of the the other ones....
```
Model ollama/deepseek-v2-lite-instruct: Unknown context window size and costs, using sane defaults.
Did you mean one of these?
- ollama/deepseek-coder-v2-instruct
- ollama/deepseek-coder-v2-lite-instruct
For more info, see: https://aider.chat/docs/llms/warnings.html
```
3. Testing Running aider - Is the install complete? Are there any further issues.
4. Implement code, to enable configuration and use of Huggingface Larger models, under the circumstances of repeating errors. This could auto-detect the larger versions with the nearest relating name, and just automatically use that, until the error has been solverd, or otherwise, it would have to be hardcoded to what I determine to be the best performing ~400b model at the time.
- I would prefer if I could use the vram and system ram, and be able to run slightly better models, but, ollama cannot do this to my knowledge. Needs investigating again, but possibly build ollama's requirements with opencl/vulkan support with overflow on system ram, or complete my model hosting software. 
-  There is also the deepseek v2 Lite gguf, in, base and instruct; somehow I am guessing an intelligent application of, the two models or the instruct model and some other chat model, and streamlining of code could be an option, but mainly somehow utilize the unlimited context on these deepseek models too?

### DESCRIPTION:
- This fork, will have drop-in files, to enhance, useability and/or performance, for non-wsl windows 10 users, working off local models (though it may work on similar editions of windows just fine).

### FEATURES:
- The batch `Install-Setup.Bat` is for setup and install of requirements, this includes, `setup-tools` and `requirements.txt`.
- The batch `aiDEr-Offline.Bat` is for launching aider with local models on Ollama, and also includes light management of Ollama.
- The batch `aiDEr-Online.Bat` is for launching aider with online services, but is redundant/untested/archived; it may be useful to others.

### PREVIEW:
- The Launcher Main Menu...
```
========================================================================================================================
                                                      Aider Local Launcher
------------------------------------------------------------------------------------------------------------------------

    1. Start Ollama Server Normally
    2. Ollama Models Management (No_Model_Selected)
    3. Run Aider with Selected Model
    4. Run Aider with File and Model

========================================================================================================================
Selection; Menu Options = 1-4, Exit Batch = X:

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
4. Run The batch `aiDEr-Offline.Bat`, to launch aider with local models on Ollama, and also includes light management/configuration of Ollama.

## NOTATION:
- Whats the best model for aider?? Apparently Deepseek Coder Light Instruct in 16b is as good as llama 3 instruct 70b, but they are the top dogs...
```
                    Code Generation
          #TP 	#AP 	HumanEval 	MBPP+ 	LiveCodeBench 	USACO
Closed-Source Models 						
Gemini-1.5-Pro       	- 	- 	83.5 	74.6 	34.1 	4.9
Claude-3-Opus 	       - 	- 	84.2 	72.0 	34.6 	7.8
GPT-4-Turbo-1106 	     - 	- 	87.8 	69.3 	37.1 	11.1
GPT-4-Turbo-0409      - 	- 	88.2 	72.2 	45.7 	12.3
GPT-4o-0513 	         - 	- 	91.0 	73.5 	43.4 	18.8
Open-Source Models 						
CodeStral 	22B 	22B 	78.1 	68.2 	31.0 	4.6
DeepSeek-Coder-Instruct 	33B 	33B 	79.3 	70.1 	22.5 	4.2
Llama3-Instruct 	70B 	70B 	81.1 	68.8 	28.7 	3.3
DeepSeek-Coder-V2-Lite-Instruct 	16B 	2.4B 	81.1 	68.8 	24.3 	6.5
DeepSeek-Coder-V2-Instruct 	236B 	21B 	90.2 	76.2 	43.4 	12.1
```
