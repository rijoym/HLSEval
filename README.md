# HLSEval

This repository contains the LLM prompts, HLSEval dataset and related scripts for the paper "Evaluating Large Language Models for Automatic Register Transfer Logic Generation via High-Level Synthesis", submitted to IEEE Transactions on Computer-Aided Design of Integrated Circuits and Systems. [https://arxiv.org/abs/2408.02793]

The repository is organized as follows:

1) HLSEval-prompt.jsonl - Contains the problem descriptions in English, which will act as prompts to LLM to generate C++ codes for HLS.

2) sample_experiment.ipynb - A sample experiment on how to generate C++ codes for HLS using various LLMs.

3) run_all.tcl - TCL script to automate Vitis HLS from the generated .cpp files, produces Verilog codes 

4) HLSEval-test.jsonl - Contains the test scripts for evaluation of the generated Verilog from step 3. Use the test harness from https://github.com/NVlabs/verilog-eval.
