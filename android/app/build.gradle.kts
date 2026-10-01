import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Firebase / FCM. The google-services plugin hard-fails the build when
// `google-services.json` is missing, so apply it only once the file is present.
// Drop the Firebase-downloaded file at android/app/google-services.json (it must
// contain every applicationId variant — base, .dev and .staging) and FCM then
// activates automatically; without it the app still builds and runs (push off).
if (rootProject.file("app/google-services.json").exists()) {
    apply(plugin = "com.google.gms.google-services")
}

// Release signing is read from android/key.properties (git-ignored). When that
// file is absent (e.g. a fresh checkout, CI without secrets) we fall back to the
// debug keystore so the project still builds — but such a build is NOT
// shippable. See android/key.properties.example.
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
val hasReleaseKeystore = keystorePropertiesFile.exists()
if (hasReleaseKeystore) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.planovar.planovar_client"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.planovar.planovar_client"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // ── Environment flavors ────────────────────────────────────────────────
    // dev / staging get suffixed application IDs so all three can be installed
    // side by side on one device; prod keeps the clean base ID. The visible app
    // name comes from the per-flavor `app_name` string resource (referenced by
    // android:label in AndroidManifest.xml).
    flavorDimensions += "env"
    productFlavors {
        create("dev") {
            dimension = "env"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "Planovar Client [DEV]")
            // OAuth deep-link scheme (see AndroidManifest.xml + config/dev.json).
            manifestPlaceholders["oauthScheme"] = "planovardev"
        }
        create("staging") {
            dimension = "env"
            applicationIdSuffix = ".staging"
            versionNameSuffix = "-staging"
            resValue("string", "app_name", "Planovar Client [STAGING]")
            manifestPlaceholders["oauthScheme"] = "planovarstaging"
        }
        create("prod") {
            dimension = "env"
            resValue("string", "app_name", "Planovar Client")
            manifestPlaceholders["oauthScheme"] = "planovar"
        }
    }

    signingConfigs {
        create("release") {
            if (hasReleaseKeystore) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = (keystoreProperties["storeFile"] as String?)?.let { file(it) }
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (hasReleaseKeystore) {
                signingConfigs.getByName("release")
            } else {
                // Not shippable — see key.properties.example.
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}
