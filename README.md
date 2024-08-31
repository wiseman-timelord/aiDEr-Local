# Aider-Local
- Status: Alpha - Under Development.

### DEVELOPMENT:
1. COmplete download of requried models. Guessing [Meta-Llama-3.1-Chat-Uncensored-GGUF](https://huggingface.co/mradermacher/Meta-Llama-3.1-Chat-Uncensored-GGUF) is the best one for 64GB System Ram. IF not, then the Hermes one.
2. Testing Ollama is working correctly with the batches.
3. Testing Running aider - Is the install complete? Are there any further issues.
-  There is also the deepseek v2 Lite gguf, in, base and instruct; somehow I am guessing an intelligent application of, the two models or the instruct model and some other chat model, and streamlining of code could be an option, but mainly somehow utilize the unlimited context on these deepseek models too?

### DESCRIPTION:
- This fork, will have drop-in files, to enhance, useability and/or performance, for non-wsl windows 10 users, working off loal models (though it may work on similar editions of windows just fine).

### FEATURES:
- The batch `Install-Setup.Bat` is for setup and install of requirements, this includes, `setup-tools` and `requirements.txt`.
- The batch `aiDEr-Offline.Bat` is for launching aider with local models on Ollama, and also includes light management of Ollama.
- The batch `aiDEr-Online.Bat` is for launching aider with online services, but is redundant/untested/archived; it may be useful to others.

### PREVIEW:
- The Launcher Main Menu...
```
========================================================================================================================
                                                      Aider Offline Launcher
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


## USAGE:
1. Copy aider from the zip to a suitable directory, ie `D:\Programs\aider-0.5x.x`.
2. The files are dropped into relevantly `D:\Programs\aider-0.5x.x` or whatever folder. 
3. Run the batch `Install-Setup.Bat`, it will for setup and install of requirements, this includes, `setup-tools` and `requirements.txt`.
4. Run The batch `aiDEr-Offline.Bat`, to launch aider with local models on Ollama, and also includes light management/configuration of Ollama.
