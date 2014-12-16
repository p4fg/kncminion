# KncMinion

KnC are in my opinion on the absolute frontline with regards to ASIC-development. 
User-interface development are however not their (or any other manufacturer for that matter) main priority.

KnCMinion is my way of giving back to both KnC and the mining community. 
This is a proof-of-concept drop-in extension for the status-interface on the KnC Titan.

KnCMinion is packaged and installed as a firmware-upgrade. The package only adds files to the webserver on your titan, so it will work with any existing firmware. It will not affect anything mining-related and will not overwrite any existing files.

You should (of course) be very careful what you install on your titan, feel free to inspect the package before installing, it is a simple unix tar.gz.

The package installs two new cgi-bin scripts
* /cgi-bin/bfgminer_procs.cgi - Gives detailed status for each die
* /cgi-bin/bfgminer_summary.cgi - Gives summary status for all cubes

KnCMinion makes heavy use of AngularJS, D3.js, Bootstrap and jQuery. 
As it has a lots of animations it can be quite resource-intensive on low-powered computers.

If any other mining manufacturer is interested in pimping their web-interfaces you are most welcome to contact me p4fg (at) shellcode.se to arrange something!


## Install
There are a two ways you can install KnCMinion

* (Recommended) Download a pre-package firmware-image from the [releases](https://github.com/p4fg/kncminion/releases) page and install it as any other firmware. 

* Clone the git repository and build your own firmware-file and upload.
 
## Getting Started
* Install KnCMiner via the "Firmware Upgrade"-feature
* Using your favorite browser, navigate to http://my-titan-hostname-here/kncminion

## License
KnCMinion is licensed under the MIT-license.

## Contributors
If you want to contribute to KnCMinion, feel free to fork the repository and send a pull-request.

### Development environment

Pre-requisites (known working versions):
* Node (v0.10.25)
* Grunt (v0.4.5+)
* Bower (1.3.12+)

After running grunt, a file called fake_titan.js is created in the repository root. 
This file can be run under node and will act as a titan simulator, answering to the cgi-bin calls with faked data. 
It will also serve the static content and the required libraries.

To enter the simulated environment, navigate to http://127.0.0.1:8080/build/www/pages/kncminion/

## Credits
Minion images from http://www.designbolts.com. Free for non-commercial use.