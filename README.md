# Graphic Analysis Customization for MEI

The present branch contains a schema for graphic analysis annotations in Music Encoding Initiative (MEI) scores. This is work in progress. Please do not cite or use in public work without permission.

## Building

To produce the requisite RNG and Schematron files, run the following shell script:

`./build_graph_mei.sh`

A successful build operation will produce `.rng`and `.sch` files in `./dist`. An `.xslt` file will also be generated for MEI validation by LSP engines that require it, such as `lemminx`.
