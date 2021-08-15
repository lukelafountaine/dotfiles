# From `brew install coreutils`:
# ==> Pouring coreutils--8.32.big_sur.bottle.2.tar.gz
# ==> Caveats
# Commands also provided by macOS have been installed with the prefix "g".
# If you need to use these commands with their normal names, you
# can add a "gnubin" directory to your PATH from your bashrc like:
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"


# From `brew install grep`:
# ==> Pouring grep--3.6.big_sur.bottle.tar.gz
# ==> Caveats
# All commands have been installed with the prefix "g".
# If you need to use these commands with their normal names, you
# can add a "gnubin" directory to your PATH from your bashrc like:
export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"


# From `brew install gnu-sed`
# ==> Pouring gnu-sed--4.8.big_sur.bottle.tar.gz
# ==> Caveats
# GNU "sed" has been installed as "gsed".
# If you need to use it as "sed", you can add a "gnubin" directory
# to your PATH from your bashrc like:
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"


# From `brew install ruby` (or, because `ruby` is a dependency of `vim`)
# ==> ruby
# By default, binaries installed by gem will be placed into:
#   /usr/local/lib/ruby/gems/2.6.0/bin
#
# You may want to add this to your PATH.
#
# ruby is keg-only, which means it was not symlinked into /usr/local,
# because macOS already provides this software and installing another version in
# parallel can cause all kinds of trouble.
#
# If you need to have ruby first in your PATH run:
#   echo 'export PATH="/usr/local/opt/ruby/bin:$PATH"' >> ~/.bash_profile
#
# For compilers to find ruby you may need to set:
#   export LDFLAGS="-L/usr/local/opt/ruby/lib"
#   export CPPFLAGS="-I/usr/local/opt/ruby/include"
export PATH="/usr/local/opt/ruby/bin:$PATH"


# From `brew install openjdk`
# ==> Pouring openjdk--16.0.2.big_sur.bottle.tar.gz
# ==> Caveats
# For the system Java wrappers to find this JDK, symlink it with
#   sudo ln -sfn /usr/local/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
#
# openjdk is keg-only, which means it was not symlinked into /usr/local,
# because macOS provides similar software and installing this software in
# parallel can cause all kinds of trouble.
#
# If you need to have openjdk first in your PATH, run:
#   echo 'export PATH="/usr/local/opt/openjdk/bin:$PATH"' >> /Users/ldlafountaine/.bash_profile
#
# For compilers to find openjdk you may need to set:
#   export CPPFLAGS="-I/usr/local/opt/openjdk/include"
export PATH="/usr/local/opt/openjdk/bin:$PATH"


# These versions of Maven and Spark are needed to develop Glue ETL scripts locally with
# Python. For more info, see:
# https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming-etl-libraries.html#develop-local-python
export PATH="/usr/local/apache-maven-3.6.0/bin:$PATH"
export PATH="/usr/local/spark-2.4.3-bin-spark-2.4.3-bin-hadoop2.8/bin:$PATH"
