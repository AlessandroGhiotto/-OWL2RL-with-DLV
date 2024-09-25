# OWL 2 RL reasoner with DLV

[OWL 2 RL](https://www.w3.org/TR/owl2-profiles/#Reasoning_in_OWL_2_RL_and_RDF_Graphs_using_Rules)
is a subset of OWL 2 which is amenable to implementation using rule-based technologies.
Here I implement an OWL 2 RL reasoner with DLV.

The only predicate that we are going to use is `t(S, P, O)`
which represents a triple with subject S, predicate P and object O. In order to distinguish between
IRIs, literals and blank nodes we can use the function symbols _iri_, _literal_ and _bnode_.

For example, the triples:

```prolog
    ex:bob foaf:knows _:x . _:x foaf:age 21 .
```

can be represented as

```prolog
    t(iri("ex:bob"), iri("foaf:knows"), bnode("_:x")).
    t(bnode("_:x"), iri("foaf:age"), literal("21")).
```

## Description

Here I have listed all the rules implemented. Parts 7, 10 and 11 extend OWL 2 RL reasoning with features of DLV such as NAF and disjunction.

1. **RDFS rules**: _prp-dom, prp-rng, scm-spo, prp-spo1, cax-sco, scm-sco_.
2. **Equality and class axioms**: _eq-sym, eq-trans, eq-rep-s, eq-rep-p,
   eq-rep-o, eq-diff1, cax-eqc1, cax-eqc2, and cax-dw._
3. **Axioms about properties**: _prp-fp, prp-ifp, prp-irp, prp-symp,
   prp-asyp, prp-trp, prp-inv1, and prp-inv2_.
4. **Boolean operations (simplified)**: _cls-com, cls-int1-s, cls-int2-s, cls-uni-s_.
5. **Existential and universal restrictions**: _cls-svf1, cls-svf2, cls-avf_.
6. **Semantics of schema vocabulary**: _scm-dom1, scm-dom2, scm-rng1, scm-rng2_.
7. **Disjunction in the head (simplified)**: _cls-uni-dlv-s_
8. **Boolean operations**: _cls-int1, cls-int2_ and _cls-uni_.
9. **AllDifferent and AllDisjointClasses**: _eq-diff2, eq-diff3, cax-adc_.
10. **Disjunction in the head**: _cls-uni-dlv_.
11. **Universal restriction with the closed world assumption**: _cls-avf-cw_

## Getting Started

### Dependencies

- [DLV](https://www.dlvsystem.it/dlvsite/dlv-download/).

### Executing program

For running the OWL2_RL reasoner on your knowledge base you need to print in the terminal the path to the DLV executable, the path to the file "OWL2_RL_reasoner_with_DLV.asp" and the path to the file containing your knowlege base

```
<path-to\dlv-exectuable> <path-to\OWL2_RL_reasoner_with_DLV.asp> <path-to\your-kb>
```
