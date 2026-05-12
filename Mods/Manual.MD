# How to Compile a .so Mod File for MCPELauncher

> Assumes Android NDK r26 is already installed.

## Steps

**1. Add NDK to PATH (do this once)**
```bash
echo 'export PATH=$PATH:/usr/lib/android-ndk' >> ~/.bashrc
source ~/.bashrc
```

**2. Go to your mod-example folder**
```bash
cd mod-example
```

**3. Build the mod**
```bash
ndk-build
```

**4. Copy the `.so` to mods folder**
```bash
mkdir -p ~/.minecraft-bedrock/mods/
cp libs/x86/*.so ~/.minecraft-bedrock/mods/
```

**5. Launch the game — mod loads automatically ✅**

---

## One Liner

```bash
mkdir -p mods && cd mod-example && ndk-build && cp libs/x86/* ~/.minecraft-bedrock/mods/
```
