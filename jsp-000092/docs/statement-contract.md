# JSP-000092 statement contract

Reviewed 2026-09-16 (S00). This project formalizes the near-linear version of Erdős 75, corresponding to JSP-000092. It does not claim the stronger fixed-linear independence bound.

The target is the proposition in [Formal Conjectures at the pinned revision](https://github.com/google-deepmind/formal-conjectures/blob/40e7c98697de6f66b8cbdbf641749ab39ed9c152/FormalConjectures/ErdosProblems/75.lean), with answer True: there exists a graph on a type in universe zero with both vertex and chromatic cardinality aleph-one, and for every positive real epsilon a threshold uniform over all n-vertex subgraphs beyond which an ambient-graph independent set has cardinality strictly greater than n^(1-epsilon).

Vertices are strictly increasing triples. Adjacency is the exact pattern x.a < x.b < y.a < x.c < y.b < y.c, or its reverse orientation.

The finite proof uses a dyadic coloring and an integral pigeonhole bound. The infinite proof uses countable unbounded covers on the countable ordinals. Logarithmic growth of the dyadic depth supplies the asymptotic step. These inputs correspond to F01-F07, O01-O07, A01-A02, and I01-I02 in the prepared prompt pack.

The upstream theorem is admitted and will not be used as a supporting lemma. Its coloring support definitions are imported separately. The final adapter must preserve `V : Type`, ambient `G.IsIndepSet`, all positive real epsilon, strict inequality and uniform thresholds; positive `ncard` is required before extracting a finite vertex set.

## Mathematical attribution

- [Explicit direct proof attached to awards issue 110](https://github.com/user-attachments/files/32296106/JSP-000092_submission.md).
- [Earlier near-linear note](https://www.ulam.ai/research/erdos75.pdf).
- [Erdős, Hajnal and Szemerédi, On almost bipartite large chromatic graphs (1982)](https://renyi.hu/~p_erdos/1982-11.pdf).

This is a formalization of public mathematics; no mathematical discovery priority is claimed.
