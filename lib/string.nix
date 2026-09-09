lib: with builtins; {
  hexToUpper = replaceStrings [ "a" "b" "c" "d" "e" "f" ] [ "A" "B" "C" "D" "E" "F" ];
  stringHead = builtins.substring 0 1;
  stringTail = string: builtins.substring 1 (builtins.stringLength string - 1) string;
  capitalize = string: lib.toUpper (stringHead string) + stringTail string;
}
