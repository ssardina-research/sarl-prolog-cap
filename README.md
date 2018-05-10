# SARL Capacity for Prolog Knowledge Bases

This project provides a Prolog knowledge base capacity for SARL agents and one skill using [SWI Prolog](http://www.swi-prolog.org/).

The capacity/skill can be used as belief representation.

This package can be obtained via Maven using JitPack: https://jitpack.io/#org.bitbucket.ssardina-research/sarl-prolog-cap


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
	* Presumably, no need to setup `CLASSPATH` or `SWI_HOME_DIR`.
* If in **Linux**:
	* Latest SWI versions at <http://www.swi-prolog.org/build/PPA.txt> 
	* JPL is provided via package `swi-prolog-java` (interface between Java and SWI) installed. This will include library `libjpl.so` (e.g., `/usr/lib/swi-prolog/lib/amd64/libjpl.so`)
	* Extend environment Variable ` LD_LIBRARY_PATH`  to where ` libjpl.so`:
		```
		export LD_LIBRARY_PATH=/usr/lib/swi-prolog/lib/amd64/
		```
	* Extend environment library `LD_PRELOAD` for system to pre-load `libswipl.so`:
		```
		export LD_PRELOAD=libswipl.so:$LD_PRELOAD 
		```

* If using RUN AS configuration in ECLIPSE, remember to set up the following environment variables (and check "Append environment to native environment").



## CAPACITY *KB_PROLOG*


This capacity provides standard Prolog access:

* `consult_file(file : String)`: consult file into Prolog engine.
* `dump_kb()`: dump the current knowledgebase to a file with timestamp and registered name for kb.
* `dump_kb(id : String)`: : dump the current knowledgebase to a file with timestamp and name of kb.
* `get_prolog_engine()	: Object`: gives the prolog reference.
* `get_kb_name() : String`: gives the registered name of the kb.
* `assertFirst(queryS : String, params : Object*)`: assert a query
* `buildQuery(queryS : String, params : Object*)`: build a query
* `askOnce(queryS : String, outVars : String[], params : Object*) : Map<String, Term>`: ask a query and get first result.


## SKILL *SWI_KB_Prolog*

This implementation of the capacity uses [SWI Prolog](http://www.swi-prolog.org/) and the [Mochalog](https://github.com/ssardina/mochalog) framework.


Some useful notes:

* To handle responses from Prolog, where variables are grounded to Terms, we use the [Term](http://www.swi-prolog.org/packages/jpl/java_api/javadoc/jpl/Term.html) class form JPL
* To handle pairs of variable name and term unified to, use [Pair](http://gangmax.me/blog/2017/10/10/how-to-return-multiple-values-from-a-java-method/) class; see example below.


## EXAMPLE OF USE

To use this capacity/skill:

1. Create a Capacity *C* for your application that provides the main queries to your domain.
	* For example, `KB_Elevator` capacity for an elevator domain with functions such as:
		* `kb_load(file : String)`: load the KB encoded in a file.
		* `kb_registerCarRequest(floor : int, dir : String)`: register that there has been a request in a floor towards a direction.
		* `kb_getNextJob() : Pair<Integer, Direction>`: get the next job (floor & direction) to serve. (see the [Pair](http://gangmax.me/blog/2017/10/10/how-to-return-multiple-values-from-a-java-method/) class)
	* Observe this capacity can be implemented in many ways, for example, with plan Java.
2. Create a skill *S* for the capacity *C* that will be a Prolog Knowledgebase.
	* The skill will *extend* a skill for *KB_Prolog*, for example it can extend the skill `SWI_KB_Prolog`.
		* This means that everything in the *KB_Prolog* capacity will be available in *S* so that *S* can use Prolog to implement the domain queries.
		* For example:
		
				skill SWI_KB_Elevator extends SWI_KB_Prolog implements KB_Elevator  {
		
					val logging_level : int
					new (l : int = 0, name : String) {
						super(name) // Call the super's constructor
						logging_level = l
					}
				
					def kb_registerCarRequest(floor : int, dir : String) {
						assertFirst("open_car_request(@I, @A)", floor, dir)
					}

					def kb_load(file : String) {
						consult_file(file)
					}
					
					....
				}

3. Your application will use skill *S* (for domain capacity *C*):

				import au.edu.rmit.agtgrp.elevatorsim.sarlctrl.beliefs.KB_Elevator
				import au.edu.rmit.agtgrp.elevatorsim.sarlctrl.beliefs.SWI_KB_Elevator

				// http://gangmax.me/blog/2017/10/10/how-to-return-multiple-values-from-a-java-method/
				import org.apache.commons.lang3.tuple.Pair

				setSkill(new SWI_KB_Elevator(0, "agent23"))

				// Load agent knowledge base
				kb_load("src/main/prolog/sweeper_elevator_agent.pl")
				reportMessage("I have loaded the SWI KB successfully!")		


				on CarRequestPercept 
				{
					reportPersonRequestedService(occurrence.floor, occurrence.direction)

					// Add car request to our beliefs
					kb_registerCarRequest(occurrence.floor, occurrence.direction.name);

					kb_dump()
				}

				/**
				 * Handle the most preferable next request as soon as
				 * it is available. Preference is defined by our beliefs.
				 */
				private def performNextJob
				{
					// Begin polling for new jobs asynchronously
					execute [
						val job : Pair<Integer, Direction> = kb_getNextJob()
						val destination : int = job.left
						val direction : Direction = job.right

						reportTravellingTo(carID, destination, direction)

						// Send car to destination by communicating it to Boss (and everyone else)
						var sendCar = new SendCarAction(carID, destination, direction)
						emit(sendCar) // Notify the SweeperBossAgent
					]
				}


To add the dependency to this capacity in your SARL application, you can use Maven using JitPack: https://jitpack.io/#org.bitbucket.ssardina-research/sarl-prolog-cap, by adding this dependency and repository in to your `pom.xml`:

        <!--  SARL PROLOG CAPACITY -->
        <dependency>
            <groupId>org.bitbucket.ssardina-research</groupId>
            <artifactId>sarl-prolog-cap</artifactId>
            <version>-SNAPSHOT</version>
        </dependency>

        <!-- JitPack used for remote installation of dependencies from Github and Bitbucket -->
        <repository>
            <id>jitpack.io</id>
            <name>JitPack Repository</name>
            <url>https://jitpack.io</url>
        </repository>



## CONTACT 

* Sebastian Sardina (ssardina@gmail.com)



## LICENSE 

This project is using the GPLv3 for open source licensing for information and the license visit GNU website (https://www.gnu.org/licenses/gpl-3.0.en.html).

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
