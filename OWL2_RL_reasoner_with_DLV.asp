% OWL 2 RL is a subset of OWL 2 which is amenable to implementation using rule-based technologies.
% The goal of this exercise is to implement an OWL 2 RL reasoner with DLV. The only predicate
% that we are going to use is
% t(S, P, O)
% which represents a triple with subject S, predicate P and object O. In order to distinguish between
% IRIs, literals and blank nodes we can use the function symbols iri, literal and bnode.

% EXAMPLE:
% ex:bob foaf:knows _:x . _:x foaf:age 21 .
% t(iri("ex:bob"), iri("foaf:knows"), bnode("_:x")).
% t(bnode("_:x"), iri("foaf:age"), literal("21")) .

%---------------------------------------------------------------------------------------------------%

% 1️⃣ – RDFS rules Start by implementing a few rules that correspond to RDFS entailment patterns:
% prp-dom, prp-rng, scm-spo, prp-spo1, cax-sco, scm-sco.

% prp-dom
t(X, iri("rdf:type"), C) :- 
    t(P, iri("rdfs:domain"), C), 
    t(X, P, _).

% prp-rng
t(Y, iri("rdf:type"), C) :- 
    t(P, iri("rdfs:range"), C), 
    t(_, P, Y).

% scm-spo
t(P1, iri("rdfs:subPropertyOf"), P3) :- 
    t(P1, iri("rdfs:subPropertyOf"), P2),
    t(P2, iri("rdfs:subPropertyOf"), P3).

% prp-spo1
t(X, P2, Y) :- 
    t(P1, iri("rdfs:subPropertyOf"), P2), 
    t(X, P1, Y).

% cax-sco
t(X, iri("rdf:type"), C2) :- 
    t(C1, iri("rdfs:subClassOf"), C2),
    t(X, iri("rdf:type"), C1).

% scm-sco
t(C1, iri("rdfs:subClassOf"), C3) :- 
    t(C1, iri("rdfs:subClassOf"), C2),
    t(C2, iri("rdfs:subClassOf"), C3).


% 2️⃣ – Equality and class axioms Implement the rules eq-sym, eq-trans, eq-rep-s, eq-rep-p,
% eq-rep-o, eq-diff1, cax-eqc1, cax-eqc2, and cax-dw.

% eq-sym
t(Y, iri("owl:sameAs"), X) :- 
    t(X, iri("owl:sameAs"), Y).

% eq-trans
t(X, iri("owl:sameAs"), Z) :- 
    t(X, iri("owl:sameAs"), Y),
    t(Y, iri("owl:sameAs"), Z).

% eq-rep-s
t(S2, P, O) :- 
    t(S1, iri("owl:sameAs"), S2),
    t(S1, P, O).

% eq-rep-p
t(S, P2, O) :- 
    t(P1, iri("owl:sameAs"), P2),
    t(S, P1, O).

% eq-rep-o
t(S, P, O2) :- 
    t(O1, iri("owl:sameAs"), O2),
    t(S, P, O1).

% eq-diff1
:-  t(X, iri("owl:sameAs"), Y),
    t(X, iri("owl:differentFrom"), Y).

% cax-eqc1
t(X, iri("rdf:type"), C2) :- 
    t(C1, iri("owl:equivalentClass"), C2),
    t(X, iri("rdf:type"), C1).                                    

% cax-eqc2
t(X, iri("rdf:type"), C1) :- 
    t(C1, iri("owl:equivalentClass"), C2),
    t(X, iri("rdf:type"), C2). 

% cax-dw
:-  t(C1, iri("owl:disjointWith"), C2),
    t(X, iri("rdf:type"), C1),
    t(X, iri("rdf:type"), C2).

% 3️⃣ – Axioms about properties Implement the rules prp-fp, prp-ifp, prp-irp, prp-symp,
% prp-asyp, prp-trp, prp-inv1, and prp-inv2.

% prp-fp
t(Y1, iri("owl:sameAs"), Y2) :- 
    t(P, iri("rdf:type"), iri("owl:FunctionalProperty")),
    t(X, P, Y1),
    t(X, P, Y2).

% prp-ifp
t(X1, iri("owl:sameAs"), X2) :- 
    t(P, iri("rdf:type"), iri("owl:InverseFunctionalProperty")),
    t(X1, P, Y),
    t(X2, P, Y).

% prp-irp
:-  t(P, iri("rdf:type"), iri("owl:IrreflexiveProperty")),
    t(X, P, X).

% prp-symp
t(Y, P, X) :- 
    t(P, iri("rdf:type"), iri("owl:SymmetricProperty")),
    t(X, P, Y).

% prp-asyp
:-  t(P, iri("rdf:type"), iri("owl:AsymmetricProperty")),
    t(X, P, Y),
    t(Y, P, X).

% prp-trp
t(X, P, Z) :- 
    t(P, iri("rdf:type"), iri("owl:TransitiveProperty")),
    t(X, P, Y),
    t(Y, P, Z).

% prp-inv1
t(Y, P2, X) :- 
    t(P1, iri("owl:inverseOf"), P2),
    t(X, P1, Y).

% prp-inv2
t(Y, P1, X) :- 
    t(P1, iri("owl:inverseOf"), P2),
    t(X, P2, Y).

% 4️⃣ – Boolean operations (simplified) Implement the rules: cls-com, cls-int1-s, cls-int2-s,
% cls-uni-s (see Fig. 1 for the latter three).

% cls-com
:-  t(C1, iri("owl:complementOf"), C2),
    t(X, iri("rdf:type"), C1),
    t(X, iri("rdf:type"), C2).

% IN THE RULES FOR SEMPLICITY I DON'T HAVE SPECIFIED THAT X and XX MUST BE OF rdf:type rdf:List

% X and XX are the scheleton of the list, which are linked together and to the two classes
% C1 and C2, which are the elements of the list
% X --- XX --- rdf:nil
% |     |     
% C1    C2

% cls-int1-s
% C owl:intersectionOf ( C1 C2 ) AND 
% X rdf:type C1 AND
% X rdf:type C2 
% =⇒ X rdf:type C
t(Y, iri("rdf:type"), C) :- 
    t(Y, iri("rdf:type"), C1),
    t(Y, iri("rdf:type"), C2),
    t(C, iri("owl:intersectionOf"), X),
    t(X, iri("rdf:first"), C1),
    t(X, iri("rdf:rest"), XX),
    t(XX, iri("rdf:first"), C2),
    t(XX, iri("rdf:rest"), iri("rdf:nil")).

% cls-int2-s
% C owl:intersectionOf ( C1 C2 ) AND
% X rdf:type C 
% =⇒ X rdf:type C1 AND X rdf:type C2
t(Y, iri("rdf:type"), C1) :- 
    t(Y, iri("rdf:type"), C),
    t(C, iri("owl:intersectionOf"), X),
    t(X, iri("rdf:first"), C1),
    t(X, iri("rdf:rest"), XX),
    t(XX, iri("rdf:first"), C2),
    t(XX, iri("rdf:rest"), iri("rdf:nil")).
t(X, iri("rdf:type"), C2) :- 
    t(X, iri("rdf:type"), C),
    t(C, iri("owl:intersectionOf"), X),
    t(X, iri("rdf:first"), C1),
    t(X, iri("rdf:rest"), XX),
    t(XX, iri("rdf:first"), C2),
    t(XX, iri("rdf:rest"), iri("rdf:nil")).

% cls-uni-s - Disjunction in the head with two classes
% C owl:unionOf ( C1 C2 ) AND
% X rdf:type C1 OR X rdf:type C2
% =⇒ X rdf:type C
t(Y, iri("rdf:type"), C1);
t(Y, iri("rdf:type"), C2) :- 
    t(Y, iri("rdf:type"), C),
    t(C, iri("owl:unionOf"), X),
    t(X, iri("rdf:first"), C1),
    t(X, iri("rdf:rest"), XX),
    t(XX, iri("rdf:first"), C2),
    t(XX, iri("rdf:rest"), iri("rdf:nil")).

% 5️⃣ – Existential and universal restrictions Implement the rules: cls-svf1, cls-svf2, cls-avf.

% cls-svf1
t(U, iri("rdf:type"), X) :- 
    t(X, iri("owl:someValuesFrom"), Y),
    t(X, iri("owl:onProperty"), P),
    t(V, iri("rdf:type"), Y),
    t(U, P, V).

% cls-svf2
t(U, iri("rdf:type"), X) :- 
    t(X, iri("owl:someValuesFrom"), iri("owl:Thing")),
    t(X, iri("owl:onProperty"), P),
    t(U, P, V).

% cls-avf
t(V, iri("rdf:type"), Y) :- 
    t(X, iri("owl:allValuesFrom"), Y),
    t(X, iri("owl:onProperty"), P),
    t(U, iri("rdf:type"), X),
    t(U, P, V).


% 6️⃣ – Semantics of schema vocabulary Implement the rules: scm-dom1, scm-dom2, scm-rng1, scm-rng2.

% scm-dom1
t(P, iri("rdfs:domain"), C2) :- 
    t(P, iri("rdfs:domain"), C1),
    t(C1, iri("rdfs:subClassOf"), C2).

% scm-dom2
t(P1, iri("rdfs:domain"), C) :- 
    t(P2, iri("rdfs:domain"), C),
    t(P1, iri("rdfs:subPropertyOf"), P2).

% scm-rng1
t(P, iri("rdfs:range"), C2) :- 
    t(P, iri("rdfs:range"), C1),
    t(C1, iri("rdfs:subClassOf"), C2).

% scm-rng2
t(P1, iri("rdfs:range"), C) :- 
    t(P2, iri("rdfs:range"), C),
    t(P1, iri("rdfs:subPropertyOf"), P2).

% 7️⃣ – Disjunction in the head (simplified) Implement the rule cls-uni-dlv-s
% C owl:unionOf ( C1 C2 ) AND 
% X rdf:type C 
% =⇒ X rdf:type C1 OR X rdf:type C2
% where ( C1 C2 ) is a RDF list
% This rule is not from OWL 2 RL, and may cause DLV to output more than one model.

t(X, iri("rdf:type"), C1);
t(X, iri("rdf:type"), C2)  :-
    t(X, iri("rdf:type"), C),
    t(C, iri("owl:unionOf"), X),
    t(X, iri("rdf:first"), C1),
    t(X, iri("rdf:rest"), XX),
    t(XX, iri("rdf:first"), C2),
    t(XX, iri("rdf:rest"), iri("rdf:nil")).

% ---------------------------------------------------------------------------------------------------- %
% 🟩 AUXILIARE PREDICATES 
% 
% ":transitiveRest" is the transitive closure of the predicate "rdf:rest"
t(X, iri(":transitiveRest"), Z) :- 
    t(X, iri(":transitiveRest"), Y),
    t(Y, iri(":transitiveRest"), Z).
t(X, iri(":transitiveRest"), Y) :- 
    t(X, iri("rdf:rest"), Y).

% The head of the list ":contains" each element of each sublist
% it's like ":transitiveRest", but it goes to pick the element of the lest via "rdf:first"
t(X, iri(":contains"), C) :- 
    t(X, iri("rdf:first"), C).
t(X, iri(":contains"), C) :- 
    t(X, iri(":transitiveRest"), Y),
    t(Y, iri("rdf:first"), C).

% ---------------------------------------------------------------------------------------------------- %

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 8️⃣ – Boolean operations Implement the rules cls-int1, cls-int2 and cls-uni.
% You will need to define some auxiliary rules (involving some ad-hoc IRIs).️

%%% cls-int1
% if it doesn't exist any ci st Y rdf:type Ci (for any Ci in intersection)
% then Y is of the type intersection

% notInstanceOfAllOf: if Y is not instance of all the elements of the intersection
t(Y, iri(":notInstanceOfAllOf"), X) :- 
    t(X, iri(":contains"), Ci),
    not t(Y, iri("rdf:type"), Ci),
    t(X, iri(":contains"), Cj),  % for safety
    t(Y, iri("rdf:type"), Cj).   % for safety

% triggered when there is no counterexample
t(Y, iri("rdf:type"), C) :- 
    t(C, iri("owl:intersectionOf"), X),
    not t(Y, iri(":notInstanceOfAllOf"), X),
    t(X, iri(":contains"), Cj),  % for safety
    t(Y, iri("rdf:type"), Cj).   % for safety


%%% cls-int2
t(Y, iri(":instanceOfAllOf"), X) :-
    % X is the list of the elements of the intersection
    t(C, iri("owl:intersectionOf"), X), 
    t(Y, iri("rdf:type"), C).

% instanceOfAllOf
t(Y, iri("rdf:type"), C) :- 
    t(Y, iri(":instanceOfAllOf"), X),
    t(X, iri("rdf:first"), C),
    t(X, iri("rdf:rest"), XX). % holds whether XX is nil or not

t(Y, iri(":instanceOfAllOf"), XX) :- 
    t(Y, iri(":instanceOfAllOf"), X),
    t(X, iri("rdf:first"), C),
    t(X, iri("rdf:rest"), XX),
    XX != iri("rdf:nil"). % if XX is not nil


%%% cls-uni
t(Y, iri("rdf:type"), C) :- 
    t(C, iri("owl:unionOf"), X),
    t(X, iri(":contains"), Ci),
    t(Y, iri("rdf:type"), Ci).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 9️⃣ – AllDifferent and AllDisjointClasses Implement the rules: eq-diff2, eq-diff3, cax-adc.
% You will again need some of the auxiliary rules and IRIs of the previous point.
%%% eq-diff2
:-  t(X, iri("rdf:type"), iri("owl:AllDifferent")),
    t(X, iri("owl:members"), Y),
    t(Y, iri(":contains"), Ci),
    t(Y, iri(":contains"), Cj),
    t(Ci, iri("owl:sameAs"), Cj).

%%% eq-diff3
:-  t(X, iri("rdf:type"), iri("owl:AllDifferent")),
    t(X, iri("owl:distinctMembers"), Y),
    t(Y, iri(":contains"), Ci),
    t(Y, iri(":contains"), Cj),
    t(Ci, iri("owl:sameAs"), Cj).

%%% cax-adc
:-  t(X, iri("rdf:type"), iri("owl:AllDisjointClasses")),
    t(X, iri("owl:members"), Y),
    t(Y, iri(":contains"), Ci),
    t(Y, iri(":contains"), Cj),
    t(Z, iri("rdf:type"), Ci),
    t(Z, iri("rdf:type"), Cj),
    Ci != Cj.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1️⃣0️⃣ – Disjunction in the head Implement the rule cls-uni-dlv.
% This rule is not from OWL 2 RL.
% You will need some new auxiliary rules and IRIs. Be very careful with how these auxiliary rules
% interact with the rest of the program. In particular, make sure that DLV does not output unintended
% models because of these rules.
% For example, running DLV on the DLV KB corresponding to the following graph
% :A owl:equivalentClass [ a owl:Class ; owl:unionOf ( :B :C :D ) ] .
% :c a :C .
% :a a :A .
% should only output three models. In all models it should be the case that :a rdf:type :A
% and :c rdf:type :A, :C. Then there should be one model with :a rdf:type :B, one with
% :a rdf:type :C, and one with :a rdf:type :D.

%%% cls-uni-dlv
% C owl:unionOf ( C1 C2 ... Cn ) AND
% X rdf:type C
% => X rdf:type C1 OR X rdf:type C2 OR ... OR X rdf:type Cn
t(Y, iri(":instanceOfOneOf"), X) :-
    % X is the list of the elements of the union
    t(C, iri("owl:unionOf"), X), 
    t(Y, iri("rdf:type"), C).

% instanceOfOneOf
t(Y, iri("rdf:type"), C); % or Y is of type C
t(Y, iri(":instanceOfOneOf"), XX) :- % or Y is instanceOfOneOf XX, which is the rest of the list
    t(Y, iri(":instanceOfOneOf"), X),
    t(X, iri("rdf:first"), C),
    t(X, iri("rdf:rest"), XX),
    XX != iri("rdf:nil"). % if XX is not nil, then I can continue

t(Y, iri("rdf:type"), C) :- 
    t(Y, iri(":instanceOfOneOf"), X),
    t(X, iri("rdf:first"), C),
    t(X, iri("rdf:rest"), iri("rdf:nil")). % if XX is nil, then I stop


% instanceOfOneOf and instanceOfAllOf
% so if Y is instanceOfAllOf X, then Y is instanceOfOneOf X
% so that instanceOfAllOf doesn't appear just in one model (minimality constraint)
t(Y, iri(":instanceOfOneOf"), X) :- 
    t(Y, iri(":instanceOfAllOf"), X),
    X != iri("rdf:nil").

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1️⃣1️⃣ – Universal restriction with the closed world assumption: cls-avf-cw 
% This rule is not from OWL 2 RL; it is the rule AllValuesFrom with the closed world assumption: 
% if, for an individual X, we have in the KB that
% whenever X P Y then Y rdf:type D,
% then in a closed world we conclude that X is of type for any P.Y
% in a closed world it is enough that I don't see any Y which is not of type D

%   if the program is such that for all y: P(x, y) implies C(y),
%   then x is of type 'forall P.C'

%%% cls-avf-cw
% C owl:allValuesFrom D
% C owl:onProperty P
% X rdf:type owl:NamedIndividual
% for all X P Y in the KB: Y rdf:type D
% => X rdf:type C
t(X, iri("rdf:type"), C) :- 
    % C is the class "forall P.D"
    t(C, iri("owl:allValuesFrom"), D),
    t(C, iri("owl:onProperty"), P),
    % X is a named individual
    t(X, iri("rdf:type"), iri("owl:NamedIndividual")),
    % and there is no Y such that "X P Y" and "not (Y rdf:type D)"
    not t(X, iri(":counterexampleFor"), C).

% I get a counterexample when exist a Y such that: "X P Y" and "not (Y rdf:type D)"
t(X, iri(":counterexampleFor"), C) :- 
    t(C, iri("owl:allValuesFrom"), D),
    t(C, iri("owl:onProperty"), P),
    t(X, P, Y),
    not t(Y, iri("rdf:type"), D).