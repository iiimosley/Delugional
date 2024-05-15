## Delugional 
A collection of wild-haired scripts to assist in loading kits & synths from external sources into your Deluge. 

### Requirements  
- Ability to run `bash` scripts
  - Windows Users may use [WSL](https://learn.microsoft.com/en-us/windows/wsl/) to execute the scripts ([installation docs](https://learn.microsoft.com/en-us/windows/wsl/install))
- Deluge's SD card is mounted and writeable

*Further requirements dependent on scripts executed*

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
- `DELUGE_SD_DIR`: mounted location for your Deluge's SD card
- `DELUGE_SAMPLES_SFM_DIR_NAME`: your preferred directory name for all migrated Samples from Mars kits 
- `SFM_SAMPLES_DIR`: local directory for all Samples From Mars samples

## Available Projects
⚠️ *__Please run all scripts from root project directory__* ⚠️

### Migrating from Mars
Migrates samples and builds kit files from the [Samples from Mars](https://samplesfrommars.com/) collections.

#### Requirements
- All Samples from Mars Drums are within a singular directory
- All Samples from Mars Drums retained their original file structure when downloaded

#### Executable Scripts
- `migrate` 
  - **Execution:** `./migrate-from-mars/migrate.sh`
  - **About:** Loads Samples from Mars kit samples onto the Deluge's `SAMPLES` directory
- `construct`
  - ⚠️ Must complete `migrate` execution prior to running this script ⚠️   
  - **Execution:** `./migrate-from-mars/construct.sh`
  - **About:** Builds Kit XML files into the Deluge's `KITS` directory from Deluge's Samples from Mars directory
