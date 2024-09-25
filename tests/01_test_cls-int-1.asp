
% .\dlv.mingw.exe OWL2_RL\OWL2_RL_reasoner_with_DLV.asp OWL2_RL\tests\01_test_cls-int-1.asp

% TEST cls-int-1

t(iri(":perryThePlatypus"), iri("rdf:type"), iri(":Mammal")).
t(iri(":perryThePlatypus"), iri("rdf:type"), iri(":Monotreme")).
t(iri(":perryThePlatypus"), iri("rdf:type"), iri(":VenomousMammal")).

t(bnode("_:b0"), iri("rdf:first"), iri(":Mammal")).
t(bnode("_:b0"), iri("rdf:rest"), bnode("_:b1")).
t(bnode("_:b1"), iri("rdf:first"), iri(":Monotreme")).
t(bnode("_:b1"), iri("rdf:rest"), bnode("_:b2")).
t(bnode("_:b2"), iri("rdf:first"), iri(":VenomousMammal")).
t(bnode("_:b2"), iri("rdf:rest"), iri("rdf:nil")).

t(iri(":Platypus"), iri("owl:intersectionOf"), bnode("_:b0")).

% RESULT
% t(iri(":perryThePlatypus"),iri("rdf:type"),iri(":Platypus"))