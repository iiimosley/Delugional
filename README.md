## Deluging from Mars
A collection of scripts to assist in loading up your Deluge with the wonderful [Samples from Mars](https://samplesfrommars.com/).

### Requirements  
- You must have the ability to run shell scripts
  - Windows Users may use [WSL](https://learn.microsoft.com/en-us/windows/wsl/) to execute the scripts ([installation docs](https://learn.microsoft.com/en-us/windows/wsl/install))
- Deluge's SD card is mounted and writeable
- All Samples from Mars Drums are within a singular directory
- All Samples from Mars Drums retained their original file structure when downloaded

## Getting Started
### Setup Environment Variables
1. Create a `.env` file in the project's root directory
1. Copy the contents of the `.env.example` 
1. Paste into the new `.env` 
1. Update values to reflect appropriate locations on your files system

Steps #1 - #3 can be accomplished with the following command:
```sh
cp .env.example .env
```

#### Environment Variables
- `DELUGE_SD_DIR`: location of your Deluge's SD card
- `DELUGE_SAMPLES_SFM_DIR_NAME`: your preferred directory name for all migrated Samples from Mars kits 
- `SFM_SAMPLES_DIR`: location of all Sounds From Mars samples

### Available scripts
- `migrate` - Loads Samples from Mars kit samples onto the Deluge's `SAMPLES` directory
- `construct` - Builds kit XML files into the Deluge's `KIT` from Deluge's Samples from Mars directory
