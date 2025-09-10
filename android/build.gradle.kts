allprojects {
    repositories {
        google()
        maven { url = uri("https://maven-central-asia.storage-download.googleapis.com/") }
        mavenCentral()
    }
}

buildscript {
    repositories {
        google()
        maven { url = uri("https://maven-central-asia.storage-download.googleapis.com/") }
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
