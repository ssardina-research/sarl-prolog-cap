/*
 * Copyright 2018-2020 Sebastian Sardina.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
*/
package io.sarl.extras;

import org.jpl7.JPL;
import org.jpl7.PrologException;
import org.jpl7.Query;
import org.jpl7.Term;

import org.junit.Test;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.util.Map;

/**
 * Test suite for JPL (Java to Prolog direction).
 * <p>
 * Ensures SWI-Prolog code can be invoked from JVM via JPL.
 * 
 */
public class JPLTest
{
    final String helloWorldPrologFilePath = "src/test/resources/hello_world.pl";
    final String testKBFilePath = "src/test/resources/testKB.pl";

	
	/**
     * Ensure jpl.dll or libjpl.so and dependencies are able to be loaded
     * by the JVM. All subsequent tests which rely on JPL functionality
     * will fail given this test fails.
     */
    @Test
    public void isJPLNativeBinaryLoadable()
    {
        try
        {
            // Attempt to load JPL native library given
            // specified java.librry.path
            JPL.loadNativeLibrary();
        }
        catch (UnsatisfiedLinkError e)
        {
            String swiPrologHomeDir = System.getenv("SWI_HOME_DIR");

            // Check if SWI_HOME_DIR is set
            String message = "jpl library or any one of its dependencies " +
                "failed to be found.";
            if (swiPrologHomeDir == null)
            {
                fail(message + " SWI_HOME_DIR system environment variable not set.");
            }
            else
            {
                fail(message + " Ensure that the SWI_HOME_DIR/bin directory " +
                    "has been added to the system path.");
            }
        }
    }

    /**
     * Write Prolog versions using current_prolog_flag/2
     * http://www.swi-prolog.org/pldoc/doc_for?object=current_prolog_flag/2
     */
    @Test
    public void printPrologVersion()
    {
    	Term result;
        // hello_world.pl test resource
        // Filepath relative to java-api directory

        // Fetch the Term object which gets bound to the specified
        // variable
        Map<String, Term> binding = new Query("current_prolog_flag(executable, V)").oneSolution();

        result = binding.get("V");
    	System.out.println("SWI Prolog being executed: " + result.toString());

        result = new Query("current_prolog_flag(version, V)").oneSolution().get("V");
    	System.out.println("SWI Prolog version: " + result.intValue());

    
    }

    
    /**
     * Check that basic string is correctly returned from
     * SWI-Prolog via JPL query
     */
    @Test
    public void basicJavaToPrologQuery()
    {
        // hello_world.pl test resource
        // Filepath relative to java-api directory

        boolean loaded = consultKnowledgeBase(helloWorldPrologFilePath);
        assert(loaded);

        // Fetch the Term object which gets bound to the specified
        // variable
        Query query = new Query("get_hello_world(X)");
        Map<String, Term> binding = query.oneSolution();

        Term result = binding.get("X");
        // Ensure first solution string (hello) was correctly fetched
        // from Prolog file
        assertEquals("hello", result.toString());
    }

    
    /**
     * Check a query against a string
     */
    @Test
    public void stringPrologQuery()
    {
    	String queryText;
    	boolean hasSolution;
    	
        // hello_world.pl test resource
        // Filepath relative to java-api directory

        boolean loaded = consultKnowledgeBase(testKBFilePath);
        assertTrue("Test KB was not consulted successfully", loaded);

        // Check for string: even though data_string("string0") is there, JPL cannot send Strings to Prolog, it will be query as data_string(string0)
        queryText = "data_string(\"string0\")";
        hasSolution = Query.hasSolution(queryText);
        assertFalse(String.format("Solution was found for query **%s**  !!!", queryText), hasSolution);;

        // In this case will succeed because DB has data_string(string1), JPL cannot send Strings to Prolog, it will be query as data_string(string0)
        queryText = "data_string(\"string1\")";
        hasSolution = Query.hasSolution(queryText);
        assertTrue(String.format("No Solution was found for query **%s**  !!!", queryText), hasSolution);;
    }

    
    /**
     * Check a query against a string
     */
    @Test
    public void noClauseExistence()
    {
    	String queryText;
    	
    	
        // hello_world.pl test resource
        // Filepath relative to java-api directory

        boolean loaded = consultKnowledgeBase(testKBFilePath);
        assertTrue("Test KB was not consulted successfully", loaded);

        // Check for string: even though data_string("string0") is there, JPL cannot send Strings to Prolog, it will be query as data_string(string0)
        queryText = "no_clause(23)";
        try {
        	Query.hasSolution(queryText);
        } catch (PrologException e) {
        	System.out.println("Bien!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! " + e.getMessage());
        }
    }
    
    
    /**
     * Load the Prolog file at filepath into the SWI-Prolog interpreter
     * @param filePath Path of Prolog file
     * @return Success status
     */
    private boolean consultKnowledgeBase(String filePath)
    {
        String queryString = String.format("consult('%s')", filePath);
        return Query.hasSolution(queryString);
    }
}
