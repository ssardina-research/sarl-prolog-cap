# SARL Capacity for Prolog Knowledge Bases

This project provides a Prolog knowledge-base capacity for SARL agents and two skills for it using [SWI Prolog](http://www.swi-prolog.org/). 

The Prolog capacity/skills can be used as _belief representation and reasoning_ system for agents, as a replacement of Java data-structures. Doing so generally yields much more succinct and declarative agent systems.

The package provides:

* Capacity **KB_Prolog** (under package `io.sarl.extras`) specifying the actions to provide Prolog access to SARL agents.
* Skill **SWIJPL_KB_Prolog** implementing the capacity via [SWI Prolog](http://swi-prolog.org) and [JPL](https://jpl7.org) framework, which provide a high-level view and API of SWI Prolog in Java.

This package can be obtained via Maven using JitPack: <https://jitpack.io/#ssardina-agts/sarl-prolog-cap>

Version convention: Major.Minor.<SARL Version>. For example, 1.3.0.10.0 is version 1.3 for SARL 0.10.0.

----------------------------------
## TABLE OF CONTENTS

<!--ts-->
* [TABLE OF CONTENTS](#table-of-contents)
* [PRE-REQUISITES](#pre-requisites)
* [DEVELOP CAPACITY/SKILL FURTHER](#develop-capacityskill-further)
* [USING SARL-PROLOG-CAP IN YOUR SARL APPLICATION VIA MAVEN](#using-sarl-prolog-cap-capcityskill-in-your-sarl-application-via-maven)
* [WHAT IS PROVIDED IN THIS CAPACITY/SKILL](#what-is-provided-in-this-capacityskill)
	* [Capacity KB_PROLOG: general actions for Prolog access from SARL agents](#capacity-kb_prolog-general-actions-for-prolog-access-from-sarl-agents)
	* [Skill SWIJPL_KB_Prolog: concrete implementation using SWI Prolog and JPL interface](#skill-swijpl_kb_prolog-concrete-implementation-using-swi-prolog-and-jpl-interface)
* [USING SWI-Prolog IN SARL AGENTS/APPLICATIONS](#using-swi-prolog-in-sarl-agentsapplications)
	* [1 - Creating a domain-specific Knowledge-base capacity/skill.](#1---creating-a-domain-specific-knowledge-base-capacityskill)
	* [2 - Directly using the capacity and skill in agents.](#2---directly-using-the-capacity-and-skill-in-agents)
	* [3 - SWI-Prolog Access via JPL](#3---swi-prolog-access-via-jpl)
* [TROUBLESHOOTING](#troubleshooting)
* [CONTACT](#contact)
* [LICENSE](#license)

<!-- Added by: ssardina, at: 2020-01-11T22:24+11:00 -->

<!--te-->


----------------------------------
## PRE-REQUISITES

This capacity & skill requires [SWIPL with JPL installed for use](https://jpl7.org/DeploymentLinux):

* [SWIPL](http://www.swi-prolog.org/): this is the actual SWI Prolog system, including its main library ``libswipl.so/dll/dylib`.
	* Use either stable version 7.6.4 (available in standard Linux repos) or, better, compile and install 8.1.x from [SWI-devel repo](https://github.com/SWI-Prolog/swipl-devel). 
	* Unfortunately, the official 8.0.x versions in the PPA repo have issues with the `libswipl.so/dll/dylib` library and makes JPL crash; see [issue](https://github.com/ssardina-research/packages-jpl/issues/21). It has been fixed in the git repo though, but you need to compile manually yet.
* [SWI JPL](https://jpl7.org/) bidirectional SWI-Java interface. In Linux Ubuntu it is provided by package `swi-prolog-java`. It has two parts: 
	* _Native library_ `libjpl.so/dll/dylib`: This is the C library implementing the interface between SWIPL and Java. 
	* _jpl.pl_: This is a SWI Prolog library providing the [Prolog API](https://jpl7.org/PrologApiOverview) to access Java from Prolog.
	* _Java API_: this is the `jpl.jar` that provides the [Java API](https://jpl7.org/JavaApiOverview) to access Prolog from Java. 
		* The package `swi-prolog-java` provided in standard distributions (e.g., Ubuntu) come with JPL 7.5.0 (in Linux, in `/usr/lib/swi-prolog/lib/jpl.jar`), which is very old.
	    * The [PPA](https://www.swi-prolog.org/build/PPA.txt) has SWIPL 8.2+ which already carries JPL 7.6.0 version. One could install this version into Maven local repo as follows:

				mvn install:install-file -Dfile=/usr/local/swipl-git/lib/swipl/lib/jpl.jar \
						-DgroupId=com.github.SWI-Prolog -DartifactId=packages-jpl \
						-Dversion=7.6.0 -Dpackaging=jar

		
		* Still, SARL-PROLOG-CAP will grab the latest version from the official repo, by obtaining the [latest SNAPSHOT in the maven branch](https://github.com/SWI-Prolog/packages-jpl/tree/maven).
		
	
Here are some [good examples on how to use JPL](https://github.com/SWI-Prolog/packages-jpl/blob/master/examples/java/) from Java.

Besides the above being installed, it is also very important to tell your system and application where Prolog is and the above components can be found. To do so, one may need to set-up a few environment variables, like `LD_LIBRARY_PATH` and `LD_PRELOAD` (to find native `.so/dll/dylib` libraries), `CLASSPATH` (to point to `jpl.jar`) and `SWI_HOME_DIR` (to point to SWIPL home dir). Please refer to [this guide](https://jpl7.org/DeploymentLinux) on JPL documentation.


----------------------------------
## DEVELOP CAPACITY/SKILL FURTHER

To _develop_ this capacity/skills framework, clone the repo (or your fork) and set-up everything as if you were going to use it.

To test all is working, you can do:

1. Build the framework: `mvn clean package`
2. Run basic JPL-based unit test (no SARL, just connectivity to JPL): `mvn surefire:test -DskipTests=false`
3. Run two SARL tsest agents via `mvn exec:java` (which will run booting agent `BootTestAgt`):
	* `io.sarl.extras.TestAgt_SWIJPL`: dummy agent testing JPL-based skill **SWIJPL_KB_Prolog**. Check [source here](src/main/sarl/io/sarl/extras/TestAgt_SWIJPL.sarl).
	* `io.sarl.extras.TestAgt_SWIJPL_MT`: dummy agent testing JPL-based skill **SWIJPL_KB_Prolog** on multi-threaded queries. Check [source here](src/main/sarl/io/sarl/extras/TestAgt_SWIJPL_MT.sarl).
4. Check the source of the above two test agents to see the types of queries, from simple to more complex, that one could do.

_NOTE:_ the test agents in step 3 will at the end dump the Prolog databases into directory `my_dump_test`.

----------------------------------
## USING SARL-PROLOG-CAP IN YOUR SARL APPLICATION VIA MAVEN 

To add the dependency to this capacity/skills in your SARL application, you can use Maven with JitPack, by adding this dependency and repository in to your `pom.xml`:

```xml

<!--  SARL PROLOG CAPACITY -->
<dependency>
    <groupId>com.github.ssardina-agts</groupId>
    <artifactId>sarl-prolog-cap</artifactId>
    <version>4.0.0.10.0</version>
</dependency>

<!-- JitPack used for remote installation of dependencies from Github and Bitbucket -->
<repository>
    <id>jitpack.io</id>
    <name>JitPack Repository</name>
    <url>https://jitpack.io</url>
</repository>
```

The JitPack link for this repository is [here](https://jitpack.io/#ssardina-agts/sarl-prolog-cap). 


----------------------------------
## WHAT IS PROVIDED IN THIS CAPACITY/SKILL  

### Capacity KB_PROLOG: general actions for Prolog access from SARL agents

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


### Skill `SWIJPL_KB_Prolog`: concrete implementation using SWI Prolog and JPL interface

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

```java

assertFirst("agentName(?)", mySARLname)	// myName is a string

val solution = askOnce("get_player_last_loc(?, ?, Lat, Long)", eisName, 23)
if (solution !== null) {
		agent_says(
			"Player **{0}** location is ({1},{2}) and charge is {3} at step {4}", 
			eisName,
			solution.get("Lat").floatValue,
			solution.get("Long").floatValue,
			solution.get("Charge").floatValue,
			solution.get("Step").intValue
			)
	} else {
```
		
		
In this skill one can pass Prolog a Java object, and SWI will be able to use it (e.g., call a method on it). For example:
		
```java

// JREF
val int_obj : Integer = new Integer(232)
solution = askOnce("print_integer(?, ?)", JPL.newJRef(int_obj), "N")
if(solution === null) return false
info("Solution for N: {0}", solution.get("N").intValue)
```

while the Prolog counterpart is:

```prolog

%% Check what can you do from Prolog to call Java: http://www.swi-prolog.org/pldoc/man?section=jpl
print_integer(JRef, X2) :-
%    jpl_get(JRef, intValue, X),         % this if it is accessing a field
    jpl_call(JRef, intValue, [], X),    % X should be the int value of object Integer JRef
    jpl_ref_to_type(JRef, T),           % T should be class([java,lang],[Integer])
    jpl_type_to_classname(T, ClassName),    % ClassName should be java.lang.Integer
    X2 is X+1,
    format(string(Text), "MESSAGE FROM PROLOG: The integer value of JAVA object (~s) is ~d", [ClassName, X2]),
    writeln(Text).	
```


To see what you can do from Prolog in terms of Java objects, refer to the [Prolog API](https://jpl7.org/PrologApiOverview.jsp) section in the JPL home page.




----------------------------------
## USING SWI-Prolog IN SARL AGENTS/APPLICATIONS

There are basically three ways one can use SWI-Prolog inside SARL agents, depending on the level of abstraction:

1. **[RECOMMENDED]** Create a capacity **KB_Domain** for your domain application that embodies the usual KB queries required, and a skill **SWI_KB_Domain** for it extending skill **SWIJPL_KB_Prolog** (which implements general Prolog capacity **KB_Prolog**) from the SARL Prolog Capacity framework that implements those queries. The SARL agent will use this capacity and skill.
2. Make the agents directly use capacity **KB_PROLOG** (and its default skill **SWIJPL_KB_Prolog**). As soon as the agent acquires such a skill, a Prolog engine will be created by the skill. Then the agent for example can load a KB by consulting the file: `consult_file('myKB.pl')`. This is similar to the first option but the code will be in the SARL agent itself rather than encapsulated in a domain capacity/skill.
3. Make the agents directly access SWI-Prolog via the Mochalog or JPL APIs (depending which skill you use), for example, by creating a Prolog engine in the initialization of agents, etc.


### 1 - Creating a domain-specific Knowledge-base capacity/skill.

This is the recommended approach. The idea is to create a capacity **KB_Domain** for your domain application that embodies the usual KB queries required, and a corresponding skill **SWI_KB_Domain** for it that _extends_ the base **SWIJPL_KB_Prolog** skill (which itself implements general Prolog capacity **KB_Prolog**) from the SARL Prolog Capacity framework that implements those queries. 

The domain-dependent **SWI_KB_Domain** skill will have access to all the SWI Prolog tools provided in skill **SWIJPL_KB_Prolog** and can implement the domain queries via SWI queries using the Mochalog and JPL infrastructures.
 
Under this approach, the SARL agent will:
	* Use capacity **KB_Domain**, which is the capacity for the queries of the domain.
		* A SARL agent will only use the queries provided by this capability via its functions.
	* Use skill **SWI_KB_Domain**, which implements capacity **KB_Domain** and extends **SWIJPL_KB_Prolog**.
		* It is this skill that will perform Prolog queries via the Prolog tools offered by **KB_Prolog**.

Note that the functions in built-in **SWIJPL_KB_Prolog** will _NOT_ be visible to the SARL agent itself, who can only access functions defined in domain capacity **KB_Domain**. If the SARL agent wants to do direct Prolog queries, it can also use capacity **KB_Prolog**, which means that the SWI-based functions implemented in skill **SWIJPL_KB_Prolog** are now accessible at the agent level. 


Here are the steps to this approach:

1. To start, create a capacity **C** for your application that provides the main queries to your domain.
	* For example, `KB_Elevator` capacity for an elevator domain with functions such as:
		* `kb_load(file : String)`: load the KB encoded in a file.
		* `kb_registerCarRequest(floor : int, dir : String)`: register that there has been a request in a floor towards a direction.
		* `kb_getNextJob() : Pair<Integer, Direction>`: get the next job (floor & direction) to serve. (see the [Pair](http://gangmax.me/blog/2017/10/10/how-to-return-multiple-values-from-a-java-method/) class)
	* Observe this capacity can be implemented in many ways, for example, with plan Java.
2. Create a skill **S** for the capacity **C** that will be a Prolog Knowledgebase.
	* The skill will *extend* a skill for **KB_Prolog**, for example it can extend the skill `SWIJPL_KB_Prolog`. This means that everything in the **KB_Prolog** capacity will be available in **S** so that **S** can use Prolog to implement the domain queries. For example:
		
```java

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
```

3. Your application will use skill **S** (for domain capacity **C**):

```java

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
```

### 2 - Directly using the capacity and skill in agents.

Here, instead of creating a domain capacity and skill for the common Prolog accesses that the application will do (e.g., common queries), we can make the agents use the **KB_Prolog** capacity directly. This means that the behaviors of the SARL agent will access Prolog  directly via the skill implementing the generic **KB_Prolog** capacity.


If you use the built-in **SWIJPL_KB_Prolog** skill (that implements **KB_Prolog** using SWI Prolog):

```java

setSkill(new SWIJPL_KB_Prolog("agent23"))

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
```




### 3 - SWI-Prolog Access via JPL 

In this approach, we directly use SWI-Prolog via the JPL high-level infrastructure, without going via any SARL skill/capacity.

Here is some example code of JPL-based use (though for another application) in an elevator controller. Please observe the use of a module name to encapsulate the beliefset of the particular agent:

```java

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



----------------------------------
## TROUBLESHOOTING

* Did you get something like this?

```shell

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
```

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
