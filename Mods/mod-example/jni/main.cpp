#include <jni.h>
#include <string>

extern "C" JNIEXPORT jstring JNICALL
Java_com_mojang_minecraftpe_MainActivity_getModAction(JNIEnv* env, jobject /* this */) {
    return env->NewStringUTF("Actions Mod Loaded Successfully");
}
