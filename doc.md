<!-- copybreak off -->

---
title: "Document Succession Git Layout"
date: 2024-02-14
abstract: |
    **DOCUMENT TYPE**: Living Technical Specification

    A document succession is a distributed, correctable document that preserves document
    snapshots as editions, which can be individually referenced.
    The Document Succession Git Layout (DSGL) is a format for storing document successions
    within a Git object store.
    DSGL bridges two related formats: the textual representation of
    [Document Succession Identifiers (DSI)](https://perm.pub/1wFGhvmv8XZfPx0O5Hya2e9AyXo)
    and the storage format for document snapshots.
    An example of a snapshot format is the format for Baseprint document snapshots;
    however, this specification does not define any specific format for document snapshots.
    This DSGL specification details a Git storage layout that interoperates with the
    [Hidos Python package](https://pypi.org/project/hidos/) version 1.3 and the [Document
    Succession Highly Manual Toolkit](https://manual.perm.pub).
---

<!-- copybreak on -->

## Background

Websites, such as [https://perm.pub](https://perm.pub),
use free open-source software, such as the Python package
[Epijats](https://gitlab.com/perm.pub/epijats),
to process the formats of
Document Succession Git Layout (DSGL),
[Document Succession Identifiers (DSI)](https://perm.pub/1wFGhvmv8XZfPx0O5Hya2e9AyXo),
and Baseprint document snapshots.
For the motivation behind these technologies,
refer to [Why Publish Baseprint Document Successions](
https://perm.pub/wk1LzCaCSKkIvLAYObAvaoLNGPc
).
Tutorials and introductory material are also available at
[https://try.perm.pub/](https://try.perm.pub).

<!-- copybreak off -->

## Scope

This document is a specification of DSGL that interoperates with these reference
implementations:

* the Python package [Hidos](https://pypi.org/project/hidos/) [@hidos:1.3] and
* the [Document Succession Highly Manual Toolkit](https://manual.perm.pub) [@dshmtm].

This specification does not include potential DSGL feature that are not implemented in
any software.
The online forum <https://baseprints.singlesource.pub> is available for proposals
of improvements to this living specification and reference implementations.

### Signed Successions

This specification is for document successions are digitally signed.
*Unsigned* document successions are out of the scope for this edition of the
DSGL specification.
Unsigned document successions can be useful for testing and learning purposes,
but are not critical to interoperability.

### Ungarbled Successions

This specification is for a definition of DSGL for *ungarbled* recordings.
An *ungarbled* recording is most likely to interoperate and is intuitively the
ideal way one would record the data of a document succession. 
Reality and non-ideal circumstances sometimes result in *garbled* recordings.
Implemented software will be able to deal with *garbled* recordings to varying levels of satisfaction.
This specification assumes document successions are *ungarbled*, unless otherwise noted.

<!-- copybreak off -->

## Layout Definition

### Initial Git Commit

A document succession consists of a Git commit history with a single initial commit.
The base DSI of the document succession is the base64url (RFC 4648)[@rfc4648]
representation of the 20-byte binary Git hash of the initial commit.
An *ungarbled* document succession has a linear Git commit history.

### Signatures

Every commit tree contain a
`signed_succession` subdirectory that includes an `allowed_signers` file listing the
public keys allowed to extend the document succession.
Each line in the `allowed_signers` file begins with `* namespaces="git" ` followed by
space-separated fields of a keytype and a base64-encoded public key as supported by OpenSSH.
The keytype of `ssh-ed25519` is well tested, broadly adopted, and featured in the
[Document Succession Highly Manual Toolkit Manual](https://manual.perm.pub) [@dshmtm].

The initial commit is signed with an SSH key that is listed in the `allowed_signers` file.
Each non-initial commit is signed with an SSH key listed in the `allowed_signers` files of
all of its parent commits.

### Document Snapshot

A document snapshot is any digital object that can be encoded as a Git blob or Git tree.
Every document snapshot in a document succession has an edition number tuple that ends
in a positive integer.
For instance, `10` is a valid edition number whereas `1.0` is not.
Formally, the edition number `10` is the tuple `(10)` and `1.0` is the tuple `(1,0)`.

The contents of each document snapshot are stored in a Git commit tree with a path
consisting of the edition number tuple components separated by slashes and then the
file/directory name `object`.
For example,
a directory as the contents of a document snapshot that is edition 1
is stored at a directory path `1/object` that corresponds to a Git tree.

For each edition number, the first commit that stores the document snapshot 
is the only valid data for that edition number.
An ungarbled document succession only has one commit that sets the document snapshot
assigned to a edition number.
If a subsequent commit stores a different document snapshot at the path of a previously
store edition path,
it does not change what is the correct value of the edition in the document succession.

> Hidos 1.3 will automatically return only the first document snapshot committed and
> will ignore invalid snapshots of subsequent commits.

<!-- copybreak off -->

## Discussion

### Related Concepts

A *Document Succession Identifier* is an
[intrinsic identifier](https://www.softwareheritage.org/2020/07/09/intrinsic-vs-extrinsic-identifiers)
[@intrinsic_extrinsic_identifiers] [@cosmo_referencing_2020] [@dicosmo:hal-01865790]
of the initial Git commit.

### Design Choice Rationales

#### Separation of Git History from Edition History

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

#### Use of Git Tree Paths Instead of Git Tags

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
