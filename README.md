Quick and dirty doc for setup
=============================
A few scripts put together to pull hackage dependencies on a local server, configure stack to run off of the local server as well.

Here are the steps to replicate a local stackage/hackage server :

Usage
=====
First, in the [haskell-stackage-mirror-script](haskell-stackage-mirror-script) project, run [mirror.sh](haskell-stackage-mirror-script/mirror.sh). This will replicate the entire hackage, stackage, pull GHC in a directory named `mirror`

After a successful run, it provides:
* a mirror directory that is ready to be served by a http server (see [offline-server](offline-server) for a lightweight server that I used for testing purposes)
* a `config.yaml` file, that will be have to be put into the client `~/.stack/config.yaml` path.

The mirror script also checks downloaded files integrity by computing and validating their sha1 checksums. Files already downloaded won't be downloaded multiple times.

Next, you need a decent running stack binary. Change directory by moving into `stack-tool-download` and run the script (pass a -d switch to specify the intended install directory) within in. Once the script completes, you should have a decent stack build tool installed.

Finally, it's time to setup our stack/ghc environment. This is quite simple as well. Setup a webserver to serve the files as per the generated script [haskell-stackage-mirror-script/mirror/stack-setup-mirror.yaml](haskell-stackage-mirror-script/mirror/stack-setup-mirror.yaml). 

Then run `stack  --verbosity debug --stack-root ~/.stack/ setup --setup-info-yaml ./haskell-stackage-mirror-script/mirror/stack-setup-mirror.yaml` This should complete the setup of your GHC in the client environment.

