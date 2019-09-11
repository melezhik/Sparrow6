# winrun

How to run Sparrow6 on windows


# INSTALL Perl6

* Go to https://rakudo.org/files/star/windows and download Perl6
* Install git-bash

# Installation

Run git-bash session

Setup PATH

    export PATH='C:\rakudo\bin':'C:\rakudo\share\perl6\site\bin':$PATH

Setup aliases

    alias perl6='perl6.bat'
    alias zef='zef.bat'
    alias s6='s6.bat'


Setup Sparrow6 variables

    export SP6_REPO=http://repo.westus.cloudapp.azure.com
    export USER=<your-user>


Install Sparrow6

    git clone https://github.com/melezhik/Sparrow6.git
    cd Sparrow6
    git checkout windows-tweaks
    zef install . --/test


Checking installation


    # these commands should succeed
    s6 --index-update    
    s6 --plg-run bash@command='ls -l'

