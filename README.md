# twist-parametrized

This repository contains code accompanying the paper `Rational points on modular curves: parameterization and geometric explanations`.

## Requirements

This package has been verified to work with [Magma](https://Magma.maths.usyd.edu.au/) version v2.29-4. Later versions might also work.
If you want to easily verify all computations in parallel you will also need [GNU Parallel](https://www.gnu.org/software/parallel/).

## Download

The [latest release](https://github.com/nt-lib/twist-parametrized/releases/latest) of this Magma package, including all depencies except
Magma and GNU Parallel can be obtained from the aforementioned link. One just needs to download and unpack the contents of the file whose
name looks like `twist-parametrized-v0.0.1.tar.gz`. Of course the version number `v0.0.1` might be different.


Another option is to just clone this repository using git. When doing so, make sure to initialise the git submodules this repository has.
This can be done using the following command:

```bash
git clone --recurse-submodules https://github.com/nt-lib/twist-parametrized.git
```

## Reproducing the results

After downloading the source code you can rerun all the computations usining the 
[verify_all.sh](https://github.com/nt-lib/twist-parametrized/blob/main/verify_all.sh) script. This requires 
[GNU Parallel](https://www.gnu.org/software/parallel/) to be installed. Running the script is done by running the following command in the root of
this repository:

```bash
./verify_all.sh
```

Logs of these results will automatically be written to the [logs](https://github.com/nt-lib/twist-parametrized/tree/main/logs) directory.


## Using the dependencies

This repository depends on [several Magma packages](https://github.com/nt-lib/twist-parametrized/blob/main/.gitmodules). All these
dependencies can be easily loaded by attaching 
[TwistParametrized.spec](https://github.com/nt-lib/twist-parametrized/blob/main/TwistParametrized.spec) by using:

```magma
AttachSpec("TwistParametrized.spec");
```

The above command needs to be run from Magma session that was started inside the root directory of this repository. Starting Magma from
other locations is also possible but then the path `"TwistParametrized.spec"` needs to be adjusted accordingly.
