
% .\dlv.mingw.exe OWL2_RL\OWL2_RL_reasoner_with_DLV.asp OWL2_RL\tests\04_test_cls-uni-dlv.asp

% TEST cls-uni-dlv


t(iri(":X"), iri("rdf:type"), iri(":UNION")).

t(bnode("_:b0"), iri("rdf:first"), iri(":CLASS1")).
t(bnode("_:b0"), iri("rdf:rest"), bnode("_:b1")).
t(bnode("_:b1"), iri("rdf:first"), iri(":CLASS2")).
t(bnode("_:b1"), iri("rdf:rest"), bnode("_:b2")).
t(bnode("_:b2"), iri("rdf:first"), iri(":CLASS3")).
t(bnode("_:b2"), iri("rdf:rest"), iri("rdf:nil")).

t(iri(":UNION"), iri("owl:unionOf"), bnode("_:b0")).

% RESULT:
% 3 possible solutions
% {t(iri(":X"),iri("rdf:type"),iri(":CLASS1"))}
% {t(iri(":X"),iri("rdf:type"),iri(":CLASS2"))}
% {t(iri(":X"),iri("rdf:type"),iri(":CLASS3"))}


