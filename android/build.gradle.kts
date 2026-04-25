allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Silence JDK warning spam from some transitive Android modules/plugins that still compile with
// -source/-target 8 (common in Flutter/Android plugin dependencies).
// This does not change compilation targets; it only suppresses the "options ... obsolete" warning.
subprojects {
    tasks.withType<JavaCompile>().configureEach {
        options.compilerArgs.add("-Xlint:-options")
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
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
