if [ $# -lt 1 ]; then
   echo "Usage: $0 <code signing identity>"

   echo "\n\nYour identities are:"
   security find-identity -v -p codesigning
   exit 1
fi

identity=$1

echo "Code signing libs with identity = $identity"

for dylibPath in lib/*.dylib; do
   if ! [[ -L "$dylibPath" ]]; then
      echo "Signing $dylibPath...\c"
      codesign -s $identity $dylibPath

      # See if we succeeded
      codesign -v $dylibPath
      if [ $? -eq 0 ]; then
         echo "success"
      else
         echo "FAILED validation"
      fi
   fi
done
