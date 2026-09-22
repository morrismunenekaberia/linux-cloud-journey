# Java 25 Installation — Ubuntu

## Overview

Install **OpenJDK 25 JRE** for running Java applications and **OpenJDK 25 JDK** for Java development.

Ubuntu 24.04 provides both `openjdk-25-jre` and `openjdk-25-jdk` packages.

## 1. Update Ubuntu

```bash
sudo apt update
```

## 2. Install Java 25 JRE

The **JRE (Java Runtime Environment)** is used to run Java applications.

```bash
sudo apt install openjdk-25-jre
```

Verify:

```bash
java --version
```
output will show Java 25:

```text
openjdk 25.0.4.1 2026-08-18
OpenJDK Runtime Environment (build 25.0.4.1+1-1-24.04.4-Ubuntu)
OpenJDK 64-Bit Server VM (build 25.0.4.1+1-1-24.04.4-Ubuntu, mixed mode, sharing)

```

## 3. Install Java 25 JDK

The **JDK (Java Development Kit)** provides the tools needed to develop Java applications, including the Java compiler (`javac`).

```bash
sudo apt install openjdk-25-jdk
```

Verify:

```bash
javac --version
```

Expected:

```text
javac 25.0.4.1

```

Also verify the runtime:

```bash
java --version
```

## 4. Check Java Location

```bash
which java
```

```bash
which javac
```

Typical locations:

```text
/usr/bin/java
/usr/bin/javac
```

## 5. Check Installed Java Versions

```bash
update-java-alternatives --list
```

Check the active versions:

```bash
java --version
javac --version
```

## JRE vs JDK

| Component | Purpose |
|---|---|
| JRE | Runs Java applications |
| JDK | Develops and runs Java applications |
| `java` | Runs Java programs |
| `javac` | Compiles Java source code |

For Java development, **JDK 25 is the important installation** because it provides the runtime and development tools.

## Quick Installation

Install both:

```bash
sudo apt update
sudo apt install openjdk-25-jre openjdk-25-jdk
```

Verify:

```bash
java --version
javac --version
```

## Installation Record

- [x] OpenJDK 25 JRE
- [x] OpenJDK 25 JDK
- [x] Java runtime verified
- [x] Java compiler verified

## Related Documentation

Java can be used with development tools such as VS Code and IntelliJ IDEA.
