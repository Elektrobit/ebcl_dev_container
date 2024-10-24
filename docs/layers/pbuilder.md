# PBuilder Layer

The pbuilder layer adds support for the Debian pbuilder tool.
This tool is used for application packaging.
This layer also provides the helper scripts for application packaging and generating apt repository metadata, see _layers/pbuilder/scripts/pbuilder_ and _layers/pbuilder/scripts/deb_.

## Remarks

- By default, pbuilder fails for Ubuntu because the repository archive.ubuntu.com lists the arm64 architecture, but doesn't provide package indices. This is OK from a specification point of view, but causes an apt exit code != 0, which causes a pbuilder failure. The workaround is _layers/pbuilder/conf/pbuilder/G99apt_arch_, which modifies the apt sources and adds and architecture filter.
- Pbuilder is configured ot use the Canonical and Elektrobit apt repositories, see _layers/pbuilder/conf/pbuilder/pbuilderrc_.
- Pbuilder always makes use of the **latest EB corbos Linux release** provided by the public repository. To change this, the file _layers/pbuilder/conf/pbuilder/pbuilderrc_ (_/home/ebcl/.pbuilderrc_) needs to be adapted.
