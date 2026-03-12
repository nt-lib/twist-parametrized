# twist-parametrized

This repository contains code accompanying the paper `Rational points on modular curves: parameterization and geometric explanations`.

## Requirements

This package requires [Magma](https://Magma.maths.usyd.edu.au/) version v2.29-4. And [lmfdb-lite](https://github.com/roed314/lmfdb-lite/tree/4c4262b60b6ae8a9c6f33771ae4e939637d95741)  commit 4c4262b60b.... . Later versions might also work.

lmfdb-lite can be installed using

```bash
pip3 install -U "lmfdb-lite[pgbinary] @ git+https://github.com/roed314/lmfdb-lite.git"
```

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

## Common errors

### The lmfdb-lite python package is not installed

If you get an error like below this means that lmfdb-lite is not installed. In this case check that lmfdb-lite is installed. If you are certain it is installed make sure that `python_path` in [config.m][config.m] is pointing to the correct python installation.
```
Traceback (most recent call last):
  File "<string>", line 1, in <module>
  File "/home/mderickx/nt-lib/twist-parametrized/lmfdb-magma/py_src/lmfdb_magma/db.py", line 28, in lmfdb_search_batch
    result.append(_lmfdb_search(table_name, arg, **kwargs))
                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/mderickx/nt-lib/twist-parametrized/lmfdb-magma/py_src/lmfdb_magma/db.py", line 12, in _lmfdb_search
    from lmf import db
ModuleNotFoundError: No module named 'lmf'

MDGL2LMFDBLookup(
    groups: [ MatrixGroup(2, Integer Ring) of order 1,  MatrixGroup(2, I...
)
MDLMFDBSearchBatch(
    table: gps_gl2zhat_fine,
    query: [ [* <index, 1>, <level, 1>, <genus, 0>, <contains_negative_...
)
MDLMFDBSearchBatchStr(
    table: gps_gl2zhat_fine,
    queries: [ [* <index, 1>, <level, 1>, <genus, 0>, <contains_negative_...
)
In file "/home/mderickx/nt-lib/twist-parametrized/lmfdb-magma/magma_src/db.m", 
line 69, column 18:
>>     entry := Pipe(full_cmd, "");
                    ^
Runtime error in 'Pipe': Subprocess failed with exit status 1
```

[def]: config.m