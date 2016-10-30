# FlockCLI

The CLI used to interact with [Flock](https://github.com/jakeheis/Flock).

# Installation
### Homebrew
```bash
brew install jakeheis/repo/flock
```
### Manual
```bash
git clone https://github.com/jakeheis/FlockCLI
cd FlockCLI
swift build -c release
ln -s .build/release/FlockCLI /usr/bin/local/flock
```
# Commands
#### flock --init          
Initializes Flock in the current directory. See [Flock's README](https://github.com/jakeheis/Flock/blob/master/README.md#init) for more info about what exactly this command does.
#### flock --build
Builds Flock in the current directory. Automatically called anytime a task is invoked, so you should rarely have to call this command directly.
#### flock --update
Updates Flock's dependencies in the current project. Call if you update a dependency's version in `config/deploy/FlockDependencies.json`. Alternatively, you can call `flock --clean-all && flock --build`.
#### flock --clean
Cleans Flock's build directory in the current project by removing `.flock/.build`. Shouldn't need to be called often.
#### flock --clean-all
Cleans Flock's build directory and Packages directory in the current project. Generally doesn't need to be invoked directly, as  `flock --update` is usually the right call.
#### flock --add-env \<env\>
Adds an environment to the current project. See [Flock's README](https://github.com/jakeheis/Flock/blob/master/README.md#environments) for more info about what exactly this command does.
#### flock --create \<name\>
Creates a task with the given name. See [Flock's README](https://github.com/jakeheis/Flock/blob/master/README.md#writing-your-own-tasks) for more info about what exactly this command does.
#### flock --help
Prints help information
#### flock --version
Prints the current version of Flock
#### flock \<task\>
Execute the given task. See [Flock's README](https://github.com/jakeheis/Flock/blob/master/README.md#running-tasks) for more info about what exactly this command does.
