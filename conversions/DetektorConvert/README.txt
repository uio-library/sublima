
STEP 1 - extract correct resources from convered version (excluding subject)
-----------------------------------------------
java arq.sparql --query dquery1.sparql --data detektor-robert\(2008-11-10-2\).ttl > detektor1.ttl



STEP 2 - extract correct publishers from converted version
------------------------------------------
java arq.sparql --query dquery2.sparql --data detektor-robert\(2008-11-10-2\).ttl > detektor2.ttl



STEP 3  - extract correct users from converted version
---------------------------------------------------
java arq.sparql --query dquery3.sparql --data detektor-robert\(2008-11-10-2\).ttl > detektor3.ttl

STEP 3b - extract committers
-----------------------
java arq.sparql --query dquery3b.sparql --data detektor-robert\(2008-11-10-2\).ttl > detektor3b.ttl 



STEP 4  - extract correct statuses from converted version
---------------------------------------------------
java arq.sparql --query dquery4.sparql --data detektor-robert\(2008-11-10-2\).ttl > detektor4.ttl


STEP 4a - extract statuses from the current system
--------------------------------------------------
against 
http://detektor.sublima.computas.com:8180/detektor/testsparql
run the query in file dquery4a.sparql
save results as detektor4a.ttl
open the file and remove unneeded namespaces (keep status, rdfs and wdr) 



STEP 5  - extract correct audience from converted version
---------------------------------------------------
java arq.sparql --query dquery5.sparql --data detektor-robert\(2008-11-10-2\).ttl > detektor5.ttl



STEP 6 - concatenate the previous files into one model
---------------------------------------------------
java jena.rdfcat -out Turtle detektor1.ttl detektor2.ttl detektor3b.ttl detektor3.ttl detektor4.ttl detektor4a.ttl detektor5.ttl > detektor6.ttl



STEP 7 - correct errors in status URLs at conversion time 
--------------------------------------------------
java -cp $CLASSPATH:. Sparul -filemodel detektor6.ttl Turtle -query dquery7.sparul > detektor7.ttl 



STEP 8 - add multiple language to some posts
---------------------------------------------------
java jena.rdfcat -out Turtle detektor7.ttl mulitple.languages3.n3  >detektor8.ttl



STEP 9 - add dcmi types
---------------------------------------------------
java jena.rdfcat -out Turtle detektor8.ttl dcmitypes.ttl  > detektor9.ttl


STEP 10 - add correct topics/concepts
----------------------------------------------------
from the detektor-asgeir(2008-10-01).ttl we extract the right Concepts and their relations

java arq.sparql --query dquery10.sparql --data detektor-asgeir\(2008-10-01\).ttl > detektor10.ttl


STEP 11 - extract correct relationships between topics and resources
----------------------------------------------------
from the detektor-asgeir(2008-10-01).ttl we extract the right relationships between topics and resources

java arq.sparql --query dquery11.sparql --data detektor-asgeir\(2008-10-01\).ttl > detektor11.ttl


STEP 12 - concatenate topics and their relations
-------------------------------------------------
java jena.rdfcat -out Turtle detektor10.ttl detektor11.ttl  >detektor12.ttl


STEP 12b - fix namespaces
-------------------------------------------------
in detektor12.ttl remove all namespaces, and replace them with the following 
 @base <http://detektor.sublima.computas.com:8180/detektor/> .
 @prefix :        <http://detektor.sublima.computas.com/detektor/> .
 @prefix topic:   <topic/> .
 @prefix sub:     <http://xmlns.computas.com/sublima#> .
 @prefix xsd:     <http://www.w3.org/2001/XMLSchema#> .
 @prefix rdfs:    <http://www.w3.org/2000/01/rdf-schema#> .
 @prefix skos:    <http://www.w3.org/2004/02/skos/core#> .
 @prefix rdf:     <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
 @prefix dct:     <http://purl.org/dc/terms/> .


STEP 13  - verify in protege
------------------------------------------------
convert to rdf/xml
java jena.rdfcopy detektor12.ttl Turtle RDF/XML > detektor12.rdf
load in protege and remember to add information-model.rdf and sublima-ns.rdf


STEP 14 - merge ontology and resources
------------------------------------------------
java jena.rdfcat -out Turtle detektor9.ttl detektor12.ttl  >detektor14.ttl


STEP 14b - verify namespaces
-----------------------------------------------
make sure the namespaces are like this

 @base              <http://detektor.sublima.computas.com:8180/detektor/> .
 @prefix :          <http://detektor.sublima.computas.com:8180/detektor/> .
 @prefix topic:     <topic/> .
 @prefix user:      <user/> .
 @prefix resource:  <resource/> .
 @prefix status:    <status/> .
 @prefix agent:     <agent/> .
 @prefix audience:  <audience/> .
 @prefix sub:       <http://xmlns.computas.com/sublima#> .
 @prefix xsd:       <http://www.w3.org/2001/XMLSchema#> .
 @prefix rdfs:      <http://www.w3.org/2000/01/rdf-schema#> .
 @prefix rdf:       <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
 @prefix skos:      <http://www.w3.org/2004/02/skos/core#> .
 @prefix owl:       <http://www.w3.org/2002/07/owl#> .
 @prefix dct:       <http://purl.org/dc/terms/> . 
 @prefix dcmitype:  <http://purl.org/dc/dcmitype/> .
 @prefix sioc:      <http://rdfs.org/sioc/ns#> .
 @prefix xsd:       <http://www.w3.org/2001/XMLSchema#> .
 @prefix wdr:       <http://www.w3.org/2007/05/powder#> .
 @prefix lingvoj:   <http://www.lingvoj.org/ontology#> .
 @prefix foaf:      <http://xmlns.com/foaf/0.1/> .


STEP 14b - add ontology statements
-----------------------------------------------
<>     rdf:type owl:Ontology ;
      protege:defaultLanguage
              "no"^^xsd:string ;
      owl:imports <http://xmlns.computas.com/sublima> , <http://protege.stanford.edu/plugins/owl/protege> , <http://xmlns.computas.com/sublima-information-model> .



STEP 15 - copy to RDF/XML for Protege
---------------------------------------------------
java jena.rdfcopy detektor15.ttl Turtle RDF/XML > detektor-test-data.rdf

