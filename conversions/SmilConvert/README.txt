STEP 0a - convert to Turtle
---------------------------
Java jena.copy smil-test-data.rdf RDF/XML Turtle > smil-test-data.ttl


STEP 0b - extract old identifiers and langauges
-----------------------------------------------
against the smil endpoint (http://smil.sublima.computas.com:8180/smil/testsparql/) run the query query0b.sparql to exract rdf. 
After completing step 0c, append this information to the file (remember to remove the @prefix statements befor appending)



STEP 0c - remove empty language statements
------------------------------------------
java Sparul -filemodel smil-test-data.ttl Turtle -query query0c.sparul > smil-test-data1.ttl



STEP 1  - add country finland, and language swedish
---------------------------------------------------
java Sparul -filemodel smil-test-data1.ttl Turtle -query query1.sparul > smil-test-data2.ttl



STEP 2  - add country sweden, and language swedish
--------------------------------------------------
java Sparul -filemodel smil-test-data2.ttl Turtle -query query2.sparul > smil-test-data3.ttl



STEP 3  - add country denmark, and language danish 
--------------------------------------------------
java Sparul -filemodel smil-test-data3.ttl Turtle -query query3.sparul > smil-test-data4.ttl


STEP 4  - add country norway, and language norwegian
----------------------------------------------------
java Sparul -filemodel smil-test-data4.ttl Turtle -query query4.sparul > smil-test-data5.ttl


STEP 5  - verify
----------------
java arq.sparql --query query5.sparql --data smil-test-data5.ttl


