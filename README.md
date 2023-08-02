# ThirdParty-GTK-vcpkg
This repo contains instructions and scripts to build Pango and its GTK-related dependencies using vcpkg.

## Windows build

Using bash:

```
git clone https://github.com/TechSmith/vcpkg
./vcpkg/bootstrap-vcpkg.sh
./vcpkg/vcpkg.exe install pango:x64-windows-dynamic-release
```

The built libraries and headers will be in `vcpkg/installed/x64-windows-dynamic-release`

## Mac build

```
git clone https://github.com/TechSmith/vcpkg
./vcpkg/bootstrap-vcpkg.sh 
./vcpkg/vcpkg install pango:x64-osx-dynamic-release
./vcpkg/vcpkg install pango:arm64-osx-dynamic-release

git clone https://github.com/TechSmith/ThirdParty-GTK-vcpkg
sh ThirdParty-GTK-vcpkg/makeUniversalBinary.sh
```

The built libraries and headers will be in `universal`
