# SARL Capacity for Prolog Knowledge Bases

This project provides a Prolog knowledge-base capacity for SARL agents and TWO skills for it using [SWI Prolog](http://www.swi-prolog.org/). The Prolog capacity/skill can be used as belief representation for agents, as a replacement of Java data-structures. This yield much more succinct and declarative agent systems.

The capacity provided is **KB_Prolog** (under package `io.sarl.extras`). The skills are **SWI_KB_Prolog** and **SWIJPL_KB_Prolog**.

The skills implementing the capacity rely on [Mochalog](https://github.com/ssardina/mochalog) and [JPL](https://jpl7.org) frameworks, which provide a high-level view and API of SWI Prolog in Java.

This package can be obtained via Maven using JitPack: <https://jitpack.io/#org.bitbucket.ssardina-research/sarl-prolog-cap>

Version convention: Major.Minor.<SARL Version>. For example, 1.3.0.7.2 is version 1.3 for SARL 0.7.2.

----------------------------------
## TABLE OF CONTENTS

[TOC]

----------------------------------
## PRE-REQUISITES

The capacity and skills depend on the following two systems/frameworks:

* [SWI Prolog](http://www.swi-prolog.org/) (>7.4.x).
* [SWI JPL](http://www.swi-prolog.org/pldoc/doc_for?object=section(%27packages/jpl.html%27)) Bidirectional interface with Java:
	* Main Page for JPL: <https://jpl7.org/> 
	* Github development repository: <https://github.com/SWI-Prolog/packages-jpl>
		* Forked version being used: <https://github.com/ssardina/packages-jpl>
	* In Linux Ubuntu JPL is provided by package `swi-prolog-java`.
	* In Windows, the Java-SWI interface it can be installed as part of the main install.
		* Check some [good examples on how to use JPL](https://github.com/SWI-Prolog/packages-jpl/blob/master/examples/java/) including the good [Family Example]([good examples on how to use JPL](https://github.com/SWI-Prolog/packages-jpl/blob/master/examples/java/Family/Family.java)). 
* [Mochalog](https://github.com/ssardina/mochalog), an even higher abstraction than JPL.
	* Required only by skill **SWI_KB_Prolog**.
	* Obtained via Maven automatically using from [JitPack](https://jitpack.io/#ssardina/mochalog)
	* Check Mochalog page for prerequisites, install, and examples.


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
	


----------------------------------
## Develop it further

To _develop_ this capacity/skills framework further, one would need:

* Java Runtime Environment (JRE) and Java Compiler (javac) v1.8 (Sun version recommended)
* Maven project management and comprehension tool (to meet dependencies, compile, package, run).
* SARL modules and execution engine 
	* Version defined by environment variable `SARL_VERSION`; for example `export SARL_VERSION=0.7.2`
	* Version tested: 0.6.1, 0.7.2
	* Obtained via Maven automatically from http://mvnrepository.com/artifact/io.sarl.maven.
	
To verify you have everything setup well, run `mvn clean package` first. 
This will run some unit testing on JPL itself (file `src/test/java/io/sarl/extras/JPLTest.java`. 
Furthermore, you can then run the SARL test agents:
	
	* `io.sarl.extras.TestAgt_SWI`: dummy agent testing Mochalog-based skill **SWI_KB_Prolog**. Check [source here](src/main/sarl/io/sarl/extras/TestAgt_SWIJPL.sarl).
	* `io.sarl.extras.TestAgt_SWIJPL`: dummy agent testing JPL-based skill **SWI_KB_Prolog**. Check [source here](src/main/sarl/io/sarl/extras/TestAgt_SWI.sarl).

Both test agents are registered in the `BootTestAgt` class, which if run with no arguments will ask which agent test to execute. You can run that booting class by doing: `mvn -o exec:java`. Both tests will at the end dump the Prolog databases into directory `my_dump_test`.

Check the source of the above two test agents to see the types of queries, from simple to more complex, that one could do.

----------------------------------
## Include capacity/skills in your SARL application via Maven 

To add the dependency to this capacity/skills in your SARL application, you can use Maven with JitPack, by adding this dependency and repository in to your `pom.xml`:

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

The JitPack link for this repository is here](https://jitpack.io/#org.bitbucket.ssardina-research/sarl-prolog-cap).
Replace `-SNAPSHOT` by the specific version (e.g., commit id) you want to use in your application.


----------------------------------
## WHAT IS PROVIDED:  

### CAPACITY KB_PROLOG

This `KB_Prolog` capacity provides the following hooks to Prolog access:

* KB system tools:
	* `consult_file(file : String)`: consult file into Prolog engine.
	* `dump_kb()`: dump the current knowledgebase to a file with timestamp and registered name for kb.
	* `dump_kb(id : String)`: : dump the current knowledgebase to a file with timestamp and name of kb.
	* `get_prolog_engine()	: Object`: gives the prolog reference.
	* `get_kb_name() : String`: gives the registered name of the kb.
	* `set_dump_root(dir : String)`: set the root directory where to dump KBs.
* Assert and retract predicates:
	* `assertFirst(queryS : String, params : Object*)`
	* `assertLast(queryS : String, params : Object*)`
	* `retract(queryS : String, params : Object*)`
	* `retractAll(queryS : String, params : Object*)`
* Queries:
	* `prove(queryS : String, params : Object*) : boolean`: prove if a queryS is true
	* `askOnce(queryS : String, params : Object*) : Map<String, Term>`: ask a query and get first result.
	* `askForAllSolutions(QueryS : String, params : Object*) : Collection<Map<String, Term>>`: return the set of all solutions as set of bindings.
	* `ask(queryS : String, params : Object*) : Iterator`: returns an iterator to solutions.
	* `ask2(queryS : String, params : Object*) : Iterator`: returns an iterator to solution bindings `Map<String,Term>`.


### SKILL `SWIJPL_KB_Prolog` (via JPL) [RECOMENDED]

This skill is the recommended one to use and basically relies directly on the [JPL infrastructure](https://jpl7.org/).
The main tools at disposal to extend this skill are JPL:

* `Query.hasSolution`: boolean result answering whether the query is true or not.
* `Query.oneSolution`: a `Map<String,Term>` returning a binding if there is a solution to the query, otherwise `null`.
* `Query.allSolution`: an array `Map<String,Term>[]` returning a set of bindings for all solutions (length zero if no solutions available).
* `Query.allSolution`: an array `Map<String,Term>[]` returning a set of bindings for all solutions (length zero if no solutions available).
* `Query.hasNext()`: boolean stating whether there is a "next" solution available for the query. Will re-start the query if it is executed again after being false.
* `Query.next()`: returns the next solution, in the form of a `Map<String,Term>`, if there is one. Exception if we have already arrived to the last one.

So what does the skill provide beyond JPL itself? In a nutshell, two things:

1. Automatic handling of local agent KB, so that each agent can keep its own KB. This is done by using [SWI modules](http://www.swi-prolog.org/pldoc/man?section=modules), because the Prolog engine itself is the same for everyone.
	* Read this [detailed tutorial on SWI Prolog modules](http://chiselapp.com/user/ttmrichter/repository/gng/doc/trunk/output/tutorials/swiplmodtut.html).
2. A higher abstraction in queries when using placeholders `?`. To fill the placeholders, we do not need to create specific JPL terms (such as JPL `Atom`, `Integer`, `Float`, `Compound`, `JRef`, or `Variable`), but we can just write the content and the skill will figure out its type:
	* If it is a string starting with a capital letter, then it is a variable term, e.g., `X` or `Numero`.
	* If it is a number without decimals, it is an integer term, e.g., `23` or `123`.
	* If it is a number with decimals, it is a float term, e.g., `23.21`.
	* If it is quoted with, then it is an atom, e.g., `this is a complex(123) atom`.
	* If nothing above applies, and has no `(`, `[` or `is`, then it is also an atom, e.g., `hello` or `sebastian`.
	* If itself is a `JRef` object, then it is indeed already a `JRef` term. 
	* Otherwise it is a compound term, like `[1,2,3,4]`, `father(maria, john)`, or `X is Y + 23`.
	

To state placeholders, use the `?` symbol and a string, number or JRef filler, such as:

		assertFirst("agentName(?)", mySARLname)	// myName is a string
		
		val solution = askOnce("get_player_last_loc(?, ?, Lat, Long)", playerName, 23)
		if (solution !== null) {
				agent_says(
					"Player **{0}** location is ({1},{2}) and charge is {3} at step {4}", 
					playerName,
					solution.get("Lat").floatValue,
					solution.get("Long").floatValue,
					solution.get("Charge").floatValue,
					solution.get("Step").intValue
					)
			} else {
		
		
In this skill one can pass Prolog a Java object, and SWI will be able to use it (e.g., call a method on it). For example:
		
		// JREF
		val int_obj : Integer = new Integer(232)
		solution = askOnce("print_integer(?, ?)", JPL.newJRef(int_obj), "N")
		if(solution === null) return false
		info("Solution for N: {0}", solution.get("N").intValue)

while the Prolog counterpart is:

		%% Check what can you do from Prolog to call Java: http://www.swi-prolog.org/pldoc/man?section=jpl
		print_integer(JRef, X2) :-
		%    jpl_get(JRef, intValue, X),         % this if it is accessing a field
		    jpl_call(JRef, intValue, [], X),    % X should be the int value of object Integer JRef
		    jpl_ref_to_type(JRef, T),           % T should be class([java,lang],[Integer])
		    jpl_type_to_classname(T, ClassName),    % ClassName should be java.lang.Integer
		    X2 is X+1,
		    format(string(Text), "MESSAGE FROM PROLOG: The integer value of JAVA object (~s) is ~d", [ClassName, X2]),
		    writeln(Text).	


To see what you can do from Prolog in terms of Java objects, refer to the [Prolog API](https://jpl7.org/PrologApiOverview.jsp) section in the JPL home page.



----------------------------------
### SKILL `SWI_KB_Prolog` (via Mochalog)

The `SWI_KB_Prolog` is built on top of the [Mochalog](https://github.com/ssardina/mochalog) framework for more high-level access to SWI Prolog via the JPL interface. The implementation of the above primitives is, basically, by using the Mochalog API. In turn, Mochalog relies on JPL](https://jpl7.org/) framework.

Some useful notes:

* Refer to the [Mochalog](https://github.com/ssardina/mochalog) readme to understand how to build queries using Mochalog (e.g., using `@` placeholders).
* Mochalog API does not allow passing Java objects (`JRef`) to Prolog (the JPL-based skill does!). 
* To handle responses from Prolog, where variables are grounded to Terms, we use the [Term](http://www.swi-prolog.org/packages/jpl/java_api/javadoc/jpl/Term.html) class form JPL
* To handle pairs of variable name and term unified to, use [Pair](http://gangmax.me/blog/2017/10/10/how-to-return-multiple-values-from-a-java-method/) class; see example below.
* The function `ask(queryS : String, params : Object*) : Iterator`: returns a Mochalog's `QuerySolutions` iterator. You can get the actual variable to term mappings via method `.bindings`
* The `params` arguments above refer to [SARL variadic](http://www.sarl.io/docs/official/reference/general/FuncDecls.html#4-variadic-function) arguments (in Java, called [Varargs](https://www.geeksforgeeks.org/variable-arguments-varargs-in-java/)) to help build the query string by "filling" places using `@A`, `@I`, and `@S` placeholders. For example:

```
assertFirst("percepts(@A, @I, @S)", agentName, agents.get(agentName).step, percepts.toString)
```

An alternative, Java-based way to construct the query string, is to use [`String.format`](https://docs.oracle.com/javase/7/docs/api/java/util/Formatter.html):

```
assertFirst(String.format("percepts(\'%s\', %d, %s)", agentName, agents.get(agentName).step, percepts.toString))
```

See how single-quoted was used here to make sure agentName becomes an atom (and not a string!).



----------------------------------
## USING SWI-Prolog IN SARL AGENTS/APPLICATIONS

There are basically three ways one can use SWI-Prolog inside SARL agents, depending on the level of abstraction:


1. **[RECOMMENDED]** Create a capacity **KB_Domain** for your domain application that embodies the usual KB queries required, and a skill **SWI_KB_Domain** for it extending skill **SWI_KB_Prolog** (which implements general Prolog capacity **KB_Prolog**) in the [SARL Prolog Capacity](https://bitbucket.org/ssardina-research/sarl-prolog-cap) framework that implements those queries. The SARL agent will use this capacity and skill.
2. Make the agents directly use capacity **KB_PROLOG** (and its default skill **SWI_KB_Prolog**). As soon as the agent acquires such a skill, a Prolog engine will be created by the skill. Then the agent for example can load a KB by consulting the file: `consult_file('myKB.pl')`. This is similar to the first option but the code will be in the SARL agent itself rather than encapsulated in a domain capacity/skill.
3. Make the agents directly access SWI-Prolog via the Mochalog or JPL APIs (depending which skill you use), for example, by creating a Prolog engine in the initialization of agents, etc.



### 1 - Creating a domain-specific Knowledge-base capacity/skill.

This is the recommended approach. The idea is to create a capacity **KB_Domain** for your domain application that embodies the usual KB queries required, and a corresponding skill **SWI_KB_Domain** for it that _extends_ the base **SWI_KB_Prolog** skill (which itself implements general Prolog capacity **KB_Prolog**) in the [SARL Prolog Capacity](https://bitbucket.org/ssardina-research/sarl-prolog-cap) framework that implements those queries. 

The domain-dependent **SWI_KB_Domain** skill will have access to all the SWI Prolog tools provided in skill **SWI_KB_Prolog** and can implement the domain queries via SWI queries using the Mochalog and JPL infrastructures.
 
Under this approach, the SARL agent will:
	* Use capacity **KB_Domain**, which is the capacity for the queries of the domain.
		* A SARL agent will only use the queries provided by this capability via its functions.
	* Use skill **SWI_KB_Domain**, which implements capacity **KB_Domain** and extends **SWI_KB_Prolog**.
		* It is this skill that will perform Prolog queries via the Prolog tools offered by **KB_Prolog**.

Note that the functions in **SWI_KB_Prolog** will _NOT_ be visible to the SARL agent itself, who can only access functions defined in domain capacity **KB_Domain**. If the SARL agent wants to do direct Prolog queries, it can also use capacity **KB_Prolog**, which means that the SWI-based functions implemented in skill **SWI_KB_Prolog** are now accessible at the agent level. 


Here are the steps to this approach:

1. Create a Capacity *C* for your application that provides the main queries to your domain.
	* For example, `KB_Elevator` capacity for an elevator domain with functions such as:
		* `kb_load(file : String)`: load the KB encoded in a file.
		* `kb_registerCarRequest(floor : int, dir : String)`: register that there has been a request in a floor towards a direction.
		* `kb_getNextJob() : Pair<Integer, Direction>`: get the next job (floor & direction) to serve. (see the [Pair](http://gangmax.me/blog/2017/10/10/how-to-return-multiple-values-from-a-java-method/) class)
	* Observe this capacity can be implemented in many ways, for example, with plan Java.
2. Create a skill *S* for the capacity *C* that will be a Prolog Knowledgebase.
	* The skill will *extend* a skill for *KB_Prolog*, for example it can extend the skill `SWIJPL_KB_Prolog`. This means that everything in the *KB_Prolog* capacity will be available in *S* so that *S* can use Prolog to implement the domain queries. For example:
		
				skill SWI_KB_Elevator extends SWIJPL_KB_Prolog implements KB_Elevator  {
		
					val logging_level : int
					new (l : int = 0, name : String) {
						super(name) // Call the super's constructor
						logging_level = l
					}
				
					def kb_registerCarRequest(floor : int, dir : String) {
						assertFirst("open_car_request(?, ?)", floor, dir)
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

				setSkill(new SWI_KB_Elevator(0, "agent23", "my_dump"))

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

Here, instead of creating a domain capacity and skill for the common Prolog accesses that the application will do (e.g., common queries), we can make the agents directly use the `KB_Prolog` capacity. This means that the behaviors of the SARL agent will make the Prolog access directly.

If you use **SWIJPL_KB_Prolog** Mochalog-based skill:

				setSkill(new SWI_KB_Prolog("agent23"))

				// Load agent knowledge base
				consult_file("src/main/prolog/sweeper_elevator_agent.pl")
				reportMessage("I have loaded the SWI KB successfully!")		
				
				on CarRequestPercept 
				{
					reportPersonRequestedService(occurrence.floor, occurrence.direction)

					// Add car request to our beliefs
					assertFirst("open_car_request(?, ?)", occurrence.floor, occurrence.direction.name)

                    // This action comes (is inherited) from KB_Prolog directly
					kb_dump()
				}

If you use **SWI_KB_Prolog** Mochalog-based skill:

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




### 3 - SWI-Prolog Access via JPL or Mochalog

In this approach, we directly use SWI-Prolog via the JPL or Mochalog high-level infrastructure.

Here is some example code of JPL-based use (though for another application) in an elevator controller. Please observe the use of a module name to encapuslate the beliefset of the particular agent:

```
#!java

		import org.jpl7.Query

		// Set-up Prolog knowledgebase
		val beliefSpace = String.format("swiplayer")
		consult(System.format("%s:(%s)", beliefSpace, "src/main/prolog/masssim_coordinator.pl") // newest version

		// Assert percepts in the KB
		Query.hasSolution(System.format("%s:percepts(?, ?, ?)", beliefSpace), agentName, agents.get(agentName).step, percepts.toString)

		// Querying one solution - Tell the KB to process last percept
		agents.keySet().forEach([ agentName : String |
			Query.oneSolution("process_last_percepts(?)", agentName)
		])
		
		// Querying all solutions - Report percepts available in the KB
		for (solution : allSolutions("percepts(Agent, Step, Percepts)"))
		{
			System.out.format("Information for agent %s on step %d\n", solution.get("Agent").toString(),  solution.get("Step").intValue)
		}
```


And here is some example code for the Mochalog-based ersion:



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
			prolog_kb.askForSolution(Query.format("process_last_percepts(@A)", agentName))
		])
		
		// Querying all solutions - Report percepts available in the KB
		val query = Query.format("percepts(Agent, Step, Percepts)")
		for (solution : prolog_kb.askForAllSolutions(query))
		{
			System.out.format("Information for agent %s on step %d\n", solution.get("Agent").toString(),  solution.get("Step").intValue)
		}
```

----------------------------------
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


----------------------------------
## CONTACT 

* Sebastian Sardina (ssardina@gmail.com)



----------------------------------
## LICENSE 

This project is using the GPLv3 for open source licensing for information and the license visit GNU website (https://www.gnu.org/licenses/gpl-3.0.en.html).

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
