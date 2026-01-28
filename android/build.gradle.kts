allprojects {
    repositories {
        google()
        mavenCentral()
    }
    
    // Configure JVM target for all projects early
    afterEvaluate {
        // Configure Kotlin compilation
        tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
            kotlinOptions {
                jvmTarget = "17"
            }
        }
        
        // Configure Java compilation
        tasks.withType<JavaCompile>().configureEach {
            sourceCompatibility = "17"
            targetCompatibility = "17"
        }
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    
    afterEvaluate {
        // Configure Android extension if it exists (for Android library/application modules)
        try {
            val androidExtension = extensions.findByName("android")
            if (androidExtension != null) {
                val compileOptions = androidExtension.javaClass.getMethod("getCompileOptions").invoke(androidExtension)
                val javaVersion17 = JavaVersion.VERSION_17
                compileOptions?.javaClass?.getMethod("setSourceCompatibility", Any::class.java)?.invoke(compileOptions, javaVersion17)
                compileOptions?.javaClass?.getMethod("setTargetCompatibility", Any::class.java)?.invoke(compileOptions, javaVersion17)
            }
        } catch (e: Exception) {
            // Android extension might not exist or have different structure, continue
        }
        
        // Ensure consistent JVM target across all subprojects
        tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
            kotlinOptions {
                jvmTarget = "17"
            }
        }
        
        // Also configure Java compilation tasks directly
        tasks.withType<JavaCompile>().configureEach {
            sourceCompatibility = "17"
            targetCompatibility = "17"
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
