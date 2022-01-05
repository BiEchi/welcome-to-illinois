# Welcome To Illinois - UIUC ECE 385 Final Project
This is the public repository for the ECE385 Course Project in UIUC. Credits are given for [*Travelling by Chinese Speed*](https://github.com/Alex-Lian/shortest-path-search-on-FGPA/) by Alex Lian for initiating this project and we ameliorated his designs.

Project Github: https://github.com/BiEchi/welcome-to-illinois

Table of Contents
=================

[TOC]

## Introduction

With the rapid development of public communications, travelling by bus becomes an inevitable skill to command by both locals and foreigners. As we ZJUIer’s are going to USA in one week, we introduced this project to act as a guide. We now introduce our project - Welcome to Illinois.

![map](http://jacklovespictures.oss-cn-beijing.aliyuncs.com/2022-01-05-022725.bmp)

This project acts as the final project for ECE 385 in UIUC, with curtsey for Professor Zuofu Cheng and Professor Chushan Li, and all the TAs. We highly appreciate their high-quality efforts to this course.



## Construction

If you want to reproduce our project, you need to construct the project first.

### Construct the hardware part

To construct the hardware part, you need to go to `hardware_code/lab8.qpf` and open it with Quartus II. After opening the project, you need to compile the files and program the file onto the DE2-115 board.

### Construct the software part

As the hardware part contains a CPU, you need to program the CPU then. To program the CPU, you need to open Eclipse in Quartus II and construct a new software workspace. Then you need to copy and paste all the code in `software_code/` into the workspace and compile it. Note that there is something more to do with the BSP directory according to **Junyan Li**.

After construction, you can now travel using bus in Illinois!



## General flow of circuit for different modes





## Module Description





## Overview of the design procedure







## Block Diagram







## Conclusion

### Bugs & Solution





### General thoughts









## Contribution

We highly appreciate your idea to take a look at our project, if you think the project is worthwhile to go further on, you can consult your TA about your proposal and then start with our project. Note that it’s crucial to contact us if you get any question. We’d like to help you out all the time! You can contact us by either creating an [issue](https://github.com/BiEchi/welcome-to-illinois/issues) or sending an E-mail. Detailedly, the contribution of the team members are included below.

### Jack Bai (haob2@illinois.edu)$(\dagger)$

-   Hardware side of the project.
    -   Display of title, cursor, number, city name, etc.
    -   Design the RAM files `ramstore*.sv`.
    -   Design the interfaces of hardwares and softwares.
-   Audio displaying part.
    -   Generation of audio.
    -   Adding audio as the background music.
    -   Adding the sound effects.
-   Design the scripts of software and hardware.

### Junyan Li (Junyanl3@illinois.edu)

-   Implementation of the parallel dijkstra algorithm.
    -   Fit the Dijkstra algorithm onto the board.
    -   Use hardwares to accelerate the dijkstra algorithm.
-   Generating the RAM files and design the map.
    -   Seek data in Illinois to generate the data file.
    -   Use the data file to construct a topographical map.
