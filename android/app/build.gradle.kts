import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") // Correct Kotlin DSL ID
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    id("com.google.firebase.firebase-perf")
}

// --- Load local.properties for flutter versionCode/versionName ---
val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localProperties.load(FileInputStream(localPropertiesFile))
}

val flutterVersionCode = localProperties.getProperty("flutter.versionCode") ?: "1"
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

// --- Load key.properties for signing ---
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

tasks.register("printApkPaths") {
    group = "help"
    description = "Print all APKs under build/outputs"
    doLast {
        val outDir = layout.buildDirectory.dir("outputs").get().asFile
        println("APK outputs under: ${outDir.absolutePath}")
        outDir.walkTopDown()
            .filter { it.isFile && it.extension == "apk" }
            .forEach { println(" - " + it.relativeTo(outDir)) }
    }
}

android {
    namespace = "com.drs.manzil"
    compileSdk = 36
    ndkVersion = "29.0.13113456"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    sourceSets["main"].java.srcDirs("src/main/kotlin")

    defaultConfig {
        applicationId = "com.drs.manzil"
        minSdk = 24
        targetSdk = 36
        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName
        multiDexEnabled = true

        ndk {
            abiFilters.addAll(listOf("armeabi-v7a", "arm64-v8a", "x86", "x86_64"))
        }
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.toString()?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
            // proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }

    flavorDimensions += "none"
    productFlavors {
        create("prod") {
            // no change to applicationId
        }
    }

    splits {
        abi {
            isEnable = true
            reset()
            include("armeabi-v7a", "arm64-v8a", "x86", "x86_64")
            isUniversalApk = true
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(kotlin("stdlib"))
    // implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk7:2.1.21")
    implementation(platform("com.google.firebase:firebase-bom:34.3.0"))
    implementation("com.google.firebase:firebase-storage")
    implementation("com.google.firebase:firebase-crashlytics")
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-perf:20.0.3")

    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.squareup.okhttp3:okhttp:4.8.0")

    // ML Kit (keep if you really need this exact artifact)
    implementation("com.google.mlkit:text-recognition-devanagari:16.0.0")

    // Desugaring lib (matches isCoreLibraryDesugaringEnabled above)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:1.1.5")

    // Multidex (optional, if methods exceed 64K)
    implementation("androidx.multidex:multidex:2.0.1")
    // Uncomment if needed:
    // implementation("com.paytm.appinvokesdk:appinvokesdk:1.5.4") {
    //     exclude(group = "com.squareup.okhttp3", module = "okhttp3")
    // }
    // implementation("com.paytm:pgplussdk:1.3.3")
}
