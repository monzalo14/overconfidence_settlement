# Overconfidence and settlement: evidence from Mexican labour courts

This working paper is the result of a series of RCTs conducted in the Mexico City Labour Court. 
In order to be able to re-create the figures and tables within each corresponding subdirectory, you need to have access to [this project folder](https://www.dropbox.com/sh/60i4rl0kslgp7sa/AAA3q361n-3eF8GbF2iNUUNEa?dl=0), which contains everything available in this repository and all raw and clean datasets used.

# Repository structure

Our repository is organized in five main sections, each one with a particular directory. Three of them contain all work related to a particular experiment, and the remaining two mix work from different experiments. The main sections are:

- Paper

- ScaleUp

- Pilot_3

- Reports

- Presentations

Each of these sections contains its corresponding *.tex* files, and subdirectories for Figures and Tables. Despite this is a bit inefficient (elements could be duplicated), it is a bit easier to organize and saves us from having to use relative paths in ShareLatex. For the sake of simplicity, all figures and tables are generated in the experiment sections, and are copied into Reports/Presentations directories when needed. 

# RScripts and Do-Files

You will see there are subdirectories for Raw and Clean Data, and for RScripts and DoFiles used to generate content. RScripts are always run from the RScripts directory, while DoFiles are run from the experiment directory by declaring a global variable.  All scripts have the name of the figure or table they are generating.

File cleaning processes are generally done in R and take Raw data as an input and have DB data as an output. However, some slight variable recoding is done in STATA in some cases when running regressions. 

# Workflow 

We share all our work through github, and update the ShareLatex project through Dropbox.