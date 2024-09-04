# aiDEr-Local
- Its a fork, the main is, [here](https://github.com/paul-gauthier/aider) or [here](https://aider.chat/).
- Fork Status: Beta - Tested and working, further development planned.

### DESCRIPTION:
- The aiDEr-Local project includes a set of batch scripts designed to facilitate the setup and execution of the aiDEr application in a local environment. The aiDEr-Local.Bat script serves as a user-friendly launcher, providing options to run the application with various configurations, including different models and file inputs. It ensures that settings are preserved across sessions through a persistence mechanism, enabling consistent operation without requiring reconfiguration. The accompanying Install-Setup.Bat script automates the environment setup, detecting the necessary Python installation, installing dependencies, and ensuring that the environment is properly configured. Together, these scripts provide a streamlined and reliable workflow for managing and running the aiDEr application locally.

### FEATURES:
- Enforces administrator privileges to ensure proper execution and environment control.
- Provides an interactive menu for selecting different modes to run the aiDEr application.
- Supports model management, allowing users to select, delete, and configure models for Ollama.
- Handles configuration persistence through a persistence.txt file to save and load settings across sessions.
- Detects and configures the Python environment, including automatic installation of required packages.
- Allows for the execution of aiDEr with or without file inputs, adapting to various use cases.
- Includes error handling and user prompts for guidance during setup and execution.
- Verifies and installs essential Python packages, such as setuptools and wheel, to ensure a stable environment.
- If all that has'nee made you moist, it also has the ability to select the folder that contains your files.

### PREVIEW:
- The `aiDEr-Local.Bat` Main Menu...
```
========================================================================================================================
                                                   AiDEr-Local Launcher
========================================================================================================================


    1. Run Aider with Ollama and Selected Model

    2. Run Aider with Ollama and Selected Model and Files

    3. Run Aider with Ollama and Selected Model and Files from Folder

    4. Manage Ollama Settings


------------------------------------------------------------------------------------------------------------------------

    * Model Selected:
DeepSeek-Coder-V2-Lite-Instruct:latest

    * Threads Used:
0

    * Python Location:
C:\Users\Mastar\AppData\Local\Programs\Python\Python312\python.exe

========================================================================================================================
Selection; Menu Options = 1-4, Exit Batch = X:

```
- The `aiDEr-Local.Bat` Running with Ollama...
```
========================================================================================================================
                                                     aiDEr-Local
========================================================================================================================

Starting Ollama server...
Setting API Base...
Running Aider with Ollama model...
No git repo found, create one to track aider's changes (recommended)? (Y)es/(N)o [Yes]: n
Model ollama/DeepSeek-Coder-V2-Lite-Instruct: Unknown context window size and costs, using sane defaults.
Did you mean one of these?
- ollama/deepseek-coder-v2-lite-instruct
For more info, see: https://aider.chat/docs/llms/warnings.html


Aider v0.54.0
Model: ollama/DeepSeek-Coder-V2-Lite-Instruct with whole edit format
Git repo: none
Repo-map: disabled
Use /help <question> for help, run "aider --help" to see cmd line args
────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
> make me a maze game.



```
- The `Setup-Install.Bat` Main Menu...
```
========================================================================================================================
                                                     Setup-Installer
========================================================================================================================


    1. Re-Install Setup Tools

    2. Install `.\Requirements.Txt`

    3. ModelFile Management


------------------------------------------------------------------------------------------------------------------------


    * Admin Status:
Administrator

    * Working Folder:
D:\ProgsOthers\aiDEr-Local\aider-0.54.0

    * Python Location:
C:\Users\**UserName**\AppData\Local\Programs\Python\Python312\python.exe


========================================================================================================================
Selection; Menu Options = 1-3, Exit Batch = X:

```

## REQUIREMENTS:
- Windows v7-v11?? - version 10 is the, programming and testing, platform, and thats non-WSL.
- Python v3.9-3.12 - USes whatever Python version is specified by the user in `Install-Setup.Bat`
- Aider v0.54.0 - The newer versions dont popup the Ollama shell, and then aider has streaming issues. 

### USAGE: 
1. Even though My batches will detect the location of Python, I do notice that `aider` is unable to be used with python in `Program Files`, so do NOT install python for all users or `aider` will have issues.
2. Copy aider from the zip to a suitable directory, ie `D:\Programs\aider-0.5x.x`.
3. The files are dropped into relevantly `D:\Programs\aider-0.5x.x` or whatever folder. 
4. Run the batch `Install-Setup.Bat`, it will for setup and install of requirements, this includes, `setup-tools` and `requirements.txt`.
5. Ensure model is loaded in LM Studio, or otherwise that you have installed the model in Ollama (see folder .\modelfiles). 
6. Run The batch `aiDEr-Offline.Bat`, to, configure models/threads, and launch aider with, LM Studio or Ollama, with options to include files.

### NOTATION:
- If you have issues with `No filename provided before ``` in file listing`, then ensure to specify the files (albeit blank ones) at launch, I also found that when I .
- The batch located at `.\tools\Extract-Aider.Bat`, will extract aider zips in its own directory to an appropriate folder, using 7z installed in the default location. This is useful if windows is giving issues with, paths or folders, during extraction.
- In `aiDEr-Local.Bat`, When selecting model, you would copy and paste, for example `DeepSeek-Coder-V2-Lite-Instruct:latest`, not `DeepSeek-Coder-V2-Lite-Instruct`.
- As you can tell from the threads settings for ollama, its currently designed for CPU users, but if you are on GPU, then you will want to, specify a number that relates to the number of shaders or set it to `0` for `auto`. At least I think thats how it works. I have a AMD RX 470, but if you can donate on kofi, maybe I will have a, AMD RX 7600 or GeForce RTX 4060, a little sooner, and these things can be known.
- Whats the best model for aider?? Apparently Deepseek Coder Lite Instruct in 16b is as good as llama 3 instruct 70b, but did notice that the Deepseek v2 GGUF would not load at a context higher than 8192 in LM Studio...not the 32768 or 16384 I was hoping for. (Guessing [Meta-Llama-3.1-Chat-Uncensored-GGUF](https://huggingface.co/mradermacher/Meta-Llama-3.1-Chat-Uncensored-GGUF) in Q5/6 is the best one for 64GB System Ram. The meta rounds off its abilities, and uncensored supposedly more intelligent, and its 3.1 not 3.0)... 
```
                    Code Generation
          #TP 	#AP 	HumanEval 	MBPP+ 	LiveCodeBench 	USACO							
CodeStral                      22B 	22B 	78.1 	68.2 	31.0 	4.6
DeepSeek-Coder-Instruct      33B 	33B 	79.3 	70.1 	22.5 	4.2
Llama3-Instruct                70B 	70B 	81.1 	68.8 	28.7 	3.3
DeepSeek-Coder-V2-Lite-Instruct    16B 	2.4B 	81.1 	68.8 	24.3 	6.5
DeepSeek-Coder-V2-Instruct    236B 	21B 	90.2 	76.2 	43.4 	12.1
```

### EXAMPLES:
- Prompt to make a game...
```
Phase 1:
the files I have provided 4 files, `data.dat`, `main.py`, `maze_game.bat`, `settings.json`, are all blank files, they are the files, that you should save to, in order to produce the game. A simple maze game in Python, using, `main.py` for main code and `settings.json` for peristent settings and `data.dat` for maps and `maze_game.bat` to run `main.py`, utilize them optimally and logically. Plan it all out, the goal is the completion, the result should be a good demonstration of your abilities. After each significant phase in editing, ensure to save the files, but ensure to save over the files provided with those filenames, do not save files with alternate names. 

Phase 2 (unfinished):
please check the current state of all 4 of the scripts. Your work is now... 1. Progress the game towards completion. 2. Ensure the scripts are, logical and sound. 3. Improve the code. 3. upgrade the code. ...And remember, I have provided 4 files, `data.dat`, `main.py`, `maze_game.bat`, `settings.json`, ensure to save to those files, do not save files with alternate names.
```

## DEVELOPMENT:
With the primary project of the batches done, there are some ideas for the forking of main branch files...
- Case-desensitivity in model names used for identification.
- Streamlining of identifiaction to, local models only, with exception of, huggingface (see below intelligent use of models) and and adapt openai to LM Studio.
- Local models will be added to identify correctly the models, that I will list, that will be based upon, what is the best performing models, for a limitation of 64GB, this will mainly include ensuring no issues with, llama v3.1 Meta unfiltered and deep-seek v2 lite, in gguf.
- for Intelligent use of Huggingface API to the  `https://huggingface.co/deepseek-ai/DeepSeek-Coder-V2-Instruct` or `https://huggingface.co/meta-llama/Meta-Llama-3.1-405B-Instruct`, after 3 errors in a row, as large model will likely sort it out, then revert back to local model after, and reset counter, however if it does not solve the same issue in one, then ask user if it should, additionally interact with huggingface using the larger model or allow the user to take a look at the files then re-test (requring re-prompt) or whatever would normally happen vanilla after 3 errors if it were not having the code to interact with larger models on huggingface. I also found out that deepseek provide 500,000,000 free tokens, this is clearly an idea.

### DISCLAIMER:
Issues that may arrise as a result of the code when aider is running, are not on the part of aiDEr-Local, as currently it does nothing out of the ordinary to the actual runnings of aider.
