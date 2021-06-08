# Design and Architecture Of Computer Systems
>These projects are the labs that were completed while taking CS161L at University of California, Riverside in Spring 2021 with Dr. Allan Knight. The main purpose of the labs was to become familiar and comfortable using verilog to set modules of architecture design

## General
The main purpose of these labs were to design and simulate of a complete computer system using hardware description language and simulator. Used **Test-driven development (TDD)** to write the test cases before the actual software was writen. 

Implemented Things like
* ALU
* Fixed-Point & Floating-Point Conversion
* MIPS instructions
* Datapaths


### Includes
* Lab 1: Arithmetic and Logic Unit (ALU)
* Lab 2: Fixed-Point to Floating-Point (& vice versa)
* Lab 3: Datapath Control and ALU Control Units
* Lab 4: Single Cycle Datapath
* Lab 5: Pipelined Datapath


#### Some Tests 
*Lab1: Test Cases for ALU*

![Screen Shot 2021-04-09 at 2 07 53 AM](https://user-images.githubusercontent.com/62925991/115435081-52351200-a1be-11eb-8bef-115f43889110.png)


*Lab2: Test Cases for Conversion*

<img width="609" alt="Screen Shot 2021-04-23 at 12 41 21 AM" src="https://user-images.githubusercontent.com/62925991/115836706-a9a8cd00-a3cc-11eb-9321-f1fddc7814ae.png">

*Lab3: Test Cases for ALU & Main Control Unit*

![Screen Shot 2021-04-29 at 6 51 16 PM](https://user-images.githubusercontent.com/62925991/116639046-73af9f80-a91c-11eb-9291-3254da0b0c74.png)







## Usage
Should have Icarus Verilog to be able to compile the code. Once the files are downloaded and all the code is in place you can compile the code using ```iverilog nameOfFile...``` and run the test file like so  ```vvp a.out```.

### Technologies
* Verilog
