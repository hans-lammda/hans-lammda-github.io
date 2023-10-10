---
title: "Hello SBOM"
date: 2017-10-17T15:26:15Z
draft: false
weight: 9 
description: "Going down the rabbithole of SBOM:s"
TableOfContents: true
---

## Introduction 
The process of building software could be compared with a factory assembly line where the product is on 
on top of the belt and the toolchain is the assemly line itself. 

Let's make it easy by keeping the product to four-line of source code, so we can focus on the underlying assembly line ( toolchain and platform ). 


Hello world is the most famous C program , but in the era of [Software-bill-of-material](https://cyclonedx.org/guides/sbom/introduction/) it raises several challenges. 
* Include directives 
* The C compiler
* C library
* Linux Kernel 


### Hello SBOM World
This is the product 
```code
#include <stdio.h>
int main(void) 
{ 
 printf("Hello sbom\n"); 
}
```


Hello World by itself is not an application that handles user data or performs complex tasks, 
so there are usually no security concerns associated with it. "Chat-GPT"

In AI we trust so let's assume that Hello SBOM is bug-free. Next step is the generation of a binary, for that we need a toolchain. 





## Toolchain
The [GCC compiler](https://gcc.gnu.org) is the most important part of the assembly line, it is also a very complex software and and therefore vulnerabilities exists  [security issues](https://www.cvedetails.com/vulnerability-list/vendor_id-72/product_id-960/GNU-GCC.html). Most distributions like Ubuntu, Redhat, Debian etc provides their own compiler, but you can also build you own group up with [Crosstool-NG](https://github.com/hans-lammda/crosstool-ng)

Building software with GCC actives several steps. 
| Step | Option | Comment |
|------|--------|---------|
| Preprocessing | -E | #include <stdio.h> will be replaced with the content of /usr/include/stdio.h |
| Generate Assembly | -S | Output a textfile with assemly code interleaved with commented C code |
| Optimize | -O | Optimize execution time and size for the final binary |
| Staticly linked | --static | Binary interfaces directly with kernel |

 

### Preprocessor 
The preprocessor is basically a text processor with the capability of including other files. There is also simple programming support with variables and conditions
```code
gcc -std=c89  -E -o bom.txt sbom.c
```
Depending of which of the C language being used, different files being included. 
```code
gcc -std=c99  -E -o bom99.txt sbom.c
```

[Preprocesser output](bom.txt)


[Difference C89 and C99](bom_cpp_diff.txt)

###  Compile 
Compile source code into binary 
```code
gcc  sbom.c -lc -o sbom
```

####  Optimize 
However, there are gazillions of different parameters to control how to generate a binary. Two frequent flags are optimization (-Olevel ) and (-S) for generating human-readable assembly code. The latter is very important to ensure that private data and keys are handled correctly. 

```code
gcc -O2 -S -o bom.s bom.c
gcc -O2 -S -o bom.ss bom.c
diff bom.s bom.ss > bom.s.diff.txt
```
[Assembler output](bom.s.txt)


[Difference when optimization is applied](bom.s.diff.txt)

###  Linking

#### Static  linking  

```code
gcc  sbom.c -lc -static -o sbom
```

#### Dynamic linking  

```code
gcc  sbom.c -lc -o sbom
```

| Type of linking | size of binary ( bytes ) |
|-----------------|----------------|
| Static          | 900344    | 
| Dynamic         | 15960     | 


executing the dynamicly linked binary. With strace the calls to C-library could be traced
```code
strace ./sbom

openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3

Hello sbom

```

#### Legal issues   
C library is the interface to the Linux kernel and comes in many many [flavors](https://www.etalabs.net/compare_libcs.html). 

| Library | License |
|---------|---------|
| [Gnu libc](https://www.gnu.org/software/libc) | [LGPL](https://en.wikipedia.org/wiki/GNU_Lesser_General_Public_Licens) 2.1+ w/exceptions| 
| [Muslc](https://wiki.musl-libc.org)   | [MIT](https://en.wikipedia.org/wiki/MIT_License) | 
| [Relibc](https://gitlab.redox-os.org/redox-os/relibc)   | [MIT](https://en.wikipedia.org/wiki/MIT_License) | 

There might be security issues with the C library such as [CVE-2019-1010022](https://ubuntu.com/security/CVE-2019-1010022)


*GNU Libc current is affected by: Mitigation bypass. The impact is: Attacker may bypass stack guard protection. The component is: nptl. The attack vector is: Exploit stack buffer overflow vulnerability and use this bypass vulnerability to bypass stack guard. NOTE: Upstream comments indicate “this is being treated as a non-security bug and no real threat.”*

The kernel contains 30+ millions lines of code and and have also [security issues](https://www.cvedetails.com/product/47/Linux-Linux-Kernel.html)



## Cybersecurity Resilience Act   
The underlying C library and Linux kernel provides a **software platform** so we better check [CRA and article 10](https://digital-strategy.ec.europa.eu/en/library/cyber-resilience-act) 


### Article 10   
*In order not to hamper innovation or research, free and open-source software 
developed or supplied outside the course of a commercial activity should not be 
covered by this Regulation. This is in particular the case for software, including its 
source code and modified versions, that is openly shared and freely accessible, usable, 
modifiable and redistributable. In the context of software, a commercial activity might 
be characterized not only by charging a price for a product, but also by charging a 
price for technical support services, by providing a **software platform** through which 
the manufacturer monetises other services, or by the use of personal data for reasons 
other than exclusively for improving the security, compatibility or interoperability of 
the software.*


## Assumptions
   
In addition to what we can download and build from internet, there are still layers that is hard to verify and must be trusted. 

### Firmware 

 [T2data](https://t2data.com/project/haspoc/) was engaged in a research project together with [Ericsson](https://www.ericsson.com/en/blog/2017/8/high-assurance-virtualization-for-armv8)

  
 We contributed by writing a simple bootloader from scratch inspired by two projects: 
 * [Arm Trusted Firmware](https://www.trustedfirmware.org/) 
 * [Uboot](https://www.denx.de/project/u-boot/) [Uboot](https://www.youtube.com/watch?v=YlJBsVZJkDI) 


 The project was originally designed for the [Juno development board](https://community.arm.com/oss-platforms/w/docs/485/juno) and includes the very first instruction residing in [ROM](https://raw.githubusercontent.com/hans-lammda/secure_boot/main/open_src/src/bios_low/arm64_v8_dev-1.1/bl1/aarch64/bl1_entrypoint.S).  


 To keep track of headerfiles being used we selected  [Subversion](https://subversion.apache.org/) since it support keywords 

All header files used in the project contains a preprocessor variable assigned a value from subversion 

*bignum.h*
 ```code
#define BIGNUM_H_DEF "$HeadURL: $ $Revision: $"

 ```
In the implementation that includes the header file a static variable get the value assigned to the header macro. 
All keywords is allocated to a section .keywords that is removed furing the final step in the build process. 


*bignum.c*
 ```code
#include "bignum.h"
char secure_bios_bignum_header[]  __attribute__ ((section (".keywords")))  = BIGNUM_H_DEF;
 ```

Each compiled artifact could then be backtracked to source by executing the ident command line utility. 


 ```code
 $ ident bignum.o

  bignum.o:
     $HeadURL: https://cm-ext.dev.oniteo.com/svn/nanodev/packages/secure_bios/branches/haspoc/hikey/secure_bios/pki/bignum.c $
     $Revision: 26005 $
     $HeadURL: https://cm-ext.dev.oniteo.com/svn/nanodev/packages/secure_bios/branches/haspoc/hikey/secure_bios/pki/bignum.h $
     $Revision: 17411 $
 ```

Keeping the keywords in a dedicated section make it easy to keep or drop the information in different instances of the build pipelines. 

KEEP(*(.keywords))


### Hardware
* [Hardware](https://developer.arm.com/documentation/ddi0602/2023-09/Base-Instructions/CSINC--Conditional-Select-Increment-?lang=en) Architecture is all about the instruction set for a developer

## Conclusion 
Even if the product on top of the assembly line is very small and without bugs, the assembly line itself is very complex. The overall security depends on both the product and the tool. 
The tool also includes the platform, C-library, and Linux kernel, in addition, we assume that firmware and hardware are trusted. 


### Trust
In 1984 Ken Thompson wrote the paper [Reflections on trusting Trust](https://www.cs.cmu.edu/~rdriley/487/papers/Thompson_1984_ReflectionsonTrustingTrust.pdf), that address how to trust the output from a very simple program being compiled.


### Trust
 [Uboot](https://www.youtube.com/watch?v=YlJBsVZJkDI) 

