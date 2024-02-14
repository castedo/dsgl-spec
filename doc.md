<!-- copybreak off -->

---
title: "Document Succession Git Layout Specification"
date: 2024-02-14
abstract: |
    **DOCUMENT TYPE**: Living Technical Specification

    This specification documents a storage scheme for
    document successions and snapshots that are identifiable by
    [Document Succession Identifiers](https://perm.pub/1wFGhvmv8XZfPx0O5Hya2e9AyXo).
    This storage scheme is implemented through Git commit records.
    This specification is descriptive of a Git layout that interoperates with the Hidos
    software package version 1.3 and the Document Succession Highly Manual Toolkit.
---

## Introduction

For a non-technical background and motivation for this technology,
refer to [Why Publish Baseprint Document Successions](
https://perm.pub/wk1LzCaCSKkIvLAYObAvaoLNGPc
).
Consult the
[Document Succession Identifiers](https://perm.pub/1wFGhvmv8XZfPx0O5Hya2e9AyXo)
specification for a general conceptual model of document successions
and their textual identifiers.

## Baseprint documents

This specification does not describe any specific format for the document snapshots
stored within a document succession. This specification is compatible with any
document snapshot format which can be encoded as a Git blob or Git tree.

As of early 2024, the only document snapshot format implemented is
with the [Epijats](https://gitlab.com/perm.pub/epijats) software package.
Various other tools and websites use Epijats, using the term *Baseprint document
successions*.
A starting point to learn more about Baseprint document successions is
[try.perm.pub](https://try.perm.pub).


## Reference Implementations

The Python library [Hidos](https://pypi.org/project/hidos/) [@hidos:1.3] and the
[Document Succession Highly Manual Toolkit](https://manual.perm.pub) [@dshmtm] both serve as
reference implementations for storing document successions in a Document Succession Git
Layout (DSGL).


## Scope

This specification assumes document successions are digitally signed.
*Unsigned* document successions are currently out of the scope of this edition of the
specification.
Though they may be useful for testing and learning purposes,
they are not critical to interoperability.

<!-- copybreak off -->

## Document Successions Encoded with Git

### Initial Commit

A document succession consists of a Git commit history with a single initial commit.
The base DSI of the document succession is the base64url (RFC 4648)[@rfc4648]
representation of the 20-byte binary Git hash of the initial commit.
A *Document Succession Identifier* is an
[intrinsic identifier](https://www.softwareheritage.org/2020/07/09/intrinsic-vs-extrinsic-identifiers)
[@intrinsic_extrinsic_identifiers] [@cosmo_referencing_2020] [@dicosmo:hal-01865790]
of the initial Git commit.

### Signatures

Every commit of a document succession must be signed with an SSH key and contain a
`signed_succession` subdirectory that includes an `allowed_signers` file listing the
public keys authorized to extend the document succession.
Each line in the `allowed_signers` file begins with `* namespaces="git" ` followed
by space-separated fields of keytype and base64-encoded public key as supported by
OpenSSH. The keytype of `ssh-ed25519` is well tested.

The initial commit must be signed with an SSH key listed in the
`signed_succession/allowed_signers` file.
Non-initial commits must be signed with an SSH key listed in the
`signed_succession/allowed_signers` file of every parent commit.

### Editions

The top-level directory contains subdirectories named with non-negative integers.
Each subdirectory contains either an entry named `object` or entries named with non-negative integers that are subdirectories.
An entry named `object` encodes a document snapshot,
which may be a file (Git blob) or a directory (Git tree).
For example,
adding a directory as the contents of a document snapshot to be edition 1
results in a directory path `1/object` that corresponds to a Git tree for edition 1.


### Clarifications

The Git tree of each commit does not represent a single document snapshot;
instead, it records all snapshots in the succession.


<!-- copybreak off -->

## Implementation Choice Rationales

### Separation of Git History from Edition History

Representing the history of editions through means other than Git commit history
is a deliberate design choice.
Git commit history records all Git actions,
which can lead to inflexible and complicated non-linear histories.
Software Heritage automatically preserves Git commits,
increasing the risk that a Git commit history could become
an unintended complicated non-linear history.
Non-linear Git commit histories and merge commits might be useful in certain scenarios.

Separating edition history from Git commit history also allows
for future enhancements, such as retracting specific editions.

<!-- copybreak off -->

### Use of Git Tree Paths Instead of Git Tags

In document successions, edition numbers are akin to software release versions,
which are typically identified using Git tags.
However, this specification adopts a different approach.
Edition numbers are recorded with file paths in Git trees rather than Git tags.
With this approach, a single latest Git commit captures a complete record of a document succession.
This means copying document successions is as easy as copying Git branches.
This is especially useful when consolidating records from multiple sources into a single Git repository.

In contrast, software projects, which often include release tags,
are copied by cloning the entire repository.
Using Git tags for edition numbers would
introduce the complexity of keeping a branch and edition number tags in sync,
thereby increasing the risk of problems during copying.

While branches in Git repositories are useful for managing document successions,
branch names do not constitute a part of the document succession record.

<!-- copybreak off -->

# Acknowledgments

Thank you to Valentin Lorentz for raising questions about design choices
and pointing out an important shortcoming in how GPG digital signatures were used
in the initial Git implementation of the Hidos library (version 0.3) [@hidos:0.3].

# History

* Copied Git storage specifics from [edition 2.1 of the DSI
  specification](https://perm.pub/1wFGhvmv8XZfPx0O5Hya2e9AyXo/2.1).
