# SARL Capacity for Prolog Knowledge Bases

This project provides a Prolog knowledge base capacity for SARL agents and one skill using [SWI Prolog](http://www.swi-prolog.org/).

The capacity/skill can be used as belief representation.


## PRE-REQUISITES

* Java Runtime Environment (JRE) and Java Compiler (javac) v1.8 (sun version recommended)
* Maven project management and comprehension tool (to meet dependencies, compile, package, run).
* SARL modules and execution engine 
	* Version defined by environment variable `SARL_VERSION`; for example `export SARL_VERSION=0.7.2`
	* Version tested: 0.6.1, 0.7.2
	* Obtained via Maven automatically from http://mvnrepository.com/artifact/io.sarl.maven).
* [SWI Prolog](http://www.swi-prolog.org/) (>7.4.x) with [JPL](http://www.swi-prolog.org/pldoc/doc_for?object=section(%27packages/jpl.html%27)) Bidirectional interface with Java:
		* This is package `swi-prolog-java` in Linux.
		* Main Page for JPL: https://jpl7.org/ 
* [Mochalog](https://github.com/ssardina/mochalog), a rich bidirectional interface between the Java Runtime and the SWI-Prolog interpreter inspired by JPL.
	* Obtained via Maven automatically using from [JitPack](https://jitpack.io/#ssardina/mochalog)
	* If in **Windows**:
		* Ensure that the environment variable `SWI_HOME_DIR` is set to the root directory of your installed version of SWI-Prolog.
	* If in **Linux**:
		* Latest package versions at <http://www.swi-prolog.org/build/PPA.txt> 
		* JPL is provided via package `swi-prolog-java` (interface between Java and SWI) installed. This will include library `libjpl.so` (e.g., `/usr/lib/swi-prolog/lib/amd64/libjpl.so`)
		* Extend environment library `LD_PRELOAD` for system to pre-load `libswipl.so`:
			```
			export LD_PRELOAD=libswipl.so:$LD_PRELOAD 
			```
		* Presumably, no need to setup `CLASSPATH` or `SWI_HOME_DIR`.


## CAPACITY _KB_PROLOG_


## SKILL _SWI_KB_Prolog_




## PROJECT CONTRIBUTORS 

* Sebastian Sardina (ssardina@gmail.com)



## LICENSE 

This project is using the GPLv3 for open source licensing for information and the license visit GNU website (https://www.gnu.org/licenses/gpl-3.0.en.html).

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
