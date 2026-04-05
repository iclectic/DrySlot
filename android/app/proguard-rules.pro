# ============================================================================
# Dry Slots — Proguard / R8 keep rules for release builds
# ============================================================================

# --- Flutter ---
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# --- Hive ---
# Hive uses reflection for type adapters registered at runtime.
-keep class ** extends com.google.protobuf.GeneratedMessageLite { *; }
-keepclassmembers class ** implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# --- flutter_local_notifications ---
-keep class com.dexterous.** { *; }

# --- Workmanager ---
-keep class be.tramckrijte.workmanager.** { *; }

# --- Sentry ---
-keep class io.sentry.** { *; }
-keepclassmembers class io.sentry.** { *; }

# --- Dio / OkHttp (underlying HTTP) ---
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep class okio.** { *; }

# --- Geolocator ---
-keep class com.baseflow.geolocator.** { *; }

# --- Permission handler ---
-keep class com.baseflow.permissionhandler.** { *; }

# --- share_plus ---
-keep class dev.fluttercommunity.plus.share.** { *; }

# --- home_widget ---
-keep class es.antonborri.home_widget.** { *; }

# --- package_info_plus ---
-keep class dev.fluttercommunity.plus.packageinfo.** { *; }

# --- General: keep annotations used by JSON serialization ---
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod
