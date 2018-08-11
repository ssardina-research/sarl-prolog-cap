# SARL Capacity for Prolog Knowledge Bases

This project provides a Prolog knowledge-base capacity for SARL agents and one skill for it using [SWI Prolog](http://www.swi-prolog.org/).

The Prolog capacity/skill can be used as belief representation.

This package can be obtained via Maven using JitPack: https://jitpack.io/#org.bitbucket.ssardina-research/sarl-prolog-cap


## PRE-REQUISITES

This capacity/skill depends on two main systems:

* [SWI Prolog](http://www.swi-prolog.org/) (>7.4.x) with [JPL](http://www.swi-prolog.org/pldoc/doc_for?object=section(%27packages/jpl.html%27)) Bidirectional interface with Java:
	* This is package `swi-prolog-java` in Linux.
	* In Windows, the Java-SWI interface it can be installed as part of the main install.
	* Main Page for JPL: https://jpl7.org/ 
* [Mochalog](https://github.com/ssardina/mochalog), a rich bidirectional interface between the Java Runtime and the SWI-Prolog interpreter inspired by JPL.
	* Obtained via Maven automatically using from [JitPack](https://jitpack.io/#ssardina/mochalog)
	*  Check the [Mochalog Wiki](https://github.com/ssardina/mochalog/wiki) to understand how to setup Mochalog in your agent.

Also, depending on the system being used:

* If in **Windows**:
	* Tested successfully in Windows 7 with SWI 7.6.4.
	* Make sure SWI is installed with the JPL Java-SWI connectivity. You should have a `jpl.dll` (in the SWI `bin/` subdir) and a `jpl.jar` (in the SWI `lib/` subdir).
	* Define a _system_ environment variable `SWI_HOME_DIR` and set it to the root directory of your installed version of SWI-Prolog (e.g., to `C:\Program Files\swipl`).
	* Extend `Path` system environment variable with the following two components:
		* `%SWI_HOME_DIR%\bin`
		* `%SWI_HOME_DIR%\lib\jpl.jar`
	* No changes to `CLASSPATH` are needed.
* If in **Linux**:
	* Latest package versions at <http://www.swi-prolog.org/build/PPA.txt> 
	* JPL is provided via package `swi-prolog-java` (interface between Java and SWI) installed. This will include library `libjpl.so` (e.g., `/usr/lib/swi-prolog/lib/amd64/libjpl.so`)
	* Extend environment library `LD_PRELOAD` for system to pre-load `libswipl.so`: `export LD_PRELOAD=libswipl.so:$LD_PRELOAD`
		* Check [this post](https://answers.ros.org/question/132411/unable-to-load-existing-owl-in-semantic-map-editor/) and [this one](https://blog.cryptomilk.org/2014/07/21/what-is-preloading/) about library preloading.
		* Also, check [this](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=690734) and [this](https://github.com/yuce/pyswip/issues/10) posts.
	* Extend environment variable `LD_LIBRARY_PATH`  to point to the directory where `libjpl.so` is located (e.g., `export LD_LIBRARY_PATH=/usr/lib/swi-prolog/lib/amd64/`)
	* If using RUN AS configuration in ECLIPSE, remember to set up these two variables `LD_LIBRARY_PATH` and `LD_PRELOAD` too (and check "Append environment to native environment").
	
### Develop **SARL PROLOG CAP** further

If one wants to _develop_ this capacity/skill further:

* Java Runtime Environment (JRE) and Java Compiler (javac) v1.8 (Sun version recommended)
* Maven project management and comprehension tool (to meet dependencies, compile, package, run).
* SARL modules and execution engine 
	* Version defined by environment variable `SARL_VERSION`; for example `export SARL_VERSION=0.7.2`
	* Version tested: 0.6.1, 0.7.2
	* Obtained via Maven automatically from http://mvnrepository.com/artifact/io.sarl.maven.

### Include **SARL PROLOG CAP** in your SARL application via Maven 

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



## WHAT IS PROVIDED: CAPACITY *KB_PROLOG* and SKILL *SWI_KB_Prolog*

This `KB_Prolog` capacity provides the following hooks to Prolog access:

* `consult_file(file : String)`: consult file into Prolog engine.
* `dump_kb()`: dump the current knowledgebase to a file with timestamp and registered name for kb.
* `dump_kb(id : String)`: : dump the current knowledgebase to a file with timestamp and name of kb.
* `get_prolog_engine()	: Object`: gives the prolog reference.
* `get_kb_name() : String`: gives the registered name of the kb.
* `assertFirst(queryS : String, params : Object*)`: assert a query
* `buildQuery(queryS : String, params : Object*)`: build a query
* `askOnce(queryS : String, outVars : String[], params : Object*) : Map<String, Term>`: ask a query and get first result.


In terms, the particular skill `SWI_KB_Prolog` uses [SWI Prolog](http://www.swi-prolog.org/) with [JPL](https://jpl7.org/) interface as the Prolog engine, 
and the [Mochalog](https://github.com/ssardina/mochalog) framework for more high-level access to SWI Prolog via the JPL interface.

Some useful notes:

* To handle responses from Prolog, where variables are grounded to Terms, we use the [Term](http://www.swi-prolog.org/packages/jpl/java_api/javadoc/jpl/Term.html) class form JPL
* To handle pairs of variable name and term unified to, use [Pair](http://gangmax.me/blog/2017/10/10/how-to-return-multiple-values-from-a-java-method/) class; see example below.


## USING SWI-Prolog IN SARL AGENTS/APPLICATIONS

There are basically three ways one can use SWI-Prolog inside SARL agents, depending on the level of abstraction:

1. **[RECOMMENDED]** Create a capacity **KB_Domain** for your domain application that embodies the usual KB queries required, and a skill **SWI_KB_Domain** for it extending skill **SWI_KB_Prolog** (which implements general Prolog capacity **KB_Prolog**) in the [SARL Prolog Capacity](https://bitbucket.org/ssardina-research/sarl-prolog-cap) framework that implements those queries. 
That skill will have access to all the SWI Prolog tools provided in skill **SWI_KB_Prolog** and can implement the domain queries via SWI queries. 
Under this approach, the SARL agent will:
	* Use capacity **KB_Domain**, which is the capacity for the queries of the domain.
		* A SARL agent will only use the queries provided by this capability via its functions.
	* Use skill **SWI_KB_Domain**, which implements capacity **KB_Domain** and extends **SWI_KB_Prolog**.
		* It is this skill that will perform Prolog queries via the Prolog tools offered by **KB_Prolog**.
	* Note that the functions in **SWI_KB_Prolog** will _NOT_ be visible to the SARL agent, who can only access functions defined in domain capacity **KB_Domain**.
		* If the SARL agent wants to do direct Prolog queries, it can also use capacity **KB_Prolog**, which means that the SWI-based functions implemented in skill **SWI_KB_Prolog** are now accessible at the agent level. 
2. Make your agents use capacity **KB_PROLOG** (and its default skill **SWI_KB_Prolog**), and use what it provides directly in the agent. 
As soon as the agent aquires the skill, a Prolog engine will be created by the skill. Then the agent for example can load a KB by consulting the file: `consult_file('myKB.pl')`.
3. The lowest level will not even use the Prolog capacity and skill provided here, but will directly access SWI-Prolog via the Mochalog API, for example, by creating a prolog engine in the initialization of agents, etc.

We describe the above strategies with more detail now. The first two options are preferred as they hide the details of Mochalog, which can be a bit difficult to understand at first glance.

### 1 - Creating a domain-specific Knowlwedge-base capacity/skill.

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

                    // This action comes (is inherited) from KB_Prolog directly
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

### 2 - Directly using the capacity and skill in agents.

Here, instead of creating a domain capacity and skill for the common Prolog accesses that the application will do (e.g., common queries), we can make the agents
directly use the `KB_Prolog` capacity. This means that the behaviors of the SARL agent will make the Prolog access directly:


				setSkill(new SWI_KB_Prolog("agent23"))

				// Load agent knowledge base
				consult_file("src/main/prolog/sweeper_elevator_agent.pl")
				reportMessage("I have loaded the SWI KB successfully!")		
				
				on CarRequestPercept 
				{
					reportPersonRequestedService(occurrence.floor, occurrence.direction)

					// Add car request to our beliefs
					assertFirst("open_car_request(@I, @A)", occurrence.floor, occurrence.direction.name)

                    // This action comes (is inherited) from KB_Prolog directly
					kb_dump()
				}



### 3 - SWI-Prolog Access via Mochalog

In this approach, we directly use SWI-Prolog via the Mochalog high-level infrastructure, which provides a more abstract and accessible interface than JPL itself. 

Here is some example code of its use (though for another application) in an elevator controllre:

```
#!java

		import io.mochalog.bridge.prolog.PrologContext
		import io.mochalog.bridge.prolog.SandboxedPrologContext
		import io.mochalog.bridge.prolog.query.Query

		// Set-up Prolog knowledgebase
		var prolog_kb : PrologContext
		val beliefSpace = String.format("swiplayer")
		prolog_kb = new SandboxedPrologContext(beliefSpace)
		prolog_kb.importFile("src/main/prolog/masssim_coordinator.pl") // newest version

		// Assert percepts in the KB
		prolog_kb.assertFirst("percepts(@A, @I, @S)", agentName, agents.get(agentName).step, percepts.toString)

		// Querying one solution - Tell the KB to process last percept
		agents.keySet().forEach([ agentName : String |
			prolog_kb.askForSolution(Query.format("process_last_percepts(" + agentName + ")"))
		])
		
		// Querying all solutions - Report percepts available in the KB
		val query = Query.format("percepts(Agent, Step, Percepts)")
		for (solution : prolog_kb.askForAllSolutions(query))
		{
			System.out.format("Information for agent %s on step %d\n", solution.get("Agent").toString(),  solution.get("Step").intValue)
		}
		

```

## TROUBLESHOOTING

* Did you get something like this?

			ERROR: /usr/lib/swi-prolog/library/process.pl:53:
				/usr/lib/swi-prolog/library/process.pl:53: Initialization goal raised exception:
				'$open_shared_object'/3: /usr/lib/swi-prolog/lib/amd64/process.so: undefined symbol: Sfilefunctions
			ERROR: /usr/lib/swi-prolog/library/prolog_pack.pl:52:
				Exported procedure process:process_kill/2 is not defined
			ERROR: /usr/lib/swi-prolog/library/prolog_pack.pl:52:
				Exported procedure process:process_group_kill/2 is not defined
			ERROR: /usr/lib/swi-prolog/library/prolog_pack.pl:52:
				Exported procedure process:process_wait/3 is not defined
			java: symbol lookup error: /usr/lib/swi-prolog/lib/amd64/readutil.so: undefined symbol: PL_new_atom

	Then you may not have set `LD_PRELOAD` env variable correctly.


## CONTACT 

* Sebastian Sardina (ssardina@gmail.com)



## LICENSE 

This project is using the GPLv3 for open source licensing for information and the license visit GNU website (https://www.gnu.org/licenses/gpl-3.0.en.html).

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
