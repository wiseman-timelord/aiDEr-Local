# aiDEr-Local
- Its a fork, the main is [here](https://aider.chat/).
- Status: Alpha - Under Development.

### DEVELOPMENT:
1. Complete download of model - Guessing [Meta-Llama-3.1-Chat-Uncensored-GGUF](https://huggingface.co/mradermacher/Meta-Llama-3.1-Chat-Uncensored-GGUF) in Q5 is the best one for 64GB System Ram. IF not, then the Hermes one. The meta ones improve performance by a significant amount, and I am sure the hermes one does that, but add to that the fact the meta one is un-censored, hence, if there is no uncensored hermes on, then forget hermes. 
1. Python version compatibility (currently an inconsistent and incomplete upgrade between the 3 scripts) - during setup-install, if not exist then creation of `.\data` folder, then when the launcher works in either, setup, online offline, and it has not got a `.\data\persistance.txt`, then it should create one, and read it for appropriate settings for the script, in all 3 script, setup-install and in either of the batches, it should be for the version of python, but for  launcher-offline.bat then also the other relevant value for selected model, there also needs to be globals for all these, set near the top of the script including python ones, it will need to update and load to and save from, for all the important variables.
2. I would prefer if I could use the vram and system ram, and be able to run the Q6 model, but, ollama cannot do this to my knowledge. Needs investigating again, but possibly build ollama's requirements with opencl/vulkan support with overflow on system ram, or complete my model hosting software. 
2. Testing Ollama is working correctly with the batches. 
3. Testing Running aider - Is the install complete? Are there any further issues.
4. Implement code, to enable configuration and use of Huggingface Larger models, under the circumstances of repeating errors. This could auto-detect the larger versions with the nearest relating name, and just automatically use that, until the error has been solverd, or otherwise, it would have to be hardcoded to what I determine to be the best performing ~400b model at the time.
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


                                                2. Ollama Models Management
                                                         (Select A Model)

                                                3. Run Aider with Selected Model


                                                4. Run Aider with File and Model





========================================================================================================================
Selection; Program Options = 1-4, Exit Program = X:
```
- Ollama Management...
```
========================================================================================================================
                                                Ollama Model Management
------------------------------------------------------------------------------------------------------------------------





                                               Available Ollama models:

NAME                                    ID              SIZE    MODIFIED
L3-8B-Stheno-v3.2-IQ3_M-imat:latest     2c65ca6f7072    3.8 GB  3 weeks ago
qwen2_57b:latest                        9dbf41c98d9e    47 GB   2 months ago





========================================================================================================================
Selection, Select Model = S, Delete Model = D, Back To Menu = B:
```

## REQUIREMENTS:
- Windows, version 10 is the, programming and testing, platform, non WSL.
- Python v3.12, this is the default verison, that is working, but I am working on this.
 

### USAGE:
1. Copy aider from the zip to a suitable directory, ie `D:\Programs\aider-0.5x.x`.
2. The files are dropped into relevantly `D:\Programs\aider-0.5x.x` or whatever folder. 
3. Run the batch `Install-Setup.Bat`, it will for setup and install of requirements, this includes, `setup-tools` and `requirements.txt`.
4. Run The batch `aiDEr-Offline.Bat`, to launch aider with local models on Ollama, and also includes light management/configuration of Ollama.
