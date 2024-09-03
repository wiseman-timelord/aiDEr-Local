# aiDEr-Local
- Its a fork, the main is, [here](https://github.com/paul-gauthier/aider) or [here](https://aider.chat/).
- Fork Status: Alpha - Under Development.

### DEVELOPMENT:
1. issue when saving files. I told it to use `.\output` and tried the full path. Perplexity agrees with my assumption, that its the model, but, I dont think thats the case either, there is something I did before that enabled saving of files. I have tried 0. Could be the modelfile, but I tried several of those now, maybe need try the older one I have in the `.\modelfiles` folder. There are newer versions of aider to try on the main repo, x.11 and x.12. All work I produce on the scripts is somewhat useless unless its going to save files. So work on the batches is on hold until I can get this fixed...
```
The LLM did not conform to the edit format.
https://aider.chat/docs/troubleshooting/edit-errors.html

No filename provided before ``` in file listing
Only 3 reflections allowed, stopping.
```
2. LM Studio is not working because the OpenAI API requires a key to use currently, so, streamlining + conversion of OpenAI to LMStudio or addition of a `--lmstudio` argument for new code, as well as conversion. Possibly Launch command isnt right...
```
Model gpt-4o-2024-08-06: Environment variables status:
- OPENAI_API_KEY: ✗ Not set
If you just set these environment variables using `setx` you may need to restart your terminal or command prompt for the
changes to take effect.
For more info, see: https://aider.chat/docs/llms/warnings.html
```
3. When LM Studio is fixed, elevate status to beta. It must work on LM Studio, I could just cut out LM Studio, but its a goal, as by putting few layers on my non-ROCM GPU, I can locally host Lamma 3.1 70B in Q6.
4. Complete download of model (see NOTATIONS section) - In the mean time we are testing with "deepseek-v2-lite-instruct" in Q8 GGUF. 
5. running with file(s) needs testing/investigating/improving.
4. Edit main branch files, after batches are finished...
- Streamlining of identifiaction to, local models only, with exception of, huggingface (see below intelligent use of models) and and adapt openai to LM Studio.
- Local models will be added to identify correctly the models, that I will list, that will be based upon, what is the best performing models, for a limitation of 64GB, this will mainly include ensuring no issues with, llama v3.1 Meta unfiltered and deep-seek v2 lite, in gguf.
- for Intelligent use of Huggingface API to the  `https://huggingface.co/deepseek-ai/DeepSeek-Coder-V2-Instruct` or `https://huggingface.co/meta-llama/Meta-Llama-3.1-405B-Instruct`, after 3 errors in a row, as large model will likely sort it out, then revert back to local model after, and reset counter, however if it does not solve the same issue in one, then ask user if it should, additionally interact with huggingface using the larger model or allow the user to take a look at the files then re-test (requring re-prompt) or whatever would normally happen vanilla after 3 errors if it were not having the code to interact with larger models on huggingface. I also found out that deepseek provide 500,000,000 free tokens, this is clearly an idea.

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

### PREVIEW:
- The `aiDEr-Local.Bat` Main Menu...
```
========================================================================================================================
                                                   AiDEr-Local Launcher
========================================================================================================================

    1. Run Aider with, Ollama and Selected Model

    2. Run Aider with, Ollama and Selected Model and Files

    3. Run Aider with LM Studio (Not Working)

    4. Run Aider with, LM Studio and Files (Not Working)

    5. Manage Ollama Settings


------------------------------------------------------------------------------------------------------------------------

    * Model Selected:
DeepSeek-Coder-V2-Lite-Instruct

    * Threads Used:
21

    * Python Location:
C:\Users\**UserName**\AppData\Local\Programs\Python\Python312\python.exe


========================================================================================================================
Selection; Menu Options = 1-5, Exit Batch = X:

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
- The `Setup-Install.Bat` Model Management for Ollama...
```
========================================================================================================================
                                             Ollama Model Management
========================================================================================================================



    * Available Ollama models:
NAME    ID      SIZE    MODIFIED




========================================================================================================================
Selection; Install ModelCard = I, Remove Modelcard = R, Back to Menu = B: i
Enter the full path to the model including filename: L:\TEXT\bartowski\DeepSeek-Coder-V2-Lite-Instruct\DeepSeek-Coder-V2-Lite-Instruct-GGUF-Q8_0_L.gguf
Enter the full path to the ModelFile: L:\TEXT\bartowski\DeepSeek-Coder-V2-Lite-Instruct\DeepSeek-Coder-V2-Lite-Instruct-GGUF-q8_0_l.modelfile
Enter a name for the new model: DeepSeek-Coder-V2-Lite-Instruct
Installing Model to Ollama...
transferring model data 100%
using existing layer sha256:c41b0dbf1599296ba76343b942c39691a96a20ff382dad8cfc674889360d773e
creating new layer sha256:04642f460a9d5cd1390c1462de1fb8b757872ba260013ff67f75958aaff28cf9
creating new layer sha256:2c2625c551b5197ae9cad4fc90ff12a930309db1a0bb6012135b6c8bebdfc714
creating new layer sha256:a58ff6a2ea83793a6b3f8affbf413906ef2a5bc0aad57f18cc70613c6cd49109
creating new layer sha256:ac7bddfa75fb8d031628ac8cea54c4d48db692976927fc1b76101a7b83520d1e
writing manifest
success
Model DeepSeek-Coder-V2-Lite-Instruct installed successfully.
Updated: .\data\persistence.txt


```


## REQUIREMENTS:
- Windows v7-v11?? - version 10 is the, programming and testing, platform, and thats non-WSL.
- Python v3.9-3.12 - Now working with whatever version of Python is specified by the user during setup.

### USAGE:
1. Even though My batches will detect the location of Python, I do notice that `aider` is unable to be used with python in `Program Files`, so do NOT install python for all users or `aider` will have issues.
2. Copy aider from the zip to a suitable directory, ie `D:\Programs\aider-0.5x.x`.
3. The files are dropped into relevantly `D:\Programs\aider-0.5x.x` or whatever folder. 
4. Run the batch `Install-Setup.Bat`, it will for setup and install of requirements, this includes, `setup-tools` and `requirements.txt`.
5. Ensure model is loaded in LM Studio, or otherwise that you have installed the model in Ollama (see folder .\modelfiles). 
6. Run The batch `aiDEr-Offline.Bat`, to, configure models/threads, and launch aider with, LM Studio or Ollama, with options to include files.

## NOTATION:
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
