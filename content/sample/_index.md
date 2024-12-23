---
title: "Software Supply Chain"
date: 2017-10-17T15:26:15Z
draft: false
weight: 10
description: "Supply chain"
---

![Supply chain](/images/supply.png )

Almost all software is expected to have bugs, and some bugs impact security. If you are lucky the bug is detected early in the supply chain.  If the bug is detected after deployment the product must be designed for updates.  If the bug is related to hardware, mitigation includes the replacement of the physical product. Applications reside on the top of the product stack and reflect the usage domain.  Medical devices must comply with another set of requirements than toys. Vulnerabilities are bugs that impact security and could result in the leakage of sensitive data.  The purpose of the table below is to map different mindsets across the product and also how to handle bugs. 
Middleware and hypervisors are excluded. 


| Product layer | Requirement | Development focus    | Handle errors | 
|---------------|-------------|----------------------|---------------|
| Applications Microservice  | Functional  | [Binary distribution](https://www.alpinelinux.org/) | Update POD/Application/App  | 
| Operating System  | Functional  | [Build System](https://www.kernel.org/doc/html/latest/process/development-process.html)  | Backup, Update , Restore   | 
| Firmware (FLASH) | Functional  | Test  | Update   | 
| Firmware (ROM) | [Do It Right](https://www.synopsys.com/blogs/software-security/apollo-11-software-development.html)  | Extensive Test  | Not applicable  | 
| Hardware | Price, Performance | Extensive Test  | [Errata](https://www.kernel.org/doc/html/v5.16/arm64/silicon-errata.html)  | 

**Limit the scope**

Serving static content seems to be a no-brainer in the era of artificial intelligence, but software updates are crucial for the digital society. Attackers could prevent updates from taking place by directing a denial of service attack against the server that provides updated images. 
This website is another example of static content, with no cookies to accept, just pure information. Dynamic web services are by nature more vulnerable since each page request requires database operation. 

**Cybersecurity Resilience Act and Secure Supply Chains**

Platform components distributed to billions of endpoints must be updated remotely  [CRA and article 11](https://digital-strategy.ec.europa.eu/en/library/cyber-resilience-act) which also triggers 
another EU regulation [NIS2](https://www.europarl.europa.eu/RegData/etudes/BRIE/2021/689333/EPRS_BRI(2021)689333_EN.pdf)

**Article 11**

*A secure Internet is indispensable for the functioning of critical infrastructures and for 
society as a whole. [Directive XXX/XXXX (NIS2)] aims at ensuring a high level of 
cybersecurity of services provided by essential and important entities, including digital 
infrastructure providers that support core functions of the open Internet, ensure 
Internet access and Internet services. It is therefore important that the products with 
digital elements necessary for digital infrastructure providers to ensure the functioning 
of the Internet are developed in a secure manner and that they comply with well␂established Internet security standards. This Regulation, which applies to all 
connectable hardware and software products, also aims at facilitating the compliance 
of digital infrastructure providers with the supply chain requirements under the 
[Directive XXX/XXXX (NIS2)] by ensuring that the products with digital elements 
that they use for the provision of their services are developed in a secure manner and 
that they have access to **timely security updates** for such products.*


















