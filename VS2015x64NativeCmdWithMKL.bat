@echo off

call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" amd64
call "C:\Program Files (x86)\IntelSWTools\compilers_and_libraries\windows\bin\compilervars.bat" intel64 vs2015
set MKLPATH=%MKLROOT%\lib\intel64
set MKLINCLUDE=%MKLROOT%\include

set LAPACK_LIB_DIRS=%MKLROOT%
set BLAS_LIB_DIRS=%MKLROOT%
