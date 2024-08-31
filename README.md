# Aider-Local
- Status: Alpha - Under Development.

### DEVELOPMENT:
1. COmplete download of requried models. 
2. Testing Ollama is working correctly with the batches.
3. Testing Running aider - Is the install complete? Are there any further issues.

### DESCRIPTION:
- This fork, will have drop-in files, to enhance, useability and/or performance, for non-wsl windows 10 users, working off loal models (though it may work on similar editions of windows just fine).

### FEATURES:
- The batch `Install-Setup.Bat` is for setup and install of requirements, this includes, `setup-tools` and `requirements.txt`.
- The batch `aiDEr-Offline.Bat` is for launching aider with local models on Ollama, and also includes light management of Ollama.
- The batch `aiDEr-Online.Bat` is for launching aider with online services, but is redundant/untested/archived; it may be useful to others.

### USAGE:
1. Copy aider from the zip to a suitable directory, ie `D:\Programs\aider-0.5x.x`.
2. The files are dropped into relevantly `D:\Programs\aider-0.5x.x` or whatever folder. 
3. Run the batch `Install-Setup.Bat`, it will for setup and install of requirements, this includes, `setup-tools` and `requirements.txt`.
4. Run The batch `aiDEr-Offline.Bat`, to launch aider with local models on Ollama, and also includes light management/configuration of Ollama.
