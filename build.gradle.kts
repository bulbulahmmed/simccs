/*
 * This file was generated by the Gradle 'init' task.
 *
 * This generated file contains a sample Java application project to get you started.
 * For more details take a look at the 'Building Java & JVM projects' chapter in the Gradle
 * User Manual available at https://docs.gradle.org/6.8.3/userguide/building_java_projects.html
 */

plugins {
    id("application")
    id("org.openjfx.javafxplugin") version "0.0.9"
    id("com.github.johnrengelman.shadow") version "6.1.0"
}

application {
    // Define the main class for the application.
    mainClass.set("gui.Gui")
    applicationDefaultJvmArgs = listOf(
        "--add-modules=ALL-MODULE-PATH",
        "--add-exports", "javafx.graphics/com.sun.javafx.sg.prism=ALL-UNNAMED",
        "--add-exports", "jdk.compiler/com.sun.tools.javac.code=ALL-UNNAMED"
    )
}

//tasks {
//    run {
//        debugOptions.enabled = true
//        debugOptions.port = 5050
//        debugOptions.server = true
//        debugOptions.suspend = false
//    }
//}

//task runApp(type: JavaExec) {
//   debugOptions {
//       enabled = true
//       port = 5566
//       server = true
//       suspend = false
//   }
//}

javafx {
    modules("javafx.controls", "javafx.fxml", "javafx.swing", "javafx.base", "javafx.graphics", "javafx.web")
}

repositories {
    maven {
        url = uri("https://jitpack.io")
    }
    mavenCentral()
}

dependencies {
    testImplementation("junit:junit:4.13")
    implementation("com.google.guava:guava:29.0-jre")
    implementation("com.github.OpenMap-java:openmap:v5.1.15")
}

java {
    modularity.inferModulePath.set(true)
}
