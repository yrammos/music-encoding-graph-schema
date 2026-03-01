# Graphic Analysis Customization for MEI

This branch contains work an ODD schema for graphic-analysis annotations to MEI files.

The schema represents work in progress. Please do not cite or publish without permission.

## Building

To produce the requisite RNG and Schematron files, run the following shell script:

`./build_graph_mei.sh`

A successful build operation will produce `.rng`and `.sch` files in `./dist`. An `.xslt` file will also be built for MEI validation by LSP engines (e.g. lemminx) that require it.
