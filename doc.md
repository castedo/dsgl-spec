---
title: "Document Succession Git Layout Specification"
date: 2023-12-02
abstract: |
    **DOCUMENT TYPE**: Technical Specification
---


## Document successions implemented via Git

In the Git implementation, the genesis record is a signed initial Git commit with an
empty tree (and no parent). To expand the document succession, additional Git commits
are made using the same signing key. The Git tree of each commit is not a
digital object in the succession. Instead, it is a record of all the
digital object editions in the succession. The top-level directory consists of
subdirectories named as non-negative integers. Each subdirectory
contains either an entry named `object` or entries named as non-negative integers that are
subdirectories. An entry named `object` represents a digital object edition in the document 
succession, which can be a file (Git blob) or a directory (Git tree).
For example, when a single file is added as edition 1, the full succession record is a
directory with the path `1/object` leading to a Git blob representing edition 1.

