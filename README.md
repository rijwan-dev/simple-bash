### Introuduction
**simple-bash** is a list of customizable and nice looking prompts configuration with integrated git for bash shell.
The interactive shell based setup which can install or uninstall bash configuration with ease.
It includes pre-configured list of simple bash prompt configurations with added support for git. Configuration scripts are very simple and beginner friendly. One can create their own configuration based on these examples more creatively.

#### Features
1. **Integrated Git: ** The example configuration files in the `themes/` folder have configured to utilize git command and show git branch and status right in the terminal prompt.
2. **Workspace Type Detection: ** displays icon in the prompt based on your workspace. e.g, if you working with cmake, it will be shown in the bash prompt.
3. **Easy Customization: ** The bash configuration scripts are very easy to customize or even make new one based on these.
4. **Easy Installation: ** It's very easy to install the bash configuration with help of `./setup.sh`. Not only that! if any bash configuration is kept in the `themes/` directory with `.bashrc` format, `setup.sh` will detect and give option to install that configuration too.
5. **Easy Removal: ** If you have any previous installation of through `./setup.sh` running it again will give an option to remove previous installation.
6. **Other Uses:** Suppose you need different bash configuration (alias, $PATH variables, custom commands) for different kinds of work, then just make seperate configuraion for your different work requirement and keep them in `themes/` directory. Switch your bash configuration with eash with help of the `./setup.sh/` script.

#### Demonstration
Here's a simple demonstration of `multiline.bashrc` themed configuration.
![alt text](./media/demo.gif)

### Installation
*Installation is fairly simple. Just follow these steps.*

1. **Install `git` and make sure it is in your PATH variable: ** [How to install git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

2. **Install NERD fonts for your system and use NERD font for your terminal emulator. **[How to install Nerd font on on linux](https://linuxtldr.com/install-fonts-on-linux/)

3. **Clone this repository and run the `setup.sh` file:**
``` bash
git clone https://github.com/rijwan-dev/simple-bash.git
cd simple-bash
chmod +x setup.sh
./setup.sh
```
Setup will display all list of available configuration with preview. Choose the theme you want install. Enter that number and setup will install that configuration. *If the installation succeed the cloned repository can be safely removed without affecting the existing installation.*
*Here is a simple demo of setup script*
![alt text](./media/setup.gif)
~~**Alternatively:**~~
~~If you want to install the configuration file manually, choose one from the `themes` directory and either copy and paste the content into `~/.bashrc` file or copy the configuration file to your desired location say (`$HOME/.config/bash/arrow.bashrc`) and then add `source $HOME/.config/bash/arrow.bashrc` at bottom of your `~/.bashrc` file.~~ 

**NOTE: ** New bash configuration will takes into effects only when the bash session restarts. To reload manually use following command in order to see effects immediately.
``` bash
source ~/.bashrc
```

4. **If you experience laggy or visual glitch consider [kitty terminal](https://www.linuxfordevices.com/tutorials/linux/kitty-terminal-installation).**


### Configuration
If you want to customize the configuration or appearance, edit the theme file directly in `themes` directory and run the `./setup.sh` again to reinstall.
For most of the cases, instead of modifying existing theme configuration file simply copy or create new file just make sure to add `.bashrc` extension to your configuration file.
`./setup.sh` will account for all changes and new files in the `themes` directory. So, simply run it again to re/un/install.
Here are some links which will help you to customize or make you own configuration file:
[How to customize your bash prompt?](https://www.howtogeek.com/307701/how-to-customize-and-colorize-your-bash-prompt/)
[Learn bash shell programming or scropting.](https://www.learnshell.org/)
[How to install NERD font?](https://wordscr.com/how-to-install-nerd-fonts/)
[Where to get CheatSheet of nerd font?](https://www.nerdfonts.com/cheat-sheet)



### Uninstalling
If you have any previous installation using `./setup.sh` simply run it again and enter x to remove when asked.
If you have deleted copy of this repo you have to clone it again to use the setup script.
~~**Alternatively, if you have installed configuration files manually, then you know how to remove.**~~
