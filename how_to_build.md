#### Build steps for static lib:

1. Download and install Visual Studio 2015 Comunity Edition
2. Download and install Cmake for Windows
3. Download and install Intel MKL
4. Download and install Intel Visual Fortran compiler
5. Download and unpack arpack-ng
6. Open CMD, call VS2015x64NativeCmdWithMKL.bat, cd into arpack-ng folder and then type:

  mkdir build  
  cd build  
  cmake -D BUILD_SHARED_LIBS=OFF -D EXAMPLES=OFF -D MPI=OFF -G "Visual Studio 14 2015 Win64" ..  

7. Open arpack.sln from build folder
8. Select arpack project
9. Right click -> Properties
10. Select All Configurations in drop down control Configuration
11. Choose Configuration Properties -> General
12. Edit Output Directory field to contain $(SolutionDir)Out\$(Configuration)\
13. Edit Intermediate Directory field to contain $(SolutionDir)Int\$(Configuration)\$(ProjectName)\
14. If you want to be able to execute executables on Windows XP than change Platform Toolset to v140_xp
15. Build arpack project  
16. Run Administrative cmd, cd into Out subfolder in solution folder and execute:
    
  setx ARPACKROOT "%ProgramFiles%\Arpack" /M  
  set ARPACKROOT=%ProgramFiles%\Arpack  
  mkdir "%ARPACKROOT%\lib"  
  copy /B /Y arpack.lib "%ARPACKROOT%\lib"  


#### Build steps for dll:
1. Build static lib for at least one configuration
2. cd into out dir for this configuration and execute:

  dumpbin /linkermember:2 arpack.lib > arpackdll.def  
  
3. Edit out from def file everything except function names and add def header at the beginning of file:

  LIBRARY arpack  
  EXPORTS      
  (Notepad++ with its ability for block selection will make it a 1 minute job)  
4. Use Visual Studio Wizard to create new dll project named arpackdll
5. Move def file into arpackdll project folder
6. Repeat steps 8 - 13 for static lib arpack project on arpackdll
7. Edit Target Name field to contain string arpack
7. Choose Configuration Properties -> Linker -> Advanced and Edit Import Library field to contain $(OutDir)$(ProjectName).lib
7. Add to arpackdll project dependency on arpack project
8. Choose Configuration Properties -> Linker -> General
9. Add $(OutDir) in front of Additional Library Directories field
10. Choose Configuration Properties -> Linker -> Input
11. Add arpack.lib in field Additional Dependencies and either :
	- add to Additional Dependencies: C:\Program Files (x86)\IntelSWTools\compilers_and_libraries\windows\mkl\lib\intel64\mkl_intel_lp64_dll.lib;C:\Program Files (x86)\IntelSWTools\compilers_and_libraries\windows\compiler\lib\intel64\libiomp5md.lib;C:\Program Files (x86)\IntelSWTools\compilers_and_libraries\windows\mkl\lib\intel64\mkl_intel_thread_dll.lib;C:\Program Files (x86)\IntelSWTools\compilers_and_libraries\windows\mkl\lib\intel64\mkl_core_dll.lib
	- or open Configuration Properties -> Intel Performace Libraries and set drop down field Use Intel MKL to Parallel
12. Add arpackdll.def in field Module Definition File
13. Add new empty.cpp file to project arpackdll (this'll initiate linking and building of dll file)
14. Build project arpackdll
15. Run Administrative cmd, cd into Out subfolder in solution folder and execute:
    
  setx ARPACKROOT "%ProgramFiles%\Arpack" /M  
  set ARPACKROOT=%ProgramFiles%\Arpack  
  md "%ARPACKROOT%\dlllib"  
  md "%ARPACKROOT%\bin"  
  copy /B /Y arpackdll.lib "%ARPACKROOT%\dlllib\arpack.lib"  
  copy /B /Y arpack.dll "%ARPACKROOT%\bin"  
  and add %ARPACKROOT%\bin to path if it isn't already added (setx PATH "%PATH%%ARPACKROOT%\bin;")  

#### How to export in lib file names in different case than default:
1. Create def file like under section Build steps for dll
2. Edit exported function names so that they get form:

  arscnd  = ARSCND  
  cgetv0  = CGETV0  
  cmout  = CMOUT  
  ;where in first column are names you want to be exported, and in second column are compiler generated names  
  ;this also works for static lib, but than you have to repeat step for generating def file for dll  